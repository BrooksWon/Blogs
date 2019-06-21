## 在iOS Category重写原类方法中调用原类方法

#### 一、先从category如何加载说起

> 笑脸😊注释的地方为关键节点

我们知道，Objective-C的运行是依赖OC的runtime的，而OC的runtime和其他系统库一样，是OS X和iOS通过dyld动态加载的。

想了解更多dyld地同学可以移步这里[link](https://www.mikeash.com/pyblog/friday-qa-2012-11-09-dyld-dynamic-linking-on-os-x.html)。

对于OC运行时，入口方法如下（在objc-os.mm文件中）：

```
void _objc_init(void)
{
    static bool initialized = false;
    if (initialized) return;
    initialized = true;

    // fixme defer initialization until an objc-using image is found?
    environ_init();
    tls_init();
    lock_init();
    exception_init();

    // Register for unmap first, in case some +load unmaps something
    _dyld_register_func_for_remove_image(&unmap_image);
    dyld_register_image_state_change_handler(dyld_image_state_bound,
                                             1/*batch*/, &map_images);// 看这里😊A
    dyld_register_image_state_change_handler(dyld_image_state_dependents_initialized, 0/*not batch*/, &load_images);
}
```
category被附加到类上面是在map_images的时候发生的，在new-ABI的标准下，_objc_init里面的调用的map_images最终会调用objc-runtime-new.mm里面的_read_images方法，如下:

```
void _read_images(header_info **hList, uint32_t hCount, int totalClasses, int unoptimizedTotalClasses)
{
  ...省略...
  
  // 由编译器读取类列表，并将所有类添加到类的哈希表中，并且标记懒加载的类并初始化内存空间
    for (EACH_HEADER) {
        if (! mustReadClasses(hi)) {
            // Image is sufficiently optimized that we need not call readClass()
            continue;
        }

        bool headerIsBundle = hi->isBundle();
        bool headerIsPreoptimized = hi->isPreoptimized();

        /** 将新类添加到哈希表中 */
        
        // 从编译后的类列表中取出所有类，获取到的是一个classref_t类型的指针
        classref_t *classlist = _getObjc2ClassList(hi, &count);
        for (i = 0; i < count; i++) {
            // 数组中会取出OS_dispatch_queue_concurrent、OS_xpc_object、NSRunloop等系统类，例如CF、Fundation、libdispatch中的类。以及自己创建的类
            Class cls = (Class)classlist[i];
            // 通过readClass函数获取处理后的新类，内部主要操作ro和rw结构体
            Class newCls = readClass(cls, headerIsBundle, headerIsPreoptimized);

            // 初始化所有懒加载的类需要的内存空间
            if (newCls != cls  &&  newCls) {
                // 将懒加载的类添加到数组中
                resolvedFutureClasses = (Class *)
                    realloc(resolvedFutureClasses, 
                            (resolvedFutureClassCount+1) * sizeof(Class));
                resolvedFutureClasses[resolvedFutureClassCount++] = newCls;
            }
        }
    }

    ts.log("IMAGE TIMES: discover classes");
    
    // 将未映射Class和Super Class重映射，被remap的类都是非懒加载的类
    if (!noClassesRemapped()) {
        for (EACH_HEADER) {
            // 重映射Class，注意是从_getObjc2ClassRefs函数中取出类的引用
            Class *classrefs = _getObjc2ClassRefs(hi, &count);
            for (i = 0; i < count; i++) {
                remapClassRef(&classrefs[i]);
            }
            // 重映射父类
            classrefs = _getObjc2SuperRefs(hi, &count);
            for (i = 0; i < count; i++) {
                remapClassRef(&classrefs[i]);
            }
        }
    }

    ts.log("IMAGE TIMES: remap classes");

    // 将所有SEL都注册到哈希表中，是另外一张哈希表
    static size_t UnfixedSelectors;
    sel_lock();
    for (EACH_HEADER) {
        if (hi->isPreoptimized()) continue;

        bool isBundle = hi->isBundle();
        // 取出的是字符串数组，例如首地址是"class"
        SEL *sels = _getObjc2SelectorRefs(hi, &count);
        UnfixedSelectors += count;
        for (i = 0; i < count; i++) {
            // sel_cname函数内部就是将SEL强转为常量字符串
            const char *name = sel_cname(sels[i]);
            // 注册SEL的操作
            sels[i] = sel_registerNameNoLock(name, isBundle);
        }
    }
    sel_unlock();

    ts.log("IMAGE TIMES: fix up selector references");

#if SUPPORT_FIXUP
    // 修复旧的函数指针调用遗留
    for (EACH_HEADER) {
        message_ref_t *refs = _getObjc2MessageRefs(hi, &count);
        if (count == 0) continue;

        if (PrintVtables) {
            _objc_inform("VTABLES: repairing %zu unsupported vtable dispatch "
                         "call sites in %s", count, hi->fname());
        }
        for (i = 0; i < count; i++) {
            // 内部将常用的alloc、objc_msgSend等函数指针进行注册，并fix为新的函数指针
            fixupMessageRef(refs+i);
        }
    }

    ts.log("IMAGE TIMES: fix up objc_msgSend_fixup");
#endif

    // 遍历所有协议列表，并且将协议列表加载到Protocol的哈希表中
    for (EACH_HEADER) {
        extern objc_class OBJC_CLASS_$_Protocol;
        // cls = Protocol类，所有协议和对象的结构体都类似，isa都对应Protocol类
        Class cls = (Class)&OBJC_CLASS_$_Protocol;
        assert(cls);
        // 获取protocol哈希表
        NXMapTable *protocol_map = protocols();
        bool isPreoptimized = hi->isPreoptimized();
        bool isBundle = hi->isBundle();

        // 从编译器中读取并初始化Protocol
        protocol_t **protolist = _getObjc2ProtocolList(hi, &count);
        for (i = 0; i < count; i++) {
            readProtocol(protolist[i], cls, protocol_map, 
                         isPreoptimized, isBundle);
        }
    }

    ts.log("IMAGE TIMES: discover protocols");
    
    // 修复协议列表引用，优化后的images可能是正确的，但是并不确定
    for (EACH_HEADER) {
        // 需要注意到是，下面的函数是_getObjc2ProtocolRefs，和上面的_getObjc2ProtocolList不一样
        protocol_t **protolist = _getObjc2ProtocolRefs(hi, &count);
        for (i = 0; i < count; i++) {
            remapProtocolRef(&protolist[i]);
        }
    }

    ts.log("IMAGE TIMES: fix up @protocol references");

    // 实现非懒加载的类，对于load方法和静态实例变量
    for (EACH_HEADER) {
        classref_t *classlist = 
            _getObjc2NonlazyClassList(hi, &count);
        for (i = 0; i < count; i++) {
            Class cls = remapClass(classlist[i]);
            if (!cls) continue;

            // hack for class __ARCLite__, which didn't get this above
#if TARGET_OS_SIMULATOR
            if (cls->cache._buckets == (void*)&_objc_empty_cache  &&  
                (cls->cache._mask  ||  cls->cache._occupied)) 
            {
                cls->cache._mask = 0;
                cls->cache._occupied = 0;
            }
            if (cls->ISA()->cache._buckets == (void*)&_objc_empty_cache  &&  
                (cls->ISA()->cache._mask  ||  cls->ISA()->cache._occupied)) 
            {
                cls->ISA()->cache._mask = 0;
                cls->ISA()->cache._occupied = 0;
            }
#endif

            // 实现所有非懒加载的类(实例化类对象的一些信息，例如rw)
            realizeClass(cls);
        }
    }

    ts.log("IMAGE TIMES: realize non-lazy classes");

    // 遍历resolvedFutureClasses数组，实现所有懒加载的类
    if (resolvedFutureClasses) {
        for (i = 0; i < resolvedFutureClassCount; i++) {
            // 实现懒加载的类
            realizeClass(resolvedFutureClasses[i]);
            resolvedFutureClasses[i]->setInstancesRequireRawIsa(false/*inherited*/);
        }
        free(resolvedFutureClasses);
    }    

    ts.log("IMAGE TIMES: realize future classes");

    // 发现和处理所有Category
    for (EACH_HEADER) {
        // 外部循环遍历找到当前类，查找类对应的Category数组
        category_t **catlist = 
            _getObjc2CategoryList(hi, &count);
        bool hasClassProperties = hi->info()->hasCategoryClassProperties();

        // 内部循环遍历当前类的所有Category
        for (i = 0; i < count; i++) {
            category_t *cat = catlist[i];
            Class cls = remapClass(cat->cls);
            
            if (!cls) {
                catlist[i] = nil;
                if (PrintConnecting) {
                    _objc_inform("CLASS: IGNORING category \?\?\?(%s) %p with "
                                 "missing weak-linked target class", 
                                 cat->name, cat);
                }
                continue;
            }
 
            // 首先，通过其所属的类注册Category。如果这个类已经被实现，则重新构造类的方法列表。
            bool classExists = NO;
            if (cat->instanceMethods ||  cat->protocols  
                ||  cat->instanceProperties) 
            {
                // 将Category添加到对应Class的value中，value是Class对应的所有category数组
                addUnattachedCategoryForClass(cat, cls, hi);
                // 将Category的method、protocol、property添加到Class
                if (cls->isRealized()) {
                    remethodizeClass(cls);//看这里😊B: 将Category的method等添加到Class
                    classExists = YES;
                }
                if (PrintConnecting) {
                    _objc_inform("CLASS: found category -%s(%s) %s", 
                                 cls->nameForLogging(), cat->name, 
                                 classExists ? "on existing class" : "");
                }
            }

            // 这块和上面逻辑一样，区别在于这块是对Meta Class做操作，而上面则是对Class做操作
            // 根据下面的逻辑，从代码的角度来说，是可以对原类添加Category的
            if (cat->classMethods  ||  cat->protocols  
                ||  (hasClassProperties && cat->_classProperties)) 
            {
                addUnattachedCategoryForClass(cat, cls->ISA(), hi);
                if (cls->ISA()->isRealized()) {
                    remethodizeClass(cls->ISA());
                }
                if (PrintConnecting) {
                    _objc_inform("CLASS: found category +%s(%s)", 
                                 cls->nameForLogging(), cat->name);
                }
            }
        }
    }
    
  ...省略...
}
```
**以上可以看出:类加载的顺序优先于类别, 因此类别的内存地址要高于原类**


接着看remethodizeClass内部实现

```
static void remethodizeClass(Class cls)
{

    ...省略...

     attachCategories(cls, cats, true /*flush caches*/);//看这里😊C: 将Category的信息添加到Class，包含method、property、protocol

    ...省略...
        
}
```

接着看attachCategories内部实现

```
// 获取到Category的Protocol list、Property list、Method list，然后通过attachLists函数添加到所属的类中

static void 
attachCategories(Class cls, category_list *cats, bool flush_caches)
{
    if (!cats) return;
    if (PrintReplacedMethods) printReplacements(cls, cats);

    bool isMeta = cls->isMetaClass();

    // 按照Category个数，分配对应的内存空间
    // fixme rearrange to remove these intermediate allocations
    method_list_t **mlists = (method_list_t **)
        malloc(cats->count * sizeof(*mlists));
    property_list_t **proplists = (property_list_t **)
        malloc(cats->count * sizeof(*proplists));
    protocol_list_t **protolists = (protocol_list_t **)
        malloc(cats->count * sizeof(*protolists));

    // Count backwards through cats to get newest categories first
    int mcount = 0;
    int propcount = 0;
    int protocount = 0;
    int i = cats->count;
    bool fromBundle = NO;
    
    // 循环查找出Protocol list、Property list、Method list
    while (i--) {
        auto& entry = cats->list[i];

        method_list_t *mlist = entry.cat->methodsForMeta(isMeta);
        if (mlist) {
            mlists[mcount++] = mlist;
            fromBundle |= entry.hi->isBundle();
        }

        property_list_t *proplist = 
            entry.cat->propertiesForMeta(isMeta, entry.hi);
        if (proplist) {
            proplists[propcount++] = proplist;
        }

        protocol_list_t *protolist = entry.cat->protocols;
        if (protolist) {
            protolists[protocount++] = protolist;
        }
    }

    auto rw = cls->data();

    // 执行添加操作
    prepareMethodLists(cls, mlists, mcount, NO, fromBundle);//看这里😊D:
    rw->methods.attachLists(mlists, mcount);//最后看这里😊K: 将排序后的所有类别的方法列表交给原类
    free(mlists);
    if (flush_caches  &&  mcount > 0) flushCaches(cls);

    rw->properties.attachLists(proplists, propcount);
    free(proplists);

    rw->protocols.attachLists(protolists, protocount);
    free(protolists);
}
```

接着看prepareMethodLists内部实现

```
static void 
prepareMethodLists(Class cls, method_list_t **addedLists, int addedCount, 
                   bool baseMethods, bool methodsFromBundle)
{
    ...省略...
    
        // Fixup selectors if necessary
        if (!mlist->isFixedUp()) {
            fixupMethodList(mlist, methodsFromBundle, true/*sort*/); //看这里😊F:
        }

    ...省略...
}
```

接着看fixupMethodList内部实现

```
static void 
fixupMethodList(method_list_t *mlist, bool bundleCopy, bool sort)
{
    ...省略...


    // Sort by selector address.
    if (sort) {
        method_t::SortBySELAddress sorter;
        std::stable_sort(mlist->begin(), mlist->end(), sorter);//看这里😊G:将所有类别的方法列表排序
    }
    
    ...省略...
}
```

然后最终调用__stable_sort

```
__stable_sort(_RandomAccessIterator __first, _RandomAccessIterator __last, _Compare __comp,
              typename iterator_traits<_RandomAccessIterator>::difference_type __len,
              typename iterator_traits<_RandomAccessIterator>::value_type* __buff, ptrdiff_t __buff_size)
{
    typedef typename iterator_traits<_RandomAccessIterator>::value_type value_type;
    typedef typename iterator_traits<_RandomAccessIterator>::difference_type difference_type;
    switch (__len)
    {
    case 0:
    case 1:
        return;
    case 2:
        if (__comp(*--__last, *__first))
            swap(*__first, *__last);//看这里😊H:根据方法列表的内存地址降序排列. 类别加载越早、其方法列表的内存地址越小、越排在后面.
        return;
    }
    
    
    ...省略...
}

```

接下来,回到😊K处的`rw->methods.attachLists(mlists, mcount);`

别急、真的是最后一次看代码了, 哈哈! 如下:


```
void attachLists(List* const * addedLists, uint32_t addedCount) {
        if (addedCount == 0) return;

        if (hasArray()) {
            // many lists -> many lists
            uint32_t oldCount = array()->count;
            uint32_t newCount = oldCount + addedCount;
            setArray((array_t *)realloc(array(), array_t::byteSize(newCount)));
            array()->count = newCount;
            memmove(array()->lists + addedCount, array()->lists, 
                    oldCount * sizeof(array()->lists[0]));//看这里😊L:先将原来的方法列表放在后面
            memcpy(array()->lists, addedLists, 
                   addedCount * sizeof(array()->lists[0]));//看这里😊M:然后将后进来的方法列表插在前面
        }
        else if (!list  &&  addedCount == 1) {
            // 0 lists -> 1 list
            list = addedLists[0];//看这里😊N: 若当前方法列表为空且此时进来的方法列表个数为1时, 当前方法列表的指针直接指向此时进来的方法列表的首地址.
        } 
        else {
            // 1 list -> many lists
            List* oldList = list;
            uint32_t oldCount = oldList ? 1 : 0;
            uint32_t newCount = oldCount + addedCount;
            setArray((array_t *)malloc(array_t::byteSize(newCount)));
            array()->count = newCount;
            if (oldList) array()->lists[addedCount] = oldList;/看这里😊O: 若当前仅有1个方法列表,则将它放在后面.
            memcpy(array()->lists, addedLists, 
                   addedCount * sizeof(array()->lists[0]));//看这里😊P:然后将后进来的方法列表插在前面
        }
    }

```


**从以上调用顺序可以看出:**

* 类和类别的方法最后会合并在同一个的方法列表中;
* 类别的方法列表会排在原类方法列表的前面;
* 类别加载的加载顺序和方法列表中的方法顺序相反:先加载的类别、其方法在方法列表后, 后加载的类别、其方法在方法列表前.


#### 二、搞清楚category如何加载之后, 在iOS Category重写原类方法中调用原类方法就很简单了

当调用方法时会遍历方法列表、找到对应的响应子就返回，不再向下遍历。因为category的优先级高于类的优先级，使得原类中的选择子遍历不到。要调用原类的方法、只需要找到原类的方法即可.

*下面直接给例子的关键code*

Person 的 .m文件

```
@implementation Person
-(void)run {
    NSLog(@"Person run");
}
@end
```

Person Category 的 .m文件


```
@implementation Person (One)
-(void)run {
    NSLog(@"One run");
    
       u_int count;
       Method *methods = class_copyMethodList([self classForCoder], &count);
       NSInteger index = 0;
       for (int i=0; i<count; i++) {
           SEL sel = method_getName(methods[i]);
           NSString *method_name = [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
           if ([method_name isEqualToString:@"run"]) {
               index = i;//找到原类方法所在位置
               NSLog(@"method_name=%@, index=%@", method_name, @(index));
           }
       }
    
       SEL sel = method_getName(methods[index]);
       IMP imp = method_getImplementation(methods[index]);
    
      ((void (*)(id, SEL))imp)(self,sel);// 调用原类的方法
}
@end
```

欢迎指正 or 分享其他方案.



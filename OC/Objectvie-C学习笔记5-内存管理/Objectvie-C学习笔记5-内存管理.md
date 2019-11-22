[TOC]



# Objectvie-C学习笔记5-内存管理

## 定时器

### CADisplayLink、NSTimer使用注意

CADisplayLink、NSTimer会对target产生强引用，如果target又对它们产生强引用，那么就会引发循环引用。

循环引用图如下所示：

![Snip20191120_111](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_111.png)

怎么解决这个问题呢？解决方案如下：

方案1：使用**Block**解决NSTimer循环引用问题。

如下示例：

```objective-c
@interface ViewController ()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用Block解决NSTimer循环引用问题
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerTest];
    }];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
```



方案2：使用**代理对象**解决CADisplayLink、NSTimer循环引用问题。

使用代码对象解决循环引用的本质是：**VC强引用CADisplayLink/NSTimer，CADisplayLink/NSTimer强应用代理对象，代理对象弱引用VC**。如下图所示（CADisplayLink同NSTimer）：

![Snip20191120_112](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_112.png)

①**使用普通的代理对象：代理对象继承自NSObject**。演示代码如下：

代理对象代码

```objective-c
//.h
@interface MyProxy : NSObject
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end

//-------分割线------

//.m
@implementation MyProxy

+ (instancetype)proxyWithTarget:(id)target
{
    MyProxy *proxy = [[MyProxy alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end
```

示例代码

```objective-c
@interface ViewController ()
@property (strong, nonatomic) CADisplayLink *link;//保证调用频率和屏幕的刷帧频率一致，60FPS
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用代理对象解决NSTimer循环引用问题
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:[MyProxy proxyWithTarget:self]
                                                selector:@selector(timerTest)
                                                userInfo:nil
                                                 repeats:YES];

    //使用代理对象解决CADisplayLink循环引用问题
    self.link = [CADisplayLink displayLinkWithTarget:[MyProxy proxyWithTarget:self]
                                            selector:@selector(linkTest)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)linkTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.link invalidate];
    [self.timer invalidate];
}

@end
```



②**使用NSProxy作为代理对象：代理对象继承自NSProxy**。演示代码如下：

代理对象代码

```objective-c
//.h
@interface MyProxy2 : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end

//.m
@implementation MyProxy2

+ (instancetype)proxyWithTarget:(id)target
{
    // NSProxy对象不需要调用init，因为它本来就没有init方法
    MyProxy2 *proxy = [MyProxy2 alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

@end
```

示例代码

```objective-c
@interface ViewController ()
@property (strong, nonatomic) CADisplayLink *link;//保证调用频率和屏幕的刷帧频率一致，60FPS
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //使用代理对象解决NSTimer循环引用问题
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:[MyProxy2 proxyWithTarget:self]
                                                selector:@selector(timerTest)
                                                userInfo:nil
                                                 repeats:YES];
    
    //使用代理对象解决CADisplayLink循环引用问题
    self.link = [CADisplayLink displayLinkWithTarget:[MyProxy2 proxyWithTarget:self]
                                            selector:@selector(linkTest)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)linkTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.link invalidate];
    [self.timer invalidate];
}

@end
```



### GCD定时器

NSTimer依赖于RunLoop，如果RunLoop的任务过于繁重，可能会导致NSTimer不准时。

而GCD的定时器直接操作系统内核，不依赖于RunLoop，会更加准时。

代码示例如下：

```objective-c
- (void)test
{
    
    // 队列
    //    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_queue_t queue = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    uint64_t start = 2.0; // 2秒后开始执行
    uint64_t interval = 1.0; // 每隔1秒执行
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    
    // 设置回调
    //    dispatch_source_set_event_handler(timer, ^{
    //        NSLog(@"1111");
    //    });
    dispatch_source_set_event_handler_f(timer, timerFire);
    
    // 启动定时器
    dispatch_resume(timer);
    
    self.timer = timer;
}

void timerFire(void *param)
{
    NSLog(@"2222 - %@", [NSThread currentThread]);
}
```



## iOS程序的内存布局

如下图所示：

![Snip20191120_113](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_113.png)



## Tagged Pointer

从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储。

- 在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值。


- 使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中。当指针不够存储数据时，才会使用动态分配内存的方式来存储数据。

如下图所示：

![Snip20191120_115](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_115.png)



注意：objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销。如下图所示：

![Snip20191120_117](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_117.png)





如何判断一个指针是否为Tagged Pointer？

- iOS平台，最高有效位是1（第64bit）。
- Mac平台，最低有效位是1。

如下图所示：

![Snip20191120_114](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_114.png)



## OC对象的内存管理

在iOS中，使用引用计数来管理OC对象的内存。

- 一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放其占用的内存空间。
- 调用retain会让OC对象的引用计数+1，调用release会让OC对象的引用计数-1。



内存管理的经验总结：

- 当调用alloc、new、copy、mutableCopy方法返回了一个对象，在不需要这个对象时，要调用release或者autorelease来释放它。
- 想拥有某个对象，就让它的引用计数+1；不想再拥有某个对象，就让它的引用计数-1。
- 可以通过以下私有函数来查看自动释放池的情况。`extern void _objc_autoreleasePoolPrint(void);`  



### copy与mutableCopy

如下图所示：

![Snip20191120_118](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_118.png)



### 引用计数的存储

在64bit中，引用计数可以直接存储在优化过的isa指针中，也可能存储在SideTable类中。

回顾一下isa，如下：

```objective-c
union isa_t 
{
    Class cls;
    uintptr_t bits;

    struct {
        /*
         0,代表普通的指针，存储着Class、Meta-Class对象的内存地址
         1,代表优化过，使用位域存储着更多信息
         */
        uintptr_t nonpointer        : 1;
        
        /*
        是否设置过关联对象，如果没有，释放时会更快
        */
        uintptr_t has_assoc         : 1;
        
        /*
        是否有C++的析构函数（.cxxdestruct），如果没有，释放时会更快
        */
        uintptr_t has_cxx_dtor      : 1;
        
        /*
        存储着Class、Meta-Class对象的内存地址
        */
        uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000
        
        /*
        用于在调试时分辨对象是否未完成初始化
        */
        uintptr_t magic             : 6;
        
        /*
        是否有被弱引用过，如果没有，释放时会更快
        */
        uintptr_t weakly_referenced : 1;
        
        /*
        对象是否正在释放
        */
        uintptr_t deallocating      : 1;

        /*
        引用计数是否过大无法存储在isa中；如果为1，那么引用计数会存储在一个叫SideTable的类的属性中
        */
        uintptr_t has_sidetable_rc  : 1;

        /*
        里面存储的值是：引用计数减1
        */
        uintptr_t extra_rc          : 19;
    };
};
```



SideTable结构如下图所示：

![Snip20191120_119](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_119.png)



### weak指针的原理

#### 先看原理：

被声明为**weak的对象obj**、在程序运行时会将其存到1个哈希表中（**表中存储的是该weak的对象obj的指针地址**）；当该weak对象Obj指向的**原对象originObj**要销毁的时候，哈希函数根据**原对象originObj**的地址获取到索引，然后从哈希表中取出**原对象originObj**对应的弱引用集合weak_entries，遍历weak_entries并一一清空（**将集合中存储的weak的对象obj的指针地址占用的空间释放、并将其设置为nil**）。



#### 接着看源码分析：

当一个对象要释放时，会自动调用dealloc，接下的调用轨迹是:

```objective-c
//当一个对象要释放时，会自动调用dealloc，接下的调用轨迹是
- (void)dealloc
{
    //看下1个函数👇
    _objc_rootDealloc(self);
}

void _objc_rootDealloc(id obj)
{
    //看下1个函数👇
    obj->rootDealloc();
}

inline void objc_object::rootDealloc()
{
    if (isTaggedPointer()) return; 

    if (fastpath(isa.nonpointer  &&
                 !isa.weakly_referenced  &&
                 !isa.has_assoc  &&
                 !isa.has_cxx_dtor  &&
                 !isa.has_sidetable_rc))
    {
        assert(!sidetable_present());
        free(this);
    }
    else {
        //看下1个函数👇
        object_dispose((id)this);
    }
}



id object_dispose(id obj)
{
    if (!obj) return nil;
    
    //看下1个函数👇
    objc_destructInstance(obj);
    
    //释放对象originObj的内存空间
    free(obj);

    return nil;
}

//1.当对象originObj被释放时、会调用该方法
void *objc_destructInstance(id obj)
{
    if (obj) {
        // Read all of the flags at once for performance.
        bool cxx = obj->hasCxxDtor();
        bool assoc = obj->hasAssociatedObjects();

        // This order is important.
        if (cxx) object_cxxDestruct(obj);//调用C++的析构函数
        if (assoc) _object_remove_assocations(obj);//移除自身的关联对象
        obj->clearDeallocating();//清除为origin对象分配内存空间
    }

    return obj;
}

inline void objc_object::clearDeallocating()
{
    //看下1个函数👇
    clearDeallocating_slow();
}

void objc_object::clearDeallocating_slow()
{

    //根据originObj地址拿到SideTable对象
    SideTable& table = SideTables()[this];
    
    //weakly_referenced表示是否有被弱引用过，如果没有，释放时会更快。
    //如果有被弱引用过、则进入弱引用清除流程
    if (isa.weakly_referenced) {
        
        //看下1个函数👇
        weak_clear_no_lock(&table.weak_table, (id)this);
    }
}


void weak_clear_no_lock(weak_table_t *weak_table, id referent_id)
{
    objc_object *referent = (objc_object *)referent_id;

    //根据originObj地址拿到弱引用数组entry
    //看下1个函数👇
    weak_entry_t *entry = weak_entry_for_referent(weak_table, referent);
    
    for (size_t i = 0; i < count; ++i) {
        //将弱引用数组entry中的弱引用设置为nil
        objc_object **referrer = referrers[i];
        *referrer = nil;
    }
    
    //将弱引用数组entry从weak_table中移除
    weak_entry_remove(weak_table, entry);
}

static weak_entry_t *weak_entry_for_referent(weak_table_t *weak_table, objc_object *referent)
{

    //从弱引用表对象weak_table_t中拿到弱引用对象weak_entry_t数组
    weak_entry_t *weak_entries = weak_table->weak_entries;

    
    //使用对象originObj地址、通过hash算法算出begin索引
    size_t begin = hash_pointer(referent) & weak_table->mask;
    size_t index = begin;
    size_t hash_displacement = 0;
    
    //当然根据获取到的begin索引得到的散列结果可能并不是对象originObj的，因为存在散列冲突，所以这里面有while ()循环判断当前index散列值的
    while (weak_table->weak_entries[index].referent != referent) {
        index = (index+1) & weak_table->mask;
        if (index == begin) bad_weak_table(weak_table->weak_entries);
        hash_displacement++;
        if (hash_displacement > weak_table->max_hash_displacement) {
            return nil;
        }
    }
    
    //有了这个当前对象originObj在散列表中的索引，就可以通过索引 index、获取当前对象originObj的弱引用数组了
    return &weak_table->weak_entries[index];
}

```



### AutoreleasePool原理

自动释放池的主要底层数据结构是：__AtAutoreleasePool、AutoreleasePoolPage。调用了autorelease的对象最终都是通过AutoreleasePoolPage对象来管理的。

①**AutoreleasePoolPage的结构**

![Snip20191120_122](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_122.png)

​     

- 每个AutoreleasePoolPage对象占用4096字节内存，除了用来存放它内部的成员变量，剩下的空间用来存放autorelease对象的地址。
- 所有的AutoreleasePoolPage对象通过**双向链表**的形式连接在一起；如下：

![Snip20191120_123](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_123.png)



- 调用push方法会将一个POOL_BOUNDARY入栈，并且返回其存放的内存地址。调用pop方法时传入一个POOL_BOUNDARY的内存地址，会从最后一个入栈的对象开始发送release消息，直到遇到这个POOL_BOUNDARY才停止。

- `id *next` 指向了下一个能存放autorelease对象地址的区域。 



举个例子🌰~感受下

示例代码如下：

```objective-c
extern void _objc_autoreleasePoolPrint(void);

int main(int argc, const char * argv[]) {

    @autoreleasepool {
        Person *obj1 = [[Person alloc] init];
        @autoreleasepool {
            Person *obj2 = [[Person alloc] init];
            @autoreleasepool {
                Person *obj3 = [[Person alloc] init];
              
              	//打印自动释放池里的东西
	              _objc_autoreleasePoolPrint();
            }
        }
    }
    
    return 0;
}
```

clang rewrite之后如下：

```c++
struct __AtAutoreleasePool {
    __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
    ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
    void * atautoreleasepoolobj;
};

extern void _objc_autoreleasePoolPrint(void);

int main(int argc, const char * argv[]) {

    /* @autoreleasepool */
    {
        __AtAutoreleasePool __autoreleasepool;
        Person *obj1 = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
        
        /* @autoreleasepool */
        {
            __AtAutoreleasePool __autoreleasepool;
            Person *obj2 = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
            
            /* @autoreleasepool */
            {
                __AtAutoreleasePool __autoreleasepool;
                Person *obj3 = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
              
              	//打印自动释放池里的东西
             	 _objc_autoreleasePoolPrint();
            }
        }
    }

    return 0;
}
```

简化之后：

```objective-c
struct __AtAutoreleasePool {
    __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
    ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
    void * atautoreleasepoolobj;
};

extern void _objc_autoreleasePoolPrint(void);

int main(int argc, const char * argv[]) {

    /* @autoreleasepool */
    {
        //第1个自动释放池做push
        atautoreleasepoolobj = objc_autoreleasePoolPush();
        
        Person *obj1 = [[Person alloc] init];
        
        /* @autoreleasepool */
        {
            //第2个自动释放池做push
            atautoreleasepoolobj = objc_autoreleasePoolPush();
            
            Person *obj2 = [[Person alloc] init];
            
            /* @autoreleasepool */
            {
                //第3个自动释放池做push
                atautoreleasepoolobj = objc_autoreleasePoolPush();
                
                Person *obj3 = [[Person alloc] init];
              
              	//打印自动释放池里的东西
                _objc_autoreleasePoolPrint();
                
                //第3个自动释放池做pop
                objc_autoreleasePoolPop(atautoreleasepoolobj);
            }
            
            //第2个自动释放池做pop
            objc_autoreleasePoolPop(atautoreleasepoolobj);
        }
        
        //第1个自动释放池做pop
        objc_autoreleasePoolPop(atautoreleasepoolobj);
    }

    return 0;
}
```

执行结果如下图所示：

![autorelease](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/autorelease.gif)

结果显示：

①

- 创建了1个AutoreleasePoolPage；
- 然后先push了1个POOL_BOUNDARY1、接着push了1个Person对象obj1，
- 又push了1个POOL_BOUNDARY2、接着push了1个Person对象obj2，
- 最后push了1个POOL_BOUNDARY3、接着push了1个Person对象obj3。

②

- obj3在第3个autoreleasepool大括号后释放（系统调用pop(POOL_BOUNDARY3)）并打印，
- 然后、是obj2在第2个autoreleasepool大括号后释放（系统调用pop(POOL_BOUNDARY2)）并打印，
- 最后、obj1在第1个autoreleasepool大括号后释放（系统调用pop(POOL_BOUNDARY1)）并打印。

3个Person对象的**dealloc**打印顺序和pop的POOL_BOUNDARY顺序一致。



#### runloop与autorelease

iOS在主线程的Runloop中注册了2个Observer：

- 第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()  。

- 第2个Observer：

  - 监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush() 。
  - 监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop() 。

  

如下图所示：

![Snip20191120_129](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_129.png)

确实注册了2个Observer，这2个Observer监听了什么事件呢？结合下图👇分析下

![Snip20191120_130](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_130.png)

第1个Observer监听的**activities = 0x1**就是 **kCFRunLoopEntry** 事件。

第2个Observer监听的**activities = 0xa0**就是 **kCFRunLoopBeforeWaiting** 和 **kCFRunLoopExit** 事件。



那么、还剩最后一个疑问，就是：当对监听的事件发生时会调用 **_wrapRunLoopWithAutoreleasePoolHandler** ，怎么判断最终调用的是objc_autoreleasePoolPush() 、还是objc_autoreleasePoolPop()呢？

其实、我们可以添加一个信号断点，通过根据反汇编代码的执行找到最终执行的函数，从而找出答案。

如下图所示：

![Snip20191120_131](https://github.com/BrooksWon/Blogs/blob/master/OC/Objectvie-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B05-%E5%86%85%E5%AD%98%E7%AE%A1%E7%90%86/Snip20191120_131.png)

请通过上述方式、自行验证各种监听的事件发生时：最终调用的objc_autoreleasePoolPush() 和objc_autoreleasePoolPop() 的情况。


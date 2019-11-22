[TOC]



# Objectvie-C学习笔记1-KVO/KVC/Category/关联对象/Block

准备工作：

①Core Foundation源码

②Runtime源码

③GNUstep源码

GNUstep是GNU计划的项目之一，它将Cocoa的OC库重新开源实现了一遍。虽然GNUstep不是苹果官方源码，但还是具有一定的参考价值。

源码地址：http://www.gnustep.org/resources/downloads.php）

## 面向对象

### Objectvie-C的本质

- 我们平时编写的Objective-C代码，底层实现其实都是C\C++代码。如下图：

![Snip20191111_1](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_1.png)

- 所以Objective-C的面向对象都是基于C\C++的数据结构实现的，Objective-C的对象、类主要是基于C\C++的结构体实现的。

- 我们可以通过命令：`xcrun  -sdk  iphoneos  clang  -arch  arm64  -rewrite-objc OC源文件 -o 输出的CPP文件`将Objective-C代码转换为C\C++代码；如果需要链接其他框架，使用 -framework 参数。比如 -framework UIKit 。

### Objectvie-C对象的本质

**NSObject的底层实现。**

 系统Foundation框架对NSObject的定义如下：

```objective-c
 @interface NSObject {
 		Class isa;
 }
 @end
```

 通过定义可以看出：**NSObject对象中只有1个成员变量isa**。

 然后、我们通过重写OC代码为cpp可以看看出NSObject的C/C++实现如下：

```objective-c
 struct NSObject_IMPL {
 		Class isa;
 };
```

 因此可以得出结论：**NSObject 对象是基于 C/C++的结构体struct实现的，且只有1个成员变量isa**。

 如果执行下面代码：

```
 NSObject *obj = [[NSObject alloc] init];
```

 那么、obj里面存储的显然是NSObject_IMPL结构体的内存地址，也就是isa的内存地址。下图可证明该结论。

![Snip20191111_2](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_2.png)



下面继续来看一下存在继承的情况：Person 继承自 NSObject。代码如下：

```objective-c
@interface Person : NSObject {
    @public
    NSInteger _no;
    NSInteger _age;
}
@end
```

通过clang rewrite之后Person的结构如下：

```objective-c
struct Person_IMPL {
    struct NSObject_IMPL NSObject_IVARS;
    NSInteger _no;
    NSInteger _age;
};
```

下面使用Person，代码如下：

```objective-c
Person *p = [[Person alloc] init];
p->_no = 4;
p->_age = 5;

struct Person_IMPL *p2 = (__bridge struct Person_IMPL *)p;
```

可以将结构体Person_IMPL的成员值打印一下。如下图：

![Snip20191111_4](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_4.png)

或者、通过VIew Memory窥探一下内存状态。如下图：

![Snip20191111_5](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_5.png)

 

总结：通过结构体 Person_IMPL 打印 或者 内存窥探，可以看出：Person 的实例对象p中存储着成员变量 `isa`、`_no`、`_age`的值 0x102016600、4、5；至于isa的值指向哪里？后面会学到（指向本类的类对象）。即**类的实例对象的成员变量的值在类的实例对象中存储**。



**1个对象占用多少内存空间呢？**

可以使用如下2个函数查看某个实例对象的内存：

- 创建一个实例对象，至少需要多少内存？

```objective-c
#import <objc/runtime.h>
class_getInstanceSize([NSObject class]);
```

- 创建一个实例对象，实际上分配了多少内存？

```c++
#import <malloc/malloc.h>
malloc_size((__bridge const void *)obj);
```



举例：Student继承Person，Person继承NSObject。clang rewrite 之后关系图如下：

![Snip20191111_14](file:///Users/Brooks/blog/blogs/OC/OC%E8%AF%AD%E6%B3%95/Snip20191111_14.png?lastModify=1573456704)

从上图可以分析出：（内存分配是16的整数倍）

- NSObject对象实际占用内存：8个字节；内存分配16个字节。
- Person对象实际占用内存：8+8 =  16 个字节；内存分配16个字节。
- Person对象实际占用内存：8+8+8 = 24 个字节；内存分配32个字节。

通过下面测试代码可以验证结论：

```objective-c
NSObject *o = [[NSObject alloc] init];
Person *p   = [[Person alloc] init];
Student *s  = [[Student alloc] init];

NSLog(@"%zu", class_getInstanceSize([o class])); //8
NSLog(@"%zu", class_getInstanceSize([p class])); //16
NSLog(@"%zu", class_getInstanceSize([s class])); //24

NSLog(@"%zu", malloc_size((__bridge const void *)(o)));//16
NSLog(@"%zu", malloc_size((__bridge const void *)(p)));//16
NSLog(@"%zu", malloc_size((__bridge const void *)(s)));//34
```



 或者、使用 View Memory 实时查看内存数据。这里不再演示了。



## OC对象的种类

**Objective-C中的对象，简称OC对象，主要可以分为3种**

- instance对象（实例对象）。
- class对象（类对象）。
- meta-class对象（元类对象） 。



###  **instance** 对象

instance对象就是通过类alloc出来的对象，每次调用alloc都会产生新的instance对象。

如下示例;

```objective-c
NSObject *obj1 = [[NSObject alloc] init];
NSObject *obj2 = [[NSObject alloc] init];
```

- obj1、obj2是NSObject的instance对象（实例对象）。
- 它们是不同的2个对象，分别占据着2块不同的内存。



**instance对象在内存中存储的信息包括：**

- **isa**指针；
- 其他**成员变量**。

如下示例：

```objective-c
@interface Person : NSObject {
    @public
    NSInteger _age;
}
@end

Person *p1 = [[Person alloc] init];
p1->_age = 3;
        
Person *p2 = [[Person alloc] init];
p2->_age = 4;
```

上面代码对应的内存结构，如下图所示：

![Snip20191111_15](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_15.png)



###  class 对象

如下示例：

```objective-c
NSObject *obj1 = [[NSObject alloc] init];
NSObject *obj2 = [[NSObject alloc] init];
Class objectClass1 = [obj1 class];
Class objectClass2 = [obj2 class];
Class objectClass3 = [NSObject class];
Class objectClass4 = object_getClass(obj1);
Class objectClass5 = object_getClass(obj2);

NSLog(@"%p %p %p %p %p",
              objectClass1,
              objectClass2,
              objectClass3,
              objectClass4,
              objectClass5);
//0x7fff91851140 0x7fff91851140 0x7fff91851140 0x7fff91851140 0x7fff91851140
```

- objectClass1 ~ objectClass5都是NSObject的**class对象**（类对象）。
- **它们是同一个对象。每个类在内存中有且只有1个class对象**。

下图可证明：

![Snip20191111_16](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_18.png)

从图中可以看出，objectClass1 ~ objectClass5的指针都指向同一块内存空间 `0x00007fff91851140`。这块内存空间存储的就是NSObject的类对象。



**class对象在内存中存储的信息主要包括:**

- **isa**指针
- **superclass**指针
- 类的**属性**信息（@property）、
- 类的**对象方法**信息（instance method）
- 类的**协议**信息（protocol）
- 类的**成员变量**信息（ivar）
- ......

 如下图所示：

![Snip20191111_17](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_17.png)



###  meta-class 对象

如下示例：

```objective-c
Class objectMetaClass1 = object_getClass([NSObject class]);
Class objectMetaClass2 = object_getClass([NSObject class]);

NSLog(@"%p %p", objectMetaClass1, objectMetaClass2);
//0x7fff918510f0 0x7fff918510f0
```

- objectMetaClass是NSObject的**meta-class对象**（元类对象）。
- 每个类在内存中有且只有一个meta-class对象。



**meta-class对象和class对象的内存结构是一样的，但是用途不一样，在内存中存储的信息主要包括 ：**

- **isa**指针
- **superclass**指针
- 类的**类方法**信息（class method）
- ......

 如下图所示：

![Snip20191111_19](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_19.png)

### 注意

- 以下代码获取的objectClass是class对象，并不是meta-class对象。

```objective-c
Class objecClass = [[NSObject class] class];
```

- 查看是否为meta-class.

```swift
BOOL result1 = class_isMetaClass([NSObject class]);
BOOL result2 = class_isMetaClass(object_getClass([NSObject class]));
NSLog(@"%@ %@", @(result1), @(result2));
//0 1
```



## isa和superClass

### isa指针

直接看下图：

![Snip20191111_20](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_21.png)

- instance的isa指向class。
  - 当调用**对象方法**时，通过instance的isa找到class，最后找到对象方法的实现进行调用。
- class的isa指向meta-class。
  - 调用**类方法**时，通过class的isa找到meta-class，最后找到类方法的实现进行调用。



###  class对象的superclass指针

有如下2个类：

```objective-c
@interface Person: NSObject
@interface Student: Person
```

![Snip20191111_22](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_22.png)

- 当Student的instance对象要调用**Person的对象方法**时，会先通过isa找到Student的class，然后通过superclass找到Person的class，最后找到对象方法的实现进行调用。



### meta-class对象的superclass指针  

有如下2个类：

```objective-c
@interface Person: NSObject
@interface Student: Person
```

![](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_23.png)

- 当Student的class要调用**Person的类方法**时，会先通过isa找到Student的meta-class，然后通过superclass找到Person的meta-class，最后找到类方法的实现进行调用。



### isa、superclass总结

直接看下图：
![image-20191111175520151](/Users/Brooks/blog/blogs/OC/OC语法/image-20191111175520151.png)



**isa总结：**

- instance的isa指向class。
- class的isa指向meta-class
- meta-class的isa指向基类的meta-class。

**superclass总结：**

- class的superclass指向父类的class 。
  - 如果没有父类，superclass指针为nil。
- meta-class的superclass指向父类的meta-class。
  - 基类的meta-class的superclass指向基类的class。

**方法调用轨迹：**(方法缓存部分、动态方法解析和消息转发机制后面再说~)

- **instance**调用**对象方法**的轨迹：isa找到class，方法不存在，就通过superclass找父类。
- **class**调用**类方法**的轨迹：isa找meta-class，方法不存在，就通过superclass找父类。



## Class的本质

objc源码地址： https://opensource.apple.com/tarballs/objc4/

### isa指针

从64bit开始，isa需要进行一次位运算，才能计算出真实地址。

```objective-c
（位运算使用到的 ISA_MASK 可以在objc源码的objc-private.h文件中找到，如下：）
# if __arm64__
#   define ISA_MASK        0x0000000ffffffff8ULL
# elif __x86_64__
#   define ISA_MASK        0x00007ffffffffff8ULL
# endif
```

如下图：

![](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_24.png)



### class、meta-class对象的本质结构都是struct objc_class

如下图：

![Snip20191111_26](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_26.png)



### 窥探struct  objc_class的结构

可以在objc源码的objc-runtinme-new.h文件中梳理出 **struct  objc_class** 结构图。如下所示：

![Snip20191111_27](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191111_28.png)

后面会继续深入源码分析一下isa、class_rw_t、method_list_t、method_t、class_ro_t等结构~。



## KVO

KVO的全称是Key-Value Observing，俗称“键值监听”，可以用于监听某个对象属性值的改变。

### KVO的基本使用

如下示例：

```objective-c
#import "Person.h"

@interface ViewController ()
@property (strong, nonatomic) Person *person1;
@property (strong, nonatomic) Person *person2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person1 = [[Person alloc] init];
    self.person1.age = 1;
    
    self.person2 = [[Person alloc] init];
    self.person2.age = 2;
    
    // 给person1对象添加KVO监听
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person1 addObserver:self forKeyPath:@"age" options:options context:@"123"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.person1.age = 20;
    self.person2.age = 20;
}

- (void)dealloc {
    [self.person1 removeObserver:self forKeyPath:@"age"];
}

// 当监听对象的属性值发生改变时，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@属性值改变了 - %@ - %@", object, keyPath, change, context);
}

@end
```

示例解释：

给Person1对象通过方法：

```
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
```

添加KVO监听。当通过person1的setAge方法赋值时，会触发

```
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;
```

方法。

流程如下图所示：

![Snip20191112_30](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191112_30.png)

### KVO的本质

- 上述的示例中，person2未使用KVO，当person2调用setAge时：通过person2的isa找到Person的class对象，然后找到class对象中的setAge方法完成调用；当person2调用age的getter方法时也是如此。如下图所示：

![Snip20191112_31](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191112_31.png)

- 上述的示例中，person1使用了KVO监听自己age属性的变化：因此、**系统会利用Runtime API动态生成一个Person的子类NSKVONotifying_Person，并且让person1的isa指向这个全新的子类**。该类NSKVONotifying_Person 重写了父类Person的setAge方法、具体实现伪代码如下：

```objective-c
@implementation NSKVONotifying_Person

- (void)setAge:(int)age
{
    _NSSetIntValueAndNotify();
}

// 伪代码
void _NSSetIntValueAndNotify()
{
    [self willChangeValueForKey:@"age"];
    [super setAge:age];
    [self didChangeValueForKey:@"age"];
}

- (void)didChangeValueForKey:(NSString *)key
{
    // 通知监听器，某某属性值发生了改变
    [oberser observeValueForKeyPath:key ofObject:self change:nil context:nil];
}

@end
```

上述的示例中，当person1调用setAge时：通过person1的isa找到**NSKVONotifying_Person**的class对象（使用了KVO之后，person1的isa已经指向**NSKVONotifying_Person**的类对象了、而不是之前的Person的类对象），然后找到class对象中的setAge方法（该方法会调用Foundation的_NSSetIntValueAndNotify函数，从而出发KVO回调函数）、完成调用。如下图所示：

![](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191112_34.png)

备注：**NSKVONotifying_Person** 也会重写父类的一些其他方法做些必要的事情。比如: 重写class方法，用来隐藏KVO生成子类这件事情，重写dealloc方法、做一些资源释放相关的事情。等等。

#### 总结

KVO的本质就是：利用Runtime API动态生成一个子类，并且让instance对象的isa指向这个全新的子类。当修改instance对象的属性时，会调用Foundation的**_NSSet*ValueAndNotify**函数。该函数内部做了如下几件事儿：

- 调用 willChangeValueForKey；
- 调用父类原来的setter；
- 调用 willChangeValueForKey、该方法内部会触发监听器（Observer）的监听方法（`observeValueForKeyPath: ofObject: change: context:`）。

备注：当然、也可以手动调用 willChangeValueForKey： 和 willChangeValueForKey：出发KVO。



## KVC

KVC的全称是Key-Value Coding，俗称“键值编码”，可以通过一个key来访问某个属性。

常见的API有：

```objective-c
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
- (id)valueForKey:(NSString *)key; 
```

### KVC的基本使用

如下示例：

```objective-c
@interface Cat : NSObject
@property (assign, nonatomic) int weight;
@end

@interface Person : NSObject
@property (assign, nonatomic) int age;
@property (assign, nonatomic) Cat *cat;
@end

//示例代码
Person *person = [[Person alloc] init];
// 通过KVC修改属性
[person setValue:@10 forKey:@"age"];
[person setValue:@10 forKeyPath:@"cat.weight"];

//通过KVC访问属性
NSLog(@"%@", [person valueForKey:@"age"]);
NSLog(@"%@", [person valueForKeyPath:@"cat.weight"]);
```

基本使用很简单，没什么好说的，继续研究下KVC的设值原理~

### KVC的设值原理

当使用KVC调用`setValue: forKey：`方法设值时，实际调用流程如下图：

![Snip20191112_37](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191112_37.png)

注意：图中 `accessInstanceVariablesDirectly` 是NSObject中的方法，默认返回YES。意思是：是否允许直接访问没有getter、setter方法的成员变量。

```objective-c
//NSOBject.h
@property(class, readonly) BOOL accessInstanceVariablesDirectly;//The default returns YES.
```

注意⚠️：**通过KVC设值是可以出发KVO监听方法的**。从上图可以看出：确实会调用对应的setter方法。另外：即使KVC是通过上图中直接访问成员变量赋值的、也会触发KVO的监听方法（可以自己代码验证下）；这也反证了：即使KVC是通过上图中直接访问成员变量赋值时调用了 willChangeValueForKey： 和 willChangeValueForKey：。



### KVC的取值原理

当使用KVC调用`valueForKey:`方法取值时，实际调用流程如下图：

![Snip20191112_39](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191112_39.png)



## Categoty

### Category的基本使用

没啥好说的~

### Category的底层结构

Category的底层结构是**struct category_t**， 定义在objc-runtime-new.h中。如下：

```objective-c
struct category_t {
    const char *name;
    classref_t cls;
    struct method_list_t *instanceMethods;
    struct method_list_t *classMethods;
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
};
```



### Category的加载处理过程 

1. 通过Runtime加载某个类的所有Category数据。
2. 把所有Category的方法、属性、协议数据，合并到一个大数组中；后面参与编译的Category数据，会在数组的前面。
3. 将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面。



#### 下面通过源码来分析下~

在objc-os.mm中找到_objc_init方法，如下：

```objective-c
void _objc_init(void)
{
    ...省略...

    _dyld_objc_notify_register(&map_images, load_images, unmap_image);
}
```

然后通过map_images进入

```objective-c
 void map_images(unsigned count, const char * const paths[],
            const struct mach_header * const mhdrs[])
 {
     ...省略...

     return map_images_nolock(count, paths, mhdrs);
 }
```

 然后通过map_images_nolock进入

```objective-c
 void map_images_nolock(unsigned mhCount, const char * const mhPaths[],
                   const struct mach_header * const mhdrs[])
 {
    ...省略...
 
    _read_images(hList, hCount, totalClasses, unoptimizedTotalClasses);

    ...省略...
 
 }
```

然后通过_read_images进入

```objective-c
void _read_images(header_info **hList, uint32_t hCount, int totalClasses, int unoptimizedTotalClasses)
{
     ...省略...

  // Discover categories.
   for (EACH_HEADER) {

      //拿到类的所有的category，category对应的结构是category_t。
      //数组中存储的结构类似 [category_t, category_t]
       category_t **catlist =
           _getObjc2CategoryList(hi, &count);

      //遍历上面拿到的category_t数组
       for (i = 0; i < count; i++) {
          //拿到某个category_t
           category_t *cat = catlist[i];

          //拿到这个category_t对应的class
           Class cls = remapClass(cat->cls);

          ...省略...

          //拿到类别的方法列表/协议列表/属性列表
           if (cat->instanceMethods ||  cat->protocols
               ||  cat->instanceProperties)
           {
               addUnattachedCategoryForClass(cat, cls, hi);
               if (cls->isRealized()) {

                   //重新组织类对象
                   remethodizeClass(cls);
                   classExists = YES;
               }

              ...省略...
           }

           //拿到类别的方法列表/协议列表/属性列表
           if (cat->classMethods  ||  cat->protocols
               ||  (hasClassProperties && cat->_classProperties))
           {
               addUnattachedCategoryForClass(cat, cls->ISA(), hi);
               if (cls->ISA()->isRealized()) {

                   //重新组织元类对象
                   remethodizeClass(cls->ISA());
               }

              ...省略...
           }
       }
   }

 ...省略...
}
```

然后通过remethodizeClass进入

```objective-c
static void remethodizeClass(Class cls)
{
    category_list *cats;
    
    ...省略...
    
    attachCategories(cls, cats, true /*flush caches*/);
    
    ...省略...
}
```

然后通过attachCategories进入

```objective-c
//参数cls表示: 类对象或者元类对象
//参数cats表示：分类列表，如：[category_t, category_t]
static void attachCategories(Class cls, category_list *cats, bool flush_caches)
{
    if (!cats) return;
    if (PrintReplacedMethods) printReplacements(cls, cats);

    bool isMeta = cls->isMetaClass();

    //方法数组、是2维数组，如下：
    /*
     [
        [method_t, method_t],
        [method_t, method_t]
     ]
     */
    method_list_t **mlists = (method_list_t **)
        malloc(cats->count * sizeof(*mlists));
    
    //属性数组、是2维数组，如下：
    /*
     [
        [property_t, property_t],
        [property_t, property_t]
     ]
     */
    property_list_t **proplists = (property_list_t **)
        malloc(cats->count * sizeof(*proplists));
    
    //协议数组、是2维数组，如下：
    /*
     [
        [protocol_t, protocol_t],
        [protocol_t, protocol_t]
     ]
     */
    protocol_list_t **protolists = (protocol_list_t **)
        malloc(cats->count * sizeof(*protolists));

    // Count backwards through cats to get newest categories first
    int mcount = 0;
    int propcount = 0;
    int protocount = 0;
    int i = cats->count;
    bool fromBundle = NO;
    while (i--) {//递减循环
        
        //取出某个分类category_t
        auto& entry = cats->list[i];//因为外层是递减循环，所以此处是从后往前取出元素

        //取出分类中的实例方法列表（如果是元类对象、则取出分类中的类方法列表）
        method_list_t *mlist = entry.cat->methodsForMeta(isMeta);
        if (mlist) {
            
            //将方法列表添加进上面malloc的2维数组中。
            mlists[mcount++] = mlist;//从前往后添加。
            fromBundle |= entry.hi->isBundle();
        }

        //取出分类中的属性列表（如果是元类对象、则取出分类中的属性列表）
        property_list_t *proplist =
            entry.cat->propertiesForMeta(isMeta, entry.hi);
        if (proplist) {
            proplists[propcount++] = proplist;
        }

        //取出分类中的协议列表（如果是元类对象、则取出分类中的协议列表）
        protocol_list_t *protolist = entry.cat->protocols;
        if (protolist) {
            protolists[protocount++] = protolist;
        }
    }

    //取出类对象的class_rw_t，其中存储着类对象的实例方法列表、协议列表、属性列表等信息。（或者 取出元类类对象的class_rw_t，其中存储着元类对象的类方法列表、协议列表、属性列表等信息。）
    auto rw = cls->data();

    prepareMethodLists(cls, mlists, mcount, NO, fromBundle);
    
    //将所有分类的对象方法附加到类对象的对象方法列表中。（或者 将所有分类的类方法附加到元类对象的类方法列表中）
    rw->methods.attachLists(mlists, mcount);
    free(mlists);
    if (flush_caches  &&  mcount > 0) flushCaches(cls);

    //取出属性列表
    rw->properties.attachLists(proplists, propcount);
    free(proplists);

    //取出协议列表
    rw->protocols.attachLists(protolists, protocount);
    free(protolists);
}
```

然后通过attachLists进入

```objective-c
//参数addedLists表示调用者传进来的2维数组：方法数组、协议数组 或者属性数组。如下结构：
/*
 [
    [method_t, method_t],
    [method_t, method_t]
 ]
 */
//参数addedCount表示e2维数组的长度。
void attachLists(List* const * addedLists, uint32_t addedCount) {
    if (addedCount == 0) return;

    if (hasArray()) {
        // many lists -> many lists
        //oldCount：原来方法列表的长度
        uint32_t oldCount = array()->count;
        //newCount：现在需要的长度
        uint32_t newCount = oldCount + addedCount;
        setArray((array_t *)realloc(array(), array_t::byteSize(newCount)));
        array()->count = newCount;
        
        //array()->lists：原来的方法列表
        //将原来的方法列表向后挪动到【array()->lists + addedCount】这个地址
        memmove(array()->lists + addedCount,
                array()->lists,
                oldCount * sizeof(array()->lists[0]));
        
        //addedLists：所有分类的方法列表
        //将所有分类的方法列表拷贝到【array()->lists】这个地址
        memcpy(array()->lists, addedLists,
               addedCount * sizeof(array()->lists[0]));
        
   /* 显然这顿操作之后：
    分类的方法列表合并到类的方法列表合中了、且分类的方法列表位于类的方法列表前面。所以当分类定义了与类相同的方法时，会出现分类覆盖类的方法的效果；实际上并为覆盖父类的方法、只不过在方法寻址的过程中，在方法列表中先找到的是分类的方法就返回了而已。
    */
      
    }
    
    ...省略...
};
```





### +load方法 

+load方法会在runtime加载类、分类时调用。每个类、分类的+load，在程序运行过程中只调用一次。

调用顺序如下：

1. 先调用类的+load。
   -  按照编译先后顺序调用（先编译，先调用  ）。
   - 调用子类的+load之前会先调用父类的+load。
2. 再调用分类的+load。
   - 按照编译先后顺序调用（先编译，先调用）。



#### 下面通过源码来分析下~

进入load_images

```objective-c
 void load_images(const char *path __unused, const struct mach_header *mh)
 {
    ...省略...
 
     //为待调用的load方法做一些准备工作
     prepare_load_methods((const headerType *)mh);
 
     // 调用load方法
     call_load_methods();
 }
```



**先说prepare_load_methods里面干了些什么❓**

进入prepare_load_methods

```objective-c
 void prepare_load_methods(const headerType *mhdr)
 {
     //把所有类的load方法安排一下
     schedule_class_load(remapClass(classlist[i]));

     //把所有类的所有类别的load方法添加到loadable_categories中 ⭐️提醒： 【分析完类的load方法调用过程，再来分析这个】
     add_category_to_loadable_list(cat);
 }
```

然后进入schedule_class_load

```objective-c
//将load方法递归添加到loadable_classes中，先添加父类的load方法、再添加子类的load方法
 static void schedule_class_load(Class cls)
 {
    //当类对象为nil时，退出递归、清栈
     if (!cls) return;
     
    ...省略...
 
     //递归调用父类
     schedule_class_load(cls->superclass);

     //将load方法递归添加到loadable_classes中
     add_class_to_loadable_list(cls);
     
    ...省略...
 }
```

 然后进入add_class_to_loadable_list

```objective-c
 void add_class_to_loadable_list(Class cls)
 {
     IMP method;

     loadMethodLock.assertLocked();

     method = cls->getLoadMethod();
     if (!method) return;  // Don't bother if cls has no +load method
     
     
    //loadable_classes中存储的是loadable_class，struct loadable_class的定义如下：
     /*
         struct loadable_class {
             Class cls;  // may be nil
             IMP method;
         };
    */
     if (loadable_classes_used == loadable_classes_allocated) {
         loadable_classes_allocated = loadable_classes_allocated*2 + 16;
         loadable_classes = (struct loadable_class *)
             realloc(loadable_classes,
                               loadable_classes_allocated *
                               sizeof(struct loadable_class));
     }
    
     //将类对象赋值给loadable_class的cls
     loadable_classes[loadable_classes_used].cls = cls;
     //将load方法的IMP赋值给loadable_class的method
     loadable_classes[loadable_classes_used].method = method;
     loadable_classes_used++;
 }
```



**再说call_load_methods里面干了些什么❓**

进入call_load_methods

```objective-c
 void call_load_methods(void)
 {
     ...省略...

     do {
         while (loadable_classes_used > 0) {
            //1.内层循环调用类的load方法
             call_class_loads();
         }

         //2.外层循环调用类别的load方法
         more_categories = call_category_loads();//⭐️提醒： 【分析完类的load方法调用过程，再来分析这个】

         // 3.直到没有更多的可被调用的类的load方法 或者 没有更多类别可悲调用的类别的load方法，就退出循环。
     } while (loadable_classes_used > 0  ||  more_categories);

     
    ...省略...
 }
```

 然后先进入调用类的load方法：call_class_loads

```objective-c
 static void call_class_loads(void)
 {
     ...省略...
     
    //classes表示数据结构为loadable_class的数组
    //loadable_class的数据结构如下：
    /*
        struct loadable_class {
            Class cls;  // may be nil
            IMP method;
        };
        
        cls：类对象（元类是一种特殊的类对象）
        method：类对象的load方法的IMP
    */
    struct loadable_class *classes = loadable_classes;
 
     //循环调用所有类的load方法
     for (i = 0; i < used; i++) {
         
         //拿到类对象
         Class cls = classes[i].cls;
 
         //load_method_t的定义是：typedef void(*load_method_t)(id, SEL);
         //拿到loadable_class的load方法的函数指针
         load_method_t load_method = (load_method_t)classes[i].method;

         //重点：直接使用函数地址调用load方法，并不是objc_msgSend方式。
         (*load_method)(cls, SEL_load);
     }
     
      ...省略...
 }
```

##### 第一段结论

 此时、类的load方法调用分析完毕。

 有几个需要注意的点：

1. 类对象和load方法作为loadable_class这种数据元素是通过递归加载进数组中的：先添加的父类、后添加的子类；所以数组中从前到后存储的是【父->子->孙->...】。
2. 最终调用时是从前到后直接从上述数组中取出loadable_class中的类对象cls和IMP作为函数指针的实参，直接调用的load方法。



  总结：

1. 存储：先父类、后子类。
2. 调用：顺序直接使用函数地址调用。



**还有标记了【⭐️提醒】的类别的load方法的调用流程没有分析，下面继续：**

先进入add_category_to_loadable_list

```objective-c
void add_category_to_loadable_list(Category cat)
{
    IMP method;

    //取出类别的load方法的IMP
    method = _category_getLoadMethod(cat);

    // Don't bother if cat has no +load method
    if (!method) return;

    //loadable_categories中存储的是loadable_category，struct loadable_category的定义如下：
     /*
         struct loadable_category {
             Category cat;  // may be nil
             IMP method;
         };
    */
    if (loadable_categories_used == loadable_categories_allocated) {
        loadable_categories_allocated = loadable_categories_allocated*2 + 16;
        loadable_categories = (struct loadable_category *)
            realloc(loadable_categories,
                              loadable_categories_allocated *
                              sizeof(struct loadable_category));
    }

    //将类对象赋值给loadable_category的cat
    loadable_categories[loadable_categories_used].cat = cat;
    //将load方法的IMP赋值给loadable_category的method
    loadable_categories[loadable_categories_used].method = method;
    loadable_categories_used++;
}
```

然后进入call_category_loads

```objective-c
static bool call_category_loads(void)
{
     ...省略...
    
     struct loadable_category *cats = loadable_categories;
     
    //cats表示数据结构为loadable_category的数组
    //loadable_category的数据结构如下：
    /*
        struct loadable_category {
            Category cat;  // may be nil
            IMP method;
        };
        
        cat：类对象（元类是一种特殊的类对象）
        method：类对象类别的load方法的IMP
    */
    
    //循环调用所有类别的load方法
    for (i = 0; i < used; i++) {
        
        //拿到类别的数据结构category_t
        Category cat = cats[i].cat;
        
        //load_method_t的定义是：typedef void(*load_method_t)(id, SEL);
        //拿到loadable_category的load方法的函数指针
        load_method_t load_method = (load_method_t)cats[i].method;
        Class cls;
        if (!cat) continue;

        //通过类别的数据结构category_t，取出类对象
        cls = _category_getClass(cat);
        
        // 如果类对象存在且该类别的load方法从未被调用过，则进入调用
        if (cls  &&  cls->isLoadable()) {
            
            //重点：直接使用类别load方法的函数地址调用load方法，并不是objc_msgSend方式。
            (*load_method)(cls, SEL_load);
            
            //擦除loadable_category中的category_t
            cats[i].cat = nil;
        }
    }

    ...省略...
}
```

##### 第二段结论

 此时、类别的load方法调用分析完毕。

 有几个需要注意的点：

1.  类别数据结构category_t和类别的load方法作为loadable_category这种数据元素直接加载进数组中的；元素的加载顺序取决于编译顺序：先编译先加载、后编译后加载。
2.  最终调用时是从前到后，从上述数组中取出loadable_category中的cat、然后通过cat取出类对象，和类别的load方法的IMP作为函数指针的实参，直接调用的load方法。



总结：

1.  存储：按照类别的编译顺序直接加载进数组。
2.  调用：顺序直接使用函数地址调用。





### +initialize方法

+initialize方法会在类第1次接收到消息时调用。

调用顺序如下：

1. 先调用父类的+initialize，再调用子类的+initialize。(先初始化父类，再初始化子类，每个类只会初始化1次)。



#### 下面通过源码来分析下~

上面说过、initiallize方法会在类第1次接受到消息的时候调用。**那么我们可以猜测：initialize方法的调用可能是走的runtime消息机制**。既然是走的消息机制、要调用initialzed方法就需要找到这个方法，该怎么找呢？我们知道runtime api里有个class_getInstanceMethod方法，我们看下能否通过这个方法的源码找看出什么端倪~



在源码objc-runtime-new.mm中通过class_getInstanceMethod找到下面方法

```objective-c
IMP lookUpImpOrForward(Class cls, SEL sel, id inst,
                       bool initialize, bool cache, bool resolver)
{
    ...省略...
    
    //如果需要initialize且还未initialize，则进入initialize流程
    if (initialize  &&  !cls->isInitialized()) {
        
        //进入initialize流程
        _class_initialize (_class_getNonMetaClass(cls, inst));
    }
}
```

然后进入_class_initialize

```objective-c
void _class_initialize(Class cls)
{
    ...省略...

    //取得当前类对象的父类
    supercls = cls->superclass;
    
    //如果父类需要initialize且还未initialize，则父类优先进入initialize流程
    if (supercls  &&  !supercls->isInitialized()) {
        _class_initialize(supercls);
    }
   
    ...省略...
    
    //当前类对象进入initialize流程
    callInitialize(cls);
    
    ...省略...
}
```

然后进入callInitialize

```objective-c
void callInitialize(Class cls)
{
    //显然，这里是走的objc_msgSend。刚好验证了我们的猜测：initialize的调用是走的消息机制。
    ((void(*)(Class, SEL))objc_msgSend)(cls, SEL_initialize);
    asm("");
}
```

至此、我们的猜测得到证实。



### +initialize和+load的区别

+initialize和+load的区别有以下几处：

- 调用方式上
  - load跟是根据函数地址直接调用的。
  - initialize是通过objc_msgSend调用的，走的是消息机制。
- 调用时机上
  - load是runtime加载类、分类的时候调用（只会调用1次）。
  - initialize是类第1次收到消息的时候调用，每一个类只会调用initialize 1次（父类的initialize方法可能会被调用多次）。
- 调用顺序上
  - load方法
    - 先调用类的load。
      - 先编译的类优先调用。
      - 调用子类的load之前，会先调用父类的load。
    - 再调用分类的load。
      - 先编译的分类，优先调用。
  - initialize方法
    - 先调用初始化父类。
    - 再初始化子类（可能最终调用的是父类的initialize方法）。



## 关联对象

从上一节Category的底层结构**struct category_t**可以看出： 默认情况下，因为分类底层结构的限制，不能添加成员变量到分类中。  

但可以通过关联对象来间接实现，关联对象提供了以下API：

```objective-c
//添加关联对象
void objc_setAssociatedObject(id object, const void * key,
                                id value, objc_AssociationPolicy policy)

//获得关联对象
id objc_getAssociatedObject(id object, const void * key)

//移除所有的关联对象
void objc_removeAssociatedObjects(id object)
```



### key的常见用法

- static void *MyKey = &MyKey;

```objective-c
//添加关联对象
objc_setAssociatedObject(obj, MyKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

//获得关联对象
objc_getAssociatedObject(obj, MyKey)
```

- static char MyKey;

```objective-c
//添加关联对象
objc_setAssociatedObject(obj, &MyKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

//获得关联对象
objc_getAssociatedObject(obj, &MyKey)
```

- 使用属性名作为key

```objective-c
//添加关联对象
objc_setAssociatedObject(obj, @"property", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

//获得关联对象
objc_getAssociatedObject(obj, @"property");
```

- 使用get方法的@selecor作为key

```objective-c
//添加关联对象
objc_setAssociatedObject(obj, @selector(getter), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

//获得关联对象
objc_getAssociatedObject(obj, @selector(getter))

```



### objc_AssociationPolicy

![Snip20191112_40](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191112_40.png)



### 关联对象的原理

##### 下面通过源码来分析下~

在源码objc-references.mm找到下面方法

```objective-c
void _object_set_associative_reference(id object, void *key, id value, uintptr_t policy) {
    
    //创建一个 ObjcAssociation 对象
    ObjcAssociation old_association(0, nil);
    
    //根据内存策略拿到value并赋值给newValue（acquireValue会根据policy，对value进行retain 或者 copy）
    id new_value = value ? acquireValue(value, policy) : nil;
    {
        AssociationsManager manager;
        
        //拿到AssociationsManager的AssociationsHashMap（如果不存在就创建返回、存在则取出）
        AssociationsHashMap &associations(manager.associations());
        
        //根据object生成disguised_ptr_t，disguised_ptr_t实际作用为AssociationsHashMap的key
        //意思就是：宿主对象object会被当做AssociationsHashMap的key存储东西，那么存储的是什么呢❓继续往下看
        disguised_ptr_t disguised_object = DISGUISE(object);
        
        if (new_value) {
            
            //根据上面生成的key（disguised_object），从AssociationsHashMap取出对应的东西，即ObjectAssociationMap
            AssociationsHashMap::iterator i = associations.find(disguised_object);
            if (i != associations.end()) {
                ObjectAssociationMap *refs = i->second;
                
                //根据外部传进来的关联对象的key， 从ObjectAssociationMap取出ObjcAssociation
                ObjectAssociationMap::iterator j = refs->find(key);
                if (j != refs->end()) {
                    
                    //从迭代器中取出ObjcAssociation对象赋值给最开始创建的old_association
                    old_association = j->second;
                    
                    //创建一个最新的、封装了policy和关联对象值的ObjcAssociation，并赋值给ObjectAssociationMap
                    j->second = ObjcAssociation(policy, new_value);
                } else {
                    (*refs)[key] = ObjcAssociation(policy, new_value);
                }
            } else {
                // create the new association (first time).
                ObjectAssociationMap *refs = new ObjectAssociationMap;
                associations[disguised_object] = refs;
                (*refs)[key] = ObjcAssociation(policy, new_value);
                object->setHasAssociatedObjects();
            }
        } else {
            
            // 如果传进来的关联对象的value为nil，就移除这个关联对象。
            AssociationsHashMap::iterator i = associations.find(disguised_object);
            if (i !=  associations.end()) {
                ObjectAssociationMap *refs = i->second;
                ObjectAssociationMap::iterator j = refs->find(key);
                if (j != refs->end()) {
                    old_association = j->second;
                    refs->erase(j);//擦除key对应的ObjectAssociationMap这一条记录
                }
            }
        }
    }
    
    // 释放旧的关联对象
    if (old_association.hasValue()) ReleaseValue()(old_association);
}
```



从源码中可以看出，实现关联对象技术的核心类有如下几个：

```c++
class AssociationsManager {
    static AssociationsHashMap *_map;
};

class AssociationsHashMap : public unordered_map<disguised_ptr_t, ObjectAssociationMap> {};

class ObjectAssociationMap : public std::map<void *, ObjcAssociation> {};

class ObjcAssociation {
    uintptr_t _policy;
    id _value;
};
```



这几个类的关系如下图：

![Snip20191112_41](/Users/Brooks/blog/blogs/OC/OC语法/OC语法.png)

如上图所示：

当调用方法 objc_setAssociatedObject(id **object**, const void * **key**, id **value**, objc_AssociationPolicy **policy**) 时：

- AssociationsManager管理着AssociationsHashMap；

- AssociationsHashMap使用宿主对象object作为key( DISGUISE(object) )、存储着ObjectAssociationMap；
- ObjectAssociationMap使用关联对象的key（外部传进来的key）存储着ObjcAssociation的实例对象；
- ObjcAssociation实例对象中存储着关联对象的policy和value。



##### 总结：

- 关联对象并不是存储在被关联对象本身内存中。
- 关联对象存储在全局的统一的一个AssociationsManager中。
- 设置关联对象为nil，就相当于是移除关联对象。



## Block

### Block的本质

- block本质上也是一个OC对象，它内部也有个isa指针。
- block是封装了函数调用以及函数调用环境的OC对象。

block的底层结构如下图所示：

![Snip20191114_48](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_48.png)

### Block变量捕获

为了保证block内部能够正常访问外部的变量，block有个变量捕获机制。

如下图所示：

![Snip20191114_49](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_49.png)

下面具体分析一下各种变量类型的捕获~



#### 变量的捕获

##### 先分析下局部auto类型的变量的捕获

通过如下代码示例分析

```objective-c
int age = 20;
void (^block)(void) = ^{
    NSLog(@"age is %d", age);
};
```

将上述示例代码clang rewrite之后，block的结构如下：

```objective-c
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  int age;
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int flags=0) : age(_age) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

通过clang rewrite之后的结构可以看出：block对应的结构是 `__main_block_impl_0`，而这个结构里又包含了

`__block_impl` 和 `__main_block_desc_0` 。这两个成员的结构如下：

```objective-c
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
}
```

那么，很明显能看出这3个结构之间的关系，如下：

![Snip20191114_50](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_50.png)

从上面关系图可以得出：咱们示例代码中定义的**block中最终结构包含了：isa、FuncPtr（block被包成函数之后的函数指针）、age（被捕获的auto变量）、Block_size等内容**。并且从`struct __main_block_impl_0`的构造函数

```objective-c
__main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int _age, int flags=0) : age(_age) {
  impl.isa = &_NSConcreteStackBlock;
  impl.Flags = flags;
  impl.FuncPtr = fp;
  Desc = desc;
}
```



继续看一下那几句示例代码的对应的clang write生成：

```objective-c
int age = 20;
void (*block)(void) = &__main_block_impl_0(__main_block_func_0,
                                                        &__main_block_desc_0_DATA,
                                                        //直接将age的值传递进入
                                                        age));
```

可以看出：age直接将值传递给`__main_block_impl_0`结构体的构造函数，该构造函数将实参的值赋值给了block捕获的变量age。



综上、可得出结论：**局部auto变量会被block捕获，且会将变量的值传递给block。**

也可以从另外一个角度理解这个结论，因为局部auto变量超出作用域后会被释放，而block有可能会在这个变量被释放后才调用、如果block内部访问了该变量且变量已经被释放了，肯定达不到对变量访问的预期效果了。因此、如果block内部需要访问auto局部变量，则需要捕获该变量、并且该变量的值赋给捕获后的变量的值。



##### 再分析下局部static类型变量的捕获

通过如下代码示例分析

```objective-c
static int age = 20;
void (^block)(void) = ^{
    NSLog(@"age is %d", age);
};
```

其实只是将上个代码示例的 int age变量，变成了局部static变量类型。

通过clang rewrite之后、和上个代码示例生成的结构类似，不同的地方在下面👇几处：

1. block对应的结构

```objective-c
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  
  //指针
  int *age;
    
  //结构体__main_block_impl_0的构造函数
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int *_age, int flags=0) : age(_age) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
```

可以看出：block将外部的static变量捕获为结构体内指针的成员。

2. 示例代码对应的生成

```objective-c
static int age = 20;
void (*block)(void) = &__main_block_impl_0(__main_block_func_0,
                                           &__main_block_desc_0_DATA,
                                           //很明显这里传递的是age的地址
                                           &age));
```



可以看出：是将age的地址传递给`__main_block_impl_0`结构体的构造函数，该构造函数将实参的值赋值给了block捕获的变量age。



综上、可得出结论：**局部static变量会被block捕获，且会将变量的地址传递给block。**

也可以从另外一个角度理解这个结论，因为局部static变量的生命周期是整个程序的生命周期、只是访问收到作用域的限制而已，换句话说就是—只要拿到这个变量的内存地址、就可以访问这个变量存储的内容。因此、如果block内部需要访问static局部变量，只需要在block的内部结构声明一个变量、用来接收外部传进来的地址，就可以在需要的时候对变量进行访问。



##### 再分析下全局变量的捕获

通过对上面两种类型变量的分析可以猜测出：block不会对全局变量进行捕获，而是直接在block内部直接访问全局变量即可。没必要捕获。

下面验证一下猜测，示例代码如下：

```objective-c
int age = 20;

int main(int argc, const char * argv[]) {
        
    void (^block)(void) = ^{
        NSLog(@"age is %d", age);
    };

    return 0;
}
```

clang rewrite 之后

```objective-c
int age = 20;

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  /*
   此处没有任何捕获的对应的结构定义
   */
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {

        NSLog(&__NSConstantStringImpl__var_folders_3c_82br3g013d52vzh11684t5cm0000gn_T_main_3889ba_mi_0,
              //直接访问成员变量
              age);
    }

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)};
int main(int argc, const char * argv[]) {

    void (*block)(void) = &__main_block_impl_0(__main_block_func_0,
                                               &__main_block_desc_0_DATA));

    return 0;
}
```

结果显示：并未捕获全局变量。和我们猜测一致。



### Block的类型

block有3种类型，可以通过调用class方法或者isa指针查看具体类型，最终都是继承自NSBlock类型。

- `__NSGlobalBlock__` （ _NSConcreteGlobalBlock ）
- `__NSStackBlock__` （ _NSConcreteStackBlock ）
- `__NSMallocBlock__` （ _NSConcreteMallocBlock ）

这3种类型对应的内存区域是：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_51.png" alt="Snip20191114_51" style="zoom:67%;" />

这3中类型和环境的关系如下：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_54.png" style="zoom:67%;" />

每一种类型的block调用copy后的结果如下所示

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_53.png" alt="Snip20191114_53" style="zoom:67%;" />



### Block的copy

在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上。比如以下情况：

- block作为函数返回值时。
- 将block赋值给__strong指针时。
- block作为Cocoa API中方法名含有usingBlock的方法参数时。
- block作为GCD API的方法参数时。



### 对象类型的auto变量

当block内部访问了对象类型的auto变量时：

- 如果block是在栈上，将不会对auto变量产生强引用。
- 如果block被拷贝到堆上。
  1. 会调用block内部的copy函数；
  2. copy函数内部会调用_Block_object_assign函数；
  3. _Block_object_assign函数会根据auto变量的修饰符（`__strong`、`__weak`、`__unsafe_unretained`）做出相应的操作，形成强引用（retain）或者弱引用。
- 如果block从堆上移除。
  1. 会调用block内部的dispose函数；
  2. dispose函数内部会调用_Block_object_dispose函数；
  3. _Block_object_dispose函数会自动释放引用的auto变量（release）。

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_56.png" alt="Snip20191114_56" style="zoom: 50%;" />



通过示例代码来分析下，代码如下：

```objective-c
typedef void(^Block)(void);

int main(int argc, const char * argv[]) {

    Block block;
    {
        Person *anyone = [[Person alloc] init];
           anyone.age = 20;
        
        block = ^{
               NSLog(@"anyone age is %@", anyone);
           };
    }
    
    NSLog(@"_________________");

    return 0;
}
```

从上面的代码可以得出如下结论：

- anyone是__strong修饰的auto变量，所以会被block捕获；
- block是__strong修饰的auto变量，因此该block会被拷贝到堆上。

那么block捕获了anyone对象后做了些什么呢？继续看clang rewrite后的代码：

```objective-c
typedef void(*Block)(void);

//block类型数据结构
struct __block_impl {
  void *isa;
  int Flags;
  int Reserved;
  void *FuncPtr;
};

//【block类型数据结构组合】
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
    
  //对应外部__strong修饰符
  Person *__strong anyone;
    
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, Person *__strong _anyone, int flags=0) : anyone(_anyone) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

//
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  Person *__strong anyone = __cself->anyone; // bound by copy

        NSLog((NSString *)&__NSConstantStringImpl__var_folders_3c_82br3g013d52vzh11684t5cm0000gn_T_main_8f3dd7_mi_0, anyone);
}

//比基本数据类型auto变量生成的代码多出来的函数
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    
    
/*
    _Block_object_assign函数会根据对象auto变量的修饰符（__strong、__weak、__unsafe_unretained）做出相应的操作（形成强引用（retain）或者弱引用）。
    如果外部变量是__strong修饰的对象类型的auto变量、该函数内则进行强引用；如果外部变量是__weak或者_unsafe_unretained修饰的对象类型的auto变量、该函数内部则进行弱引用。
*/
    _Block_object_assign((void*)&dst->anyone, (void*)src->anyone, 3/*BLOCK_FIELD_IS_OBJECT*/);
    
}

//比基本数据类型auto变量生成的代码多出来的函数
static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    
/*
    _Block_object_dispose函数_Block_object_dispose函数会自动释放引用的auto变量（release）
*/
    _Block_object_dispose((void*)src->anyone, 3/*BLOCK_FIELD_IS_OBJECT*/);
    
}

//【block类型数据结构组合】描述
static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
    
/*
  比基本数据类型auto变量生成的代码多出来的函数
  很明显2个函数是用来给对象类型的auto变量做内存管理的
*/
  //当block被拷贝到堆上时，会调用这个copy函数，最终会调用到_Block_object_assign函数
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
    
  //当block从堆上移除时，会调用这个dispose函数，最终会调用到_Block_object_dispose函数
  void (*dispose)(struct __main_block_impl_0*);
    
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0), __main_block_copy_0, __main_block_dispose_0};

//main函数
int main(int argc, const char * argv[]) {

    Block block;
    {
        Person *anyone = objc_msgSend(objc_msgSend(objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
        objc_msgSend(anyone, sel_registerName("setAge:"), 20);

        block = &__main_block_impl_0(__main_block_func_0,
                                     &__main_block_desc_0_DATA,
                                     anyone,
                                     570425344));
    }

    NSLog(&__NSConstantStringImpl__var_folders_3c_82br3g013d52vzh11684t5cm0000gn_T_main_97327a_mi_1);

    return 0;
}
```

 从上面代码的注释可以得出：__strong修饰的对象类型的auto变量被堆上的block强引用了。可以带过下面的打印记过看出来

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_57.png" alt="Snip20191114_57" style="zoom: 50%;" />

在断点处并为打印anyone的dealloc方法，说明anyone还有强引用在。其实就是被block强引用了。



如果是下面👇的代码，anyone会不会被强引用呢？

```objective-c
typedef void(^Block)(void);

int main(int argc, const char * argv[]) {

    Block block;
    {
        Person *anyone = [[Person alloc] init];
        anyone.age = 20;
        
        __weak typeof(anyone) weakAnyone = anyone;
        
        block = ^{
               NSLog(@"anyone age is %@", weakAnyone);
           };
    }
    NSLog(@"此时Person应该被释放了");
    NSLog(@"_________________");

    return 0;
}
```

结论是：不会被强引用。看下图：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_58.png" alt="Snip20191114_58" style="zoom:50%;" />



如果又是下面👇的代码，anyone会不会被强引用呢？

```objective-c
typedef void(^Block)(void);

int main(int argc, const char * argv[]) {

    Block block;
    {
        Person *anyone = [[Person alloc] init];
        anyone.age = 20;
        
        __unsafe_unretained typeof(anyone) unsafeAnyone = anyone;
        
        block = ^{
               NSLog(@"anyone age is %@", unsafeAnyone);
           };
    }
    NSLog(@"此时Person应该被释放了");
    NSLog(@"_________________");

    return 0;
}
```

结论是：不会被强引用。看下图：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_59.png" alt="Snip20191114_59" style="zoom:50%;" />

上个几个示例证明了我们最开始的总结：被copy到堆上的block、会根据对象类型auto变量的修饰符（`__strong`、`__weak`、`__unsafe_unretained`）做出相应的操作，形成强引用（retain）或者弱引用。



### __block修饰符

`__block`可以用于解决block内部无法修改auto变量值的问题。

`__block`不能修饰全局变量、静态变量（static）。

注意：编译器会将**__block变量**包装成一个对象。怎么证明这个呢？

根据如下代码分析一下：

```objective-c
__block int age = 10;
^{
    age += 5;
    NSLog(@"age is %d", age);
}();
```

clang rewrite

```objective-c
//编译器会将__block变量生成的对象的结构
struct __Block_byref_age_0 {
  void *__isa;
__Block_byref_age_0 *__forwarding;//指向它自己
 int __flags;
 int __size;
 int age;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_age_0 *age; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_age_0 *_age, int flags=0) : age(_age->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_age_0 *age = __cself->age; // bound by ref
        
        //通过__Block_byref_age_0变量的指针的__forwarding拿到age、并赋值。为什么不直接访问age呢?
        (age->__forwarding->age) += 5;
        NSLog(&__NSConstantStringImpl__var_folders_3c_82br3g013d52vzh11684t5cm0000gn_T_main_deca2d_mi_0,
              
              //通过__Block_byref_age_0变量的指针的__forwarding取出agec的值。为什么不直接访问age呢?
              (age->__forwarding->age));
}

int main(int argc, const char * argv[]) {

    //编译器会将__block变量包装成一个对象__Block_byref_age_0
    __Block_byref_age_0 age = {
        0,
        (__Block_byref_age_0 *)&age,
        0,
        sizeof(__Block_byref_age_0),
        10
    };
    
    &__main_block_impl_0(__main_block_func_0,
                         &__main_block_desc_0_DATA,
                         (__Block_byref_age_0 *)&age,
                         570425344)();

    return 0;
}
```

上面代码中main函数中的age指针和__Block_byref_age_0结构体的关系图如下：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_60.png" alt="Snip20191114_60" style="zoom:50%;" />

至此、上面的结论得以证明。（编译器确实会将**__block变量**包装成一个对象）



上面关系图中有个问题是：`__Block_byref_age_0` 结构体中为什么会搞个指向自己的**__forwarding** 指针呢？以及代码注释中的疑问：

```objective-c
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_age_0 *age = __cself->age; // bound by ref
        
        //通过__Block_byref_age_0变量的指针的__forwarding拿到age、并赋值。为什么不直接访问age呢?
        (age->__forwarding->age) += 5;
        NSLog(&__NSConstantStringImpl__var_folders_3c_82br3g013d52vzh11684t5cm0000gn_T_main_deca2d_mi_0,
              
              //通过__Block_byref_age_0变量的指针的__forwarding取出agec的值。为什么不直接访问age呢?
              (age->__forwarding->age));
}
```



下面来找寻下答案~



#### block的__forwarding指针

为什么需要 **__forwarding** 指针呢？

分2种情况：

1. 如果block在栈上，通过栈上的`__Block_byref_age_0` 对象的age指针访问到的还是栈上`__Block_byref_age_0` 对象的的age。

```objective-c
/*
age:栈上指向__Block_byref_age_0对象的age指针
__forwarding:指向栈上自己的指针
age：age本身
*/

age->__forwarding->age//通过栈上指针最终访问到的是栈上的age
```



2. 如果block被拷贝到了堆上，会让栈上的`__Block_byref_age_0`对象中的`__forwarding`指向堆上的`__Block_byref_age_0` 对象。

   - 此时通过栈上`__Block_byref_age_0` 对象的age指针访问到的就是堆上`__Block_byref_age_0` 对象的age。

   ```objective-c
   /*
   age:栈上指向__Block_byref_age_0对象的age指针
   __forwarding:指向堆上__Block_byref_age_0对象的指针
   age：age本身
   */
   
   age->__forwarding->age//通过栈上指针最终访问到的是堆上的age
   ```

   

   - 堆上`__Block_byref_age_0` 对象的age指针访问到的是它自己的age。

3. ```objective-c
   /*
   age:堆上指向__Block_byref_age_0对象的age指针
   __forwarding:指向堆上自己的指针
   age：age本身
   */
   
   age->__forwarding->age//通过堆上指针最终访问到的是堆上的age
   ```

   

如下图所示：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_61.png" alt="Snip20191114_61" style="zoom: 50%;" />



#### __block的内存管理

##### 当block在栈上时：

当block在栈上时，并不会对__block变量产生强引用。



##### 当block被copy到堆时：

【📌第1层copy】

1. 会调用block内部的copy函数；
2. copy函数内部会调用_Block_object_assign函数；
3. _Block_object_assign函数会对`__block变量`形成强引用（retain）。



注意1：被`__block`修饰的变量无论是基本类型、还是对象类型，都会被编译器包装成1个新对`__Block_byref_XX`对象

注意2：**被`__block`修饰的变量无论是基本类型、还是对象类型，当变量所处的block被copy到堆上时、都会被强引用**。(这里的被强引用指的是：编译器包装之后的对象`__Block_byref_XX`，而不是原始数据类型变量)。



如下图所示：

![Snip20191114_62](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_62.png)



##### 当block从堆中移除时

【📌第1层移除】

1. 会调用block内部的dispose函数；
2. dispose函数内部会调用_Block_object_dispose函数；
3. _Block_object_dispose函数会自动释放引用的__block变量（release）。

如下图所示：

![Snip20191114_63](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_63.png)

### 

#### 被__block修饰的对象类型

- 当__block变量在栈上时，不会对指向的对象产生强引用。

- 当__block变量被copy到堆时：

  基于上面👆的【📌第1层copy】进行【📌第2层copy】

  - 会调用`__block变量 `**__Block_byref_XX**  内部对象的copy函数;
  - copy函数内部会调用`**__Block_byref_XX**  内部对象的_Block_object_assign函数;
  - _Block_object_assign函数会根据所指向对象的修饰符（`__strong`、`__weak`、`__unsafe_unretained`）做出相应的操作，形成强引用（retain）或者弱引用（注意：**这里仅限于ARC时会retain，MRC时不会retain**）

- 当 __block变量从堆上移除时：

  在进行上面👆的【📌第1层移除】之前、先进行【📌第2层移除】。

  【📌第2层移除】如下：

  - 会调用`__block变量` **__Block_byref_XX**  内部对象的dispose函数；
  - dispose函数内部会调用**__Block_byref_XX**  内部对象的_Block_object_dispose函数；
  -  _Block_object_dispose函数会自动释放指向的对象（release）  。



这块有点绕，需要仔细消化下。

可以这么理解：

① 被**__block**修饰的变量、编译器会把原始变量包装成一个新的对象、并且block一定会对这个新的对象强引用；

② 这个新的对象里面如果包装的是**对象类型变量**，那么这个变量也会被新的对象强引用或者弱引用，至于是强、还是弱？取决于：**对象类型变量**的修饰符（`__strong`、`__weak`、`__unsafe_unretained`）做出相应的操作，形成强引用（retain）或者弱引用（注意：这里仅限于ARC时会retain，MRC时不会retain）。



### 对象类型的auto变量、__block变量

如下图所示：

![Snip20191114_64](/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_64.png)



### Block循环引用

block容易造成循环引用问题，如下图所示：

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_65.png" alt="Snip20191114_65" style="zoom: 33%;" />

或者

<img src="/Users/Brooks/blog/blogs/OC/OC语法/Snip20191114_66.png" alt="Snip20191114_66" style="zoom:50%;" />

那么，怎么解决循环引用问题呢？

如下几种方式来解决循环引用问题：



#### ARC下解决Block循环引用

1. 用`__weak`、`__unsafe_unretained`解决。

```objective-c
// __weak
__weak typeof(self) weakSelf = self;
self.block = ^{
    NSLog(@"%@", weakSelf);
}

// __unsafe_unretained
__unsafe_unretained id unsafeSelf = self;
self.block = ^{
    NSLog(@"%@", unsafeSelf);
}
```

2. 用__block解决（必须要调用block，才能解除循环引用）。

```objective-c
// __block
__block id blockSelf = self;
self.block = ^{
    NSLog(@"%@", blockSelf);
    blockSelf = nil;
}
```



#### MRC下解决Block循环引用

用`__unsafe_unretained`解决。

```objective-c
__unsafe_unretained id unsafeSelf = self;
self.block = ^{
    NSLog(@"%@", unsafeSelf);
}
```



用__block解决。

```objective-c
__block id blockSelf = self;
self.block = ^{
    NSLog(@"%@", blockSelf);
}
```


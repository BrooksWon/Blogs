[TOC]



# Objective-C学习笔记2-Runtime

## 什么是Runtime呢？

- OC是一门动态性比较强的编程语言，跟C、C++等语言有着很大的不同；允许很多操作推迟到程序运行时再进行。OC的动态性就是由Runtime来支撑和实现的，Runtime是一套C语言的API（Runtime API提供的接口基本都是C语言的，源码由C\C++\汇编语言编写），封装了很多动态性相关的函数 。 我们平时编写的OC代码，底层都是转换成了Runtime API进行调用。
- OC中的方法调用其实都是转成了**objc_msgSend**函数的调用，给receiver（方法调用者）发送了一条消息（selector方法名）。**objc_msgSend**底层有3大阶段  ：
  1. 消息发送（当前类、父类中查找）；
  2. 动态方法解析；
  3. 消息转发 。



## 我们能利用Runtime干什么呢？

我们可以利用OC的runtime做如下一些事情：

- 利用关联对象（AssociatedObject）给分类添加属性。
- 遍历类的所有成员变量（修改textfield的占位文字颜色、字典转模型、自动归档解档）。
- 交换方法实现（主要用在：交换系统的方法）。
- 利用消息转发机制解决方法找不到的异常问题。
- ......



## isa详解

要想学习Runtime，首先要了解它底层的一些常用数据结构，比如isa指针。

在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址；从arm64架构开始，对isa进行了优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息。如下：

```c
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



## Class的结构

![Snip20191118_67](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_67.png)



### class_rw_t

- class_rw_t里面的methods、properties、protocols是二维数组，是可读可写的，包含了类的初始内容、分类的内容。

如下图所示：

![Snip20191118_69](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_69.png)

**2020.07.17更新：**类数据结构变化了、新的数据结构节约了内存的占用。

> > > **Tips：**`class_ro_t`是只读的，存放的是编译期间就确定的字段信息；而`class_rw_t`是在 runtime 时才创建的，它会先将`class_ro_t`的内容拷贝一份，再将类的分类的属性、方法、协议等信息添加进去，之所以要这么设计是因为 Objective-C 是动态语言，你可以在运行时更改它们方法，属性等，并且分类可以在不改变类设计的前提下，将新方法添加到类中。
> >
> > 事实证明，`class_rw_t`会占用比`class_ro_t`占用更多的内存，在 iPhone 中，我们在系统测量了大约 30MB 的这些`class_rw_t`结构。应该如何优化这些内存呢？通过测量实际设备上的使用情况，我们发现大约 10％ 的类实际会存在动态的更改行为，如动态添加方法，使用 Category 方法等。因此，我们能可以把这部分动态的部分提取出来，我们称之为`class_rw_ext_t`
>
> 具体参考 https://mp.weixin.qq.com/s/iVWILcWJtlqwilo5lAufgA



### class_ro_t

- class_ro_t里面的baseMethodList、baseProtocols、ivars、baseProperties是一维数组，是只读的，包含了类的初始内容。

如下图所示：

![Snip20191118_70](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_70.png)



### method_t

method_t是对方法\函数的封装。如下图所示：

<img src="https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_71.png" alt="Snip20191118_71" style="zoom:67%;" />

- IMP代表函数的具体实现。

![Snip20191118_72](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_72.png)

- SEL代表方法\函数名，一般叫做选择器，底层结构跟char *类似。
  - 可以通过@selector()和sel_registerName()获得；
  - 可以通过sel_getName()和NSStringFromSelector()转成字符串；
  - 不同类中相同名字的方法，所对应的方法选择器是相同的。

![](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_73_01.png)



- types包含了函数返回值、参数编码的字符串。

![Snip20191118_74](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_74.png)



关于类型编码（**Type Encoding**），iOS中提供了一个叫做@encode的指令，可以将具体的类型表示成字符串编码。如下图所示：

![Snip20191118_75](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_75.png)

*参考链接：https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1*



**2020.07.17更新：**系统共享库方法地址的优化。

> 我们知道，库的地址取决于动态链接库加载之后的位置，ASLR（Address space layout randomization 地址空间布局随机化）的存在，动态链接器需要修正真实的指针地址，这也是一种代价。由于方法实现地址不会脱离当前库的地址范围的特性存在，所以实际上，方法列表并不需要使用 64 位的寻址范围空间。他们只需要能够在自己的库地址中查找引用函数地址即可，这些函数将始终在附近。所以我们可以使用 32 位相对偏移来代替绝对 64 位地址。
>
> 这么做有几个优点：
>
> 1. 无论将库加载到内存中的任何位置，偏移量始终是相同的，因此从加载后不需要进行修正指针地址。
> 2. 它们可以保存在只读存储器中，这会更加的安全。
> 3. 使用 32 位偏移量在 64 位平台上所需的内存量减少了一半。在 iPhone 中我们可以节省约 40MB 的内存大小。
>
> 优化后，指针所需的内存占用量可以减少一半。
>
> 具体参考：https://mp.weixin.qq.com/s/iVWILcWJtlqwilo5lAufgA



### cache_t

Class内部结构中有个方法缓存（cache_t），用**散列表（哈希表）**来缓存曾经调用过的方法，可以提高方法的查找速度。

如下图所示：

![Snip20191118_76](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_76.png)

缓存查找过程：将SEL作为key，根据哈希算法（ **index = hash(key & mask)** ）生成一个索引（index），然后使用该索引去_buckets数组中取对应的IMP。其中更多细节可以查看objc-cache.mm。



## objc_msgSend执行流程

OC中的方法调用，其实都是转换为objc_msgSend函数的调用。objc_msgSend执行流程分为3大阶段：

1. 消息发送。
2. 动态方法解析。
3. 消息转发。



### 源码跟读~

主要逻辑集中在：objc-msg-arm64.s 和 objc-msg-arm64.s 源码文件中。自行阅读即可。



### 阶段1-消息发送

#### 流程图

消息发送阶段的流程图如下：



![Snip20191118_77](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_77.png)



### 阶段2-动态方法解析

#### 流程图

![Snip20191118_78](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_78.png)



#### 代码示例

```objective-c
void test(id self, SEL _cmd)
{
    NSLog(@"%@-%s--%s", self, _cmd, __func__);
}


/* 实例方法动态解析：方式1
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(doSomething)) {
        Method method = class_getInstanceMethod(self, @selector(test));
        class_addMethod(self,
                        sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));

        return YES;
    }
    return [super resolveInstanceMethod: sel];
}
*/

//实例方法动态解析：方式2
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
     if (sel == @selector(doSomething)) {
           class_addMethod(self,
                           sel,
                           (IMP)test,
                           "v@:");

           return YES;
       }
       return [super resolveInstanceMethod: sel];
}

//类方法动态解析
+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(doSomething2)) {
        class_addMethod(object_getClass(self),
                        sel,
                        (IMP)test,
                        "v@:");

        return YES;
    }
    return [super resolveInstanceMethod: sel];
}
```



### 阶段3-消息转发

#### 流程图

![Snip20191118_79](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_79.png)



#### 代码示例

##### forwardingTargetForSelector 示例

```objective-c
//返回1个能响应该方法的实例对象
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(run)) {
        return [[Dog alloc] init];
    }
    
    return nil;
}

//返回1个能响应该方法的类对象
+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(run2)) {
        return [Dog class];
    }
    
    return nil;
}
```



##### methodSignatureForSelector 示例

```objective-c
//返回实例方法的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *ms = [[[Dog alloc] init] methodSignatureForSelector:@selector(run)];
    return ms;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    anInvocation.target = [[Dog alloc] init];
    [anInvocation invoke];
}


//返回类方法的方法签名
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *ms = [Dog methodSignatureForSelector:@selector(run2)];
       return ms;
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation
{
    anInvocation.target = [Dog class];
    [anInvocation invoke];
}
```



## super的本质

super调用，底层会转换为objc_msgSendSuper2函数的调用，接收2个参数：`struct objc_super2` 和 `SEL`。

objc_super2的结构定义如下：

![Snip20191118_80](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B02-Runtime/Snip20191118_80.png)

- receiver是消息接收者；
- current_class是receiver的Class对象。
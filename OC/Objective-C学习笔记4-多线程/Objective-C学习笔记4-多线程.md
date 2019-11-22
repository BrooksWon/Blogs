[TOC]



# Objective-C学习笔记4-多线程

## iOS中常见的多线程方案

![Snip20191119_92](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_92.png)

### pthread

暂略



### NSThread

暂略



### NSOperation

暂略



### GCD

#### GCD的常用函数

*GCD源码：https://github.com/apple/swift-corelibs-libdispatch*

GCD中有2个用来执行任务的函数

- 用**同步**的方式执行任务。
  - dispatch_**sync**(dispatch_queue_t queue, dispatch_block_t block);  
- 用**异步**的方式执行任务。
  - dispatch_**async**(dispatch_queue_t queue, dispatch_block_t block);

**queue**：队列

**block**：任务



**总结：dispatch_sync 和 dispatch_async 用来控制是否要开启新的线程**。

- dispatch_sync立马在当前线程同步执行任务。
- dispatch_async不要求立马在当前线程同步执行任务。



#### GCD的队列

##### 队列的类型

队列的类型，决定了任务的执行方式（并发、串行）。

GCD的队列可以分为2大类型：

- **并发**队列（Concurrent Dispatch Queue）
  - 可以让多个任务**并发（同时）**执行（自动开启多个线程同时执行任务）；
  - **并发**功能只有在**异步**（dispatch_**async**）函数下才有效。
- **串行**队列（Serial Dispatch Queue）
  - 让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）。



系统会提供了2个队列：1个是主队列（串行队列） dispatch_get_main_queue， 1个是全局并发队列 dispatch_get_global_queue。



##### 容易混肴的术语

有4个术语比较容易混淆：同步、异步、并发、串行。

- **同步**和**异步**主要影响：能不能开启新的线程。
  - **同步**：在**当前**线程中执行任务，**不具备**开启新线程的能力。
  - **异步**：在**新的**线程中执行任务，**具备**开启新线程的能力。
- **并发**和**串行**主要影响：任务的执行方式。
  - **并发**：**多个**任务并发（同时）执行。
  - **串行**：**一个**任务执行完毕后，再执行下一个任务。



##### 各种队列执行的效果

![Snip20191119_93](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_93.png)

注意：使用sync函数往**当前*串行***队列中添加任务，会卡住当前的串行队列（产生死锁），比如：

```objective-c
dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
dispatch_async(queue, ^{ 
    NSLog(@"执行任务2");
    
    dispatch_sync(queue, ^{ // 使用sync函数往当前串行队列中添加任务，会卡住当前的串行队列（产生死锁）
        NSLog(@"执行任务3");
    });

    NSLog(@"执行任务4");
});
```

 把queue换成main queue同样会死锁，main queue就是一种系统自动创建的串行队列。如下：

```objective-c
dispatch_async(dispatch_get_main_queue(), ^{ 
    NSLog(@"执行任务2");
    
    dispatch_sync(dispatch_get_main_queue(), ^{ // 使用sync函数往当前串行队列中添加任务，会卡住当前的串行队列（产生死锁）
        NSLog(@"执行任务3");
    });

    NSLog(@"执行任务4");
});
```

### 

#### 队列组的使用

思考：如何用gcd实现以下功能。  

异步并发执行任务1、任务2；等任务1、任务2都执行完毕后，再回到主线程执行任务3。

可以使用队列组 dispatch_group_t 实现，代码如下：

```objective-c
// 创建队列组
dispatch_group_t group = dispatch_group_create();
// 创建并发队列
dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);

// 添加异步任务
dispatch_group_async(group, queue, ^{
    for (int i = 0; i < 5; i++) {
        NSLog(@"任务1-%@", [NSThread currentThread]);
    }
});

dispatch_group_async(group, queue, ^{
    for (int i = 0; i < 5; i++) {
        NSLog(@"任务2-%@", [NSThread currentThread]);
    }
});
    
    // 等前面的任务执行完毕后，会自动执行这个任务
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 5; i++) {
                NSLog(@"任务3-%@", [NSThread currentThread]);
            }
        });
    });

    // 和上面回到主线程执行任务的写法等效
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"任务3-%@", [NSThread currentThread]);
//        }
//    });
    
    // 等前面的任务执行完毕后，会自动执行这个任务
//dispatch_group_notify(group, queue, ^{
//    for (int i = 0; i < 5; i++) {
//        NSLog(@"任务3-%@", [NSThread currentThread]);
//    }
//});
//
//dispatch_group_notify(group, queue, ^{
//    for (int i = 0; i < 5; i++) {
//        NSLog(@"任务4-%@", [NSThread currentThread]);
//    }
//});
```



## 多线程的安全隐患

### 隐患

1块资源可能会被多个线程共享，也就是多个线程可能会访问同一块资源。比如多个线程访问同一个对象、同一个变量、同一个文件。

当多个线程访问同一块资源时，很容易引发**数据错乱**和**数据安全**问题。



### 解决方案

那么、多线程安全隐患有哪些解决方案呢？解决方案：使用**线程同步**技术。（同步：就是协同步调，按照预定的先后顺序执行）。

常见的线程同步技术就是：**加锁**。

下面来看一下iOS中的线程同步方案~



## iOS中的线程同步方案

iOS中的线程同步方案有如下一些：

1. OSSpinLock
2. os_unfair_lock
3. pthread_mutex
4. dispatch_semaphore
5. dispatch_queue(DISPATCH_QUEUE_SERIAL)
6. NSLock
7. NSRecursiveLock
8. NSCondition
9. NSConditionLock
10. @synchronized



下面挨个看一下~

### OSSpinLock

OSSpinLock叫做”自旋锁”，等待锁的线程会处于忙等（busy-wait）状态，一直占用着CPU资源。目前已经不再安全，可能会出现优先级反转问题。

备注：**优先级反转 **就是如果等待锁的线程优先级较高，它会一直占用着CPU资源，优先级低的线程就无法释放锁。

注意：需要导入头文件#import <libkern/OSAtomic.h>

如下：

![Snip20191119_95](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_95.png)



### os_unfair_lock

os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持。

- 从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等。

注意：需要导入头文件#import <os/lock.h>

如下：

![Snip20191119_96](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_96.png)



### mutex

mutex叫做”互斥锁”，等待锁的线程会处于休眠状态。

注意：需要导入头文件#import <pthread.h>

如下：

![Snip20191119_98](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_98.png)





#### pthread_mutex **–** **递归锁**  

注意：需要使用 **PTHREAD_MUTEX_RECURSIVE **初始化。

如下：

![Snip20191119_99](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_99.png)



#### pthread_mutex **–** 条件锁

如下：

![Snip20191119_100](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_100.png)



### NSLock

**NSLock**是对**mutex普通锁**的封装。

如下：

![Snip20191119_101](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_101.png)



### NSRecursiveLock

**NSRecursiveLock**也是对**mutex递归锁**的封装，API跟NSLock基本一致。



### NSCondition

**NSCondition**是对**mutex和cond**的封装。

如下：

![Snip20191119_102](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_102.png)



### NSConditionLock

**NSConditionLock**是对**NSCondition**的进一步封装，可以设置具体的条件值。

如下：

![Snip20191119_104](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_104.png)



### dispatch_semaphore

semaphore叫做“信号量”。

- 信号量的初始值，可以用来控制线程并发访问的最大数量。
- 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步。

如下：

![Snip20191119_105](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_105.png)



### dispatch_queue

直接使用GCD的串行队列，也是可以实现线程同步的。

如下：

![Snip20191119_106](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_106.png)



### @synchronized

**@synchronized**是对**mutex递归锁**的封装。源码查看：objc4中的objc-sync.mm文件。

- @synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁、解锁操作。

如下：

![Snip20191119_107](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_107.png)



### iOS线程同步方案性能比较

性能**从高到低**排序，如下：

1. os_unfair_lock
2. OSSpinLock
3. dispatch_semaphore
4. pthread_mutex
5. dispatch_queue(DISPATCH_QUEUE_SERIAL)
6. NSLock
7. NSCondition
8. pthread_mutex(recursive)
9. NSRecursiveLock
10. NSConditionLock
11. @synchronized



### 自旋锁、互斥锁比较

①什么情况使用自旋锁比较划算？

- 预计线程等待锁的时间很短；
- 加锁的代码（临界区）经常被调用，但竞争情况很少发生；
- CPU资源不紧张
- 多核处理器。

②什么情况使用互斥锁比较划算？

- 预计线程等待锁的时间较长；
- 单核处理器；
- 临界区有IO操作；
- 临界区代码复杂或者循环量大；
- 临界区竞争非常激烈。



## atomic修饰符

atomic用于保证属性setter、getter的原子性操作，相当于在getter和setter内部加了线程同步的锁。可以参考源码objc4的objc-accessors.mm。

关键源码如下：

```c++
//setter
static inline void reallySetProperty(id self, SEL _cmd, id newValue, ptrdiff_t offset, bool atomic, bool copy, bool mutableCopy)
{
    if (!atomic) {//如果不是atomic
        //直接赋值
        oldValue = *slot;
        *slot = newValue;
    } else {//如果是atomic
        //加锁
        spinlock_t& slotlock = PropertyLocks[slot];
        slotlock.lock();
        
        //赋值
        oldValue = *slot;
        *slot = newValue;
        
        //解锁
        slotlock.unlock();
    }

    objc_release(oldValue);
}

//getter
id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic) {
   
    // 如果不是atomic，直接取值
    if (!atomic) return *slot;
        
    // 如果是atomic
    //加锁
    spinlock_t& slotlock = PropertyLocks[slot];
    slotlock.lock();
    
    //取值
    id value = objc_retain(*slot);
    
    //解锁
    slotlock.unlock();
    
    // for performance, we (safely) issue the autorelease OUTSIDE of the spinlock.
    return objc_autoreleaseReturnValue(value);
}
```

从源码中可以看出，使用了atomic的，确实是在setter和getter内部加了线程同步的锁。这个锁是**spinlock_t**，顺便看下是什么锁？源码如下：

```c++
using spinlock_t = mutex_tt<LOCKDEBUG>;

class mutex_tt : nocopy_t {
    os_unfair_lock mLock;
    
    ...省略...
}    
```

从源码中可以看出使用的正是上面👆咱们说过的**os_unfair_lock**。

**综上**：atomic用于保证属性setter、getter的原子性操作，相当于在getter和setter内部加了线程同步的锁。**它并不能保证使用属性的过程是线程安全的**。



## iOS中的读写安全方案

思考如何实现以下场景：

> 同一时间，只能有1个线程进行写的操作；
>
> 同一时间，允许有多个线程进行读的操作；
>
> 同一时间，不允许既有写的操作，又有读的操作。



上面的场景就是典型的“**多读单写**”，经常用于文件等数据的读写操作，iOS中的实现方案：

① **pthread_rwlock**：读写锁。

② **dispatch_barrier_async**：异步栅栏调用 。



### pthread_rwlock读写锁

使用pthread_rwlock读写锁时，其他等待锁的线程会进入休眠。

使用如下：

![Snip20191119_108](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_108.png)



### dispatch_barrier_async 异步栅栏调用

使用dispatch_barrier_async 异步栅栏时，同一时间允许多个线程做**读动作**，同一时间只允许1个线程做**写动作**，且**不允许**读动作线程和写动作线程同时进行。

注意：

- 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的。
- 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果。

使用如下：

![Snip20191119_109](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_109.png)

如下图所示：

![Snip20191119_110](/Users/Brooks/blog/blogs/OC/多线程/Snip20191119_110.png)
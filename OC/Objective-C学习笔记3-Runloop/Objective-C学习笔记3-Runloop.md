[TOC]



# Objective-C学习笔记3-Runloop

## 什么是Runloop？

runloop，顾名思义：运行循环。

如果没有runloop，main函数执行完毕之后就退出了。有了runloop，程序并不会马上退出，而是保持运行状态。

runloop的基本作用：

- 保持程序持续的运行；
- 处理App中的各种事件（比如触摸事件、定时器事件等）；
- 节省CPU资源，提高程序性能：该做事时做事，该休息时休息；
- ......



## Runloop对象

iOS中有2套API来访问和使用RunLoop：

① Foundation  框架提供的：**NSRunLoop** ；

② Core Foundation  框架提供的：**CFRunLoopRef**  。

NSRunLoop和CFRunLoopRef都代表着RunLoop对象；NSRunLoop是基于CFRunLoopRef的一层OC包装。

如下图所示：

<img src="https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_85.png" alt="Snip20191118_85" style="zoom:50%;" />

CFRunLoopRef是开源的，*源码地址：https://opensource.apple.com/tarballs/CF/* 。



### Runloop与线程

- 每条线程都有唯一的一个与之对应的RunLoop对象。
  - RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value。
  - 线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建。
  - nRunLoop会在线程结束时销毁。
- 主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop。



### 获取Runloop对象

#### Foundation框架

- [NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象  
- [NSRunLoop mainRunLoop]; // 获得主线程的RunLoop对象

#### Core Foundation框架

- CFRunLoopGetCurrent(); // 获得当前线程的RunLoop对象
- CFRunLoopGetMain(); // 获得主线程的RunLoop对象  



## Runloop相关的类

Core Foundation中关于RunLoop的5个类：

- CFRunLoopRef //runloop类

![Snip20191118_81](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_81.png)

- CFRunLoopModeRef //runloop的model类

![Snip20191118_82](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_82.png)

- **CFRunLoopSourceRef**

```c
typedef struct CF_BRIDGED_MUTABLE_TYPE(id) __CFRunLoopSource * CFRunLoopSourceRef;

struct __CFRunLoopSource {
    CFRuntimeBase _base;
    uint32_t _bits;
    pthread_mutex_t _lock;
    CFIndex _order;			/* immutable */
    CFMutableBagRef _runLoops;
    union {
	CFRunLoopSourceContext version0;	/* immutable, except invalidation */
        CFRunLoopSourceContext1 version1;	/* immutable, except invalidation */
    } _context;
};
```



- **CFRunLoopTimerRef**

```c
typedef struct CF_BRIDGED_MUTABLE_TYPE(NSTimer) __CFRunLoopTimer * CFRunLoopTimerRef;

struct __CFRunLoopTimer {
    CFRuntimeBase _base;
    uint16_t _bits;
    pthread_mutex_t _lock;
    CFRunLoopRef _runLoop;
    CFMutableSetRef _rlModes;
    CFAbsoluteTime _nextFireDate;
    CFTimeInterval _interval;		/* immutable */
    CFTimeInterval _tolerance;          /* mutable */
    uint64_t _fireTSR;			/* TSR units */
    CFIndex _order;			/* immutable */
    CFRunLoopTimerCallBack _callout;	/* immutable */
    CFRunLoopTimerContext _context;	/* immutable, except invalidation */
};
```



- **CFRunLoopObserverRef**

```c
typedef struct CF_BRIDGED_MUTABLE_TYPE(id) __CFRunLoopObserver * CFRunLoopObserverRef;

struct __CFRunLoopObserver {
    CFRuntimeBase _base;
    pthread_mutex_t _lock;
    CFRunLoopRef _runLoop;
    CFIndex _rlCount;
    CFOptionFlags _activities;		/* immutable */
    CFIndex _order;			/* immutable */
    CFRunLoopObserverCallBack _callout;	/* immutable */
    CFRunLoopObserverContext _context;	/* immutable, except invalidation */
};
```

其中这几个类的关系，如下图所示：

![Snip20191118_83](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_83.png)



### CFRunLoopRef

CFRunLoopModeRef代表RunLoop的运行模式。

- 1个RunLoop包含若干个Mode，每个Mode又包含若干个Source0/Source1/Timer/Observer。
- RunLoop启动时只能选择其中1个Mode，作为currentMode。
- 如果需要切换Mode，只能退出当前Loop，再重新选择1个Mode进入。
  - 这样做的目的是：不同组的Source0/Source1/Timer/Observer能分隔开来，互不影响。
- 如果Mode里没有任何Source0/Source1/Timer/Observer，RunLoop会立马退出。



### CFRunLoopModeRef

常见的2种Mode如下：

- kCFRunLoopDefaultMode（NSDefaultRunLoopMode）：App的默认Mode，通常主线程是在这个Mode下运行。
- kCFRunLoopDefaultMode（NSDefaultRunLoopMode）：App的默认Mode，通常主线程是在这个Mode下运行。



### CFRunLoopObserverRef

#### Runloop状态的种类

![Snip20191118_84](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_84.png)



#### 监听Runloop的状态

添加Observer监听RunLoop的所有状态。代码如下：

```objective-c
CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                                   kCFRunLoopAllActivities,
                                                                   YES,
                                                                   0,
                                                                   ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"kCFRunLoopEntry：即将进入runloop");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers：即将处理Timer");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources：即将处理Source");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting：即将进入休眠");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting：即将被唤醒（即将结束休眠）");
            break;
        case kCFRunLoopExit:
            NSLog(@"kCFRunLoopExit： 即将退出runloop");
            break;
    }
});

CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
CFRelease(observer);
```



## Runloop的运行逻辑

先看一张经典的网图

![Snip20191118_86](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_86.png)



### 源码解析

①UIApplicationMain会通过 CFRunLoopRun将主线程的runloop跑起来。CFRunLoopRun函数的实现如下：

```objective-c
void CFRunLoopRun(void) {	/* DOES CALLOUT */
    int32_t result;
    
    //一直转圈。直到runloop为Stopped或者Finished状态，才结束转圈
    do {
      
        //主线程通过CFRunLoopGetCurrent函数主动获取runloop对象，并在kCFRunLoopDefaultMode模式下运行
        result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
        
        CHECK_FOR_FORK();
    } while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
}
```

继续跟进 CFRunLoopRunSpecific 分析~



②CFRunLoopRunSpecific函数中的逻辑

```objective-c
SInt32 CFRunLoopRunSpecific(CFRunLoopRef rl, CFStringRef modeName, CFTimeInterval seconds, Boolean returnAfterSourceHandled) {     /* DOES CALLOUT */
    
    //通知observers：即将进入循环
	__CFRunLoopDoObservers(rl, currentMode, kCFRunLoopEntry);
    
    //runloop的核心逻辑
	result = __CFRunLoopRun(rl, currentMode, seconds, returnAfterSourceHandled, previousMode);
    
    //通知observers：即将退出循环
	__CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);

    return result;
}
```

继续跟进 __CFRunLoopRun 分析~



③__CFRunLoopRun

```objective-c
static int32_t __CFRunLoopRun(CFRunLoopRef rl, CFRunLoopModeRef rlm, CFTimeInterval seconds, Boolean stopAfterHandle, CFRunLoopModeRef previousMode) {

    do {

        //通知observers：即将处理Timers
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeTimers);
        
        //通知observers：即将处理Sources
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeSources);

        //执行加入到Loop的block(通过 CFRunLoopPerformBlock() 函数调用的block会在此处被执行)
        __CFRunLoopDoBlocks(rl, rlm);

        //处理Sources0
        Boolean sourceHandledThisLoop = __CFRunLoopDoSources0(rl, rlm, stopAfterHandle);
        
        //根据Sources0的结果，可能会再次处理Blocks
        if (sourceHandledThisLoop) {
            //执行加入到Loop的block(通过 CFRunLoopPerformBlock() 函数调用的block会在此处被执行)
            __CFRunLoopDoBlocks(rl, rlm);
        }

        //判断是否有Source1，如果有、就跳转到 handle_msg 标记处
        if (__CFRunLoopServiceMachPort(dispatchPort, &msg, sizeof(msg_buffer), &livePort, 0)) {
            goto handle_msg;
        }
    
        //通知observers：即将休眠
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopBeforeWaiting);
        
        //进入休眠，等待其他消息唤醒
        __CFRunLoopSetSleeping(rl);
        __CFPortSetInsert(dispatchPort, waitSet);
        do {
            __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort, poll ? 0 : TIMEOUT_INFINITY);
            
            if (modeQueuePort != MACH_PORT_NULL && livePort == modeQueuePort) {
                // Drain the internal queue. If one of the callout blocks sets the timerFired flag, break out and service the timer.
                while (_dispatch_runloop_root_queue_perform_4CF(rlm->_queue));
                if (rlm->_timerFired) {
                    // Leave livePort as the queue port, and service timers below
                    rlm->_timerFired = false;
                    break;
                } else {
                    if (msg && msg != (mach_msg_header_t *)msg_buffer) free(msg);
                }
            } else {
                // Go ahead and leave the inner loop.
                break;
            }
        } while (1);
        
        
        //醒来
        __CFRunLoopSetIgnoreWakeUps(rl);
        __CFRunLoopUnsetSleeping(rl);
	
        //通知observers：已经唤醒
        __CFRunLoopDoObservers(rl, rlm, kCFRunLoopAfterWaiting);

	      //收到消息，处理消息
        handle_msg:;//看看是谁唤醒的runloop，进行相应的处理

        if (被Timer唤醒的) {
            //处理Timers
            __CFRunLoopDoTimers(rl, rlm, mach_absolute_time());
        }else if (被GCD唤醒的) {
            //执行GCD相关的任务
            __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
        } else {被Source1唤醒的
            //处理sSource1
            __CFRunLoopDoSource1(rl, rlm, rls, msg, msg->msgh_size, &reply);
        }
        
        //执行加入到Loop的block(通过 CFRunLoopPerformBlock() 函数调用的block会在此处被执行)
        __CFRunLoopDoBlocks(rl, rlm);
 
        if (sourceHandledThisLoop && stopAfterHandle) {
            // 进入loop时参数说处理完事件就返回。
            retVal = kCFRunLoopRunHandledSource;
        } else if (timeout) {
            // 超出传入参数标记的超时时间了
            retVal = kCFRunLoopRunTimedOut;
        } else if (__CFRunLoopIsStopped(runloop)) {
            // 被外部调用者强制停止了
            retVal = kCFRunLoopRunStopped;
        } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
            // source/timer/observer一个都没有了
            retVal = kCFRunLoopRunFinished;
        }

        // 如果没超时，mode里没空，loop也没被停止，那继续loop。
    } while (retVal == 0);

    
    return retVal;
}
```

备注：源码中的 **__CFRunLoopDoXXXX** 函数与其最终执行函数的对应关系如下：

- `__CFRunLoopDoObservers` 对应 `__CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__`
- `__CFRunLoopDoBlocks` 对应 `__CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__`
- `__CFRunLoopDoSources0` 对应 `__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__`
- `GCD Async To Main Queue` 对应 `__CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__`
- `__CFRunLoopDoSource1` 对应 `__CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__`

用这些长函数替换之后，流程如下：

```objective-c
{
    /// 1. 通知Observers，即将进入RunLoop
    /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
    do {
 
        /// 2. 通知 Observers: 即将触发 Timer 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
        /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
 
        /// 4. 触发 Source0 (非基于port的) 回调。
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
 
        /// 6. 通知Observers，即将进入休眠
        /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);
 
        /// 7. sleep to wait msg.
        mach_msg() -> mach_msg_trap();
        
 
        /// 8. 通知Observers，线程被唤醒
        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);
 
        /// 9. 如果是被Timer唤醒的，回调Timer
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);
 
        /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
        __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);
 
        /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);
 
 
    } while (...);
 
    /// 10. 通知Observers，即将退出RunLoop
    /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
}
```



### Runloop运行逻辑图

上面👆根据源码分析了一边runloop的运行逻辑，接下来通过下面👇详细的runloop运行逻辑图再来梳理下：

![Snip20191118_87](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_87.png)

上图流程的文字说明如下：

![Snip20191118_88](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191118_88.png)



### Runloop休眠的实现原理

上面源码中可以看出，当runloop无事可做时，会线程进入休眠并阻塞在那里。那么休眠怎么实现的呢？

源码中 `__CFRunLoopServiceMachPort`函数调用了内核的`mach_msg`函数实现了：

①当runloop即将进入休眠时，通过调用内核函数`mach_msg`，让线程进入休眠并让线程阻塞在那里。

②内核函数`mach_msg`会判断是否有消息需要处理，若无、则让线程休眠；若有、则唤醒线程并使线程解除阻塞状态继续处理消息。



休眠原理如下图所示：

![Snip20191119_90](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B03-Runloop/Snip20191119_90.png)

## 应用举例

🌰例子1：解决NSTimer失效问题。

代码如下：

```objective-c
static int count = 0;
NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    NSLog(@"%d", ++count);
}];

// NSDefaultRunLoopMode、UITrackingRunLoopMode才是真正存在的模式
// NSRunLoopCommonModes并不是一个真的模式，它只是一个标记
// timer能在_commonModes数组中存放的模式下工作
[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
```



🌰例子2：线程保活，在该线程高频处理一些任务。

代码如下：

```objective-c
//PermanentThread.h文件
typedef void (^PermanentThreadTask)(void);

@interface PermanentThread : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(PermanentThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end


//------------------分割线-----------------

//PermanentThread.m 文件
#import "PermanentThread.h"

/** InnerThread **/
@interface InnerThread : NSThread
@end
@implementation InnerThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

/** PermanentThread **/
@interface PermanentThread()
@property (strong, nonatomic) InnerThread *innerThread;
@end

@implementation PermanentThread
#pragma mark - public methods
- (instancetype)init
{
    if (self = [super init]) {
        self.innerThread = [[InnerThread alloc] initWithBlock:^{
            NSLog(@"begin----");
            
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动. 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
            NSLog(@"end----");
        }];
        
        [self.innerThread start];
    }
    return self;
}

//- (void)run
//{
//    if (!self.innerThread) return;
//
//    [self.innerThread start];
//}

- (void)executeTask:(PermanentThreadTask)task
{
    if (!self.innerThread || !task) return;
    
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

#pragma mark - private methods
- (void)__stop
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(PermanentThreadTask)task
{
    task();
}

@end

//------------------分割线-----------------

//调用示例代码
//self.thread是PermanentThread
[self.thread executeTask:^{
    NSLog(@"执行任务 - %@", [NSThread currentThread]);
}];
```


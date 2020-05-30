[TOC]



# Objective-C学习笔记4-多线程

## iOS中常见的多线程方案

![Snip20191119_92](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_92.png)

### pthread

暂略



### NSThread

这套方案是经过苹果封装后的，并且完全面向对象的。所以你可以直接操控线程对象，非常直观和方便。但是，它的生命周期还是需要我们手动管理，所以这套方案也是偶尔用用，比如 `[NSThread currentThread]`，它可以获取当前线程类，你就可以知道当前线程的各种属性，用于调试十分方便。下面来看看它的一些用法:

#### 创建并启动

###### 先创建线程类，再启动

```objc
  // 创建
  NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];

  // 启动
  [thread start];
```

###### 创建并自动启动

```objc
  [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:nil];
```

###### 使用 NSObject 的方法创建并自动启动

```objc
  [self performSelectorInBackground:@selector(run:) withObject:nil];
```

##### 其他方法

除了创建启动外，NSThread 还以很多方法，下面我列举一些常见的方法，当然我列举的并不完整，更多方法大家可以去类的定义里去看。

```objective-c
//取消线程
- (void)cancel;

//启动线程
- (void)start;

//判断某个线程的状态的属性
@property (readonly, getter=isExecuting) BOOL executing;
@property (readonly, getter=isFinished) BOOL finished;
@property (readonly, getter=isCancelled) BOOL cancelled;

//设置和获取线程名字
-(void)setName:(NSString *)n;
-(NSString *)name;

//获取当前线程信息
+ (NSThread *)currentThread;

//获取主线程信息
+ (NSThread *)mainThread;

//使当前线程暂停一段时间，或者暂停到某个时刻
+ (void)sleepForTimeInterval:(NSTimeInterval)time;
+ (void)sleepUntilDate:(NSDate *)date;
```





### NSOperation

和NSThread、GCD一样，NSOperation也是Apple提供的一项多线程并发编程方案。和GCD不同的是，NSOperation是对GCD在OC层面的封装，NSOperation完全面向对象。 默认情况下，NSOperation并不具备封装操作的能力，NSOperation是一个基类，要想封装操作，必须使用它的子类。使用NSOperation子类的方式有3种：

1. NSInvocationOperation（系统提供）
2. NSBlockOperation （系统提供） 
3. 自定义子类继承NSOperation，实现内部相应的方法 （自定义）

#### (一) NSInvocationOperation

NSInvocationOperation初始化的方法有两个，分别如下：

```objective-c
- (nullable instancetype)initWithTarget:(id)target selector:(SEL)sel object:(nullable id)arg;
- (instancetype)initWithInvocation:(NSInvocation *)inv NS_DESIGNATED_INITIALIZER;
```

##### (1.1) initWithTarget:(id)target selector:(SEL)sel object:(nullable id)arg

```objective-c
NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(demo) object:nil];
[op start];
```

`解析：`上面通过传入一个方法签名（selector）和方法调用者（target）初始化了一个NSInvocationOperation对象。 调用start实例方法可以执行该操作封装的任务。

##### (1.2) initWithInvocation:(NSInvocation *)inv

```objective-c
NSMethodSignature *sign = [[self class] instanceMethodSignatureForSelector:@selector(demo)];
NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sign];
inv.target = self;
inv.selector = @selector(demo);
NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithInvocation:inv];
[op2 start];
```

`解析：`上面通过传入一个NSInvocation对象初始化了一个NSInvocationOperation对象。NSInvocation对象通过传入一个方法签名进行初始化，并且给NSInvocation对象设置了target和selector。

>  **注意：**NSInvocationOperation实例对象直接调用start方法是在当前线程执行操作封装的任务。而不是在子线程中执行。也就是说，NSInvocationOperation实例对象直接调用start方法不会开启新线程异步执行，而是同步执行。只有将NSInvocationOperation实例对象添加到一个NSOperationQueue中，才会异步执行操作。 



#### (二) NSBlockOperation

NSBlockOperation是NSOperation的子类。NSBlockOperation中给我们提供了两个方法：

```objective-c
+ (instancetype)blockOperationWithBlock:(void (^)(void))block;
- (void)addExecutionBlock:(void (^)(void))block;
```

- 第一个是类方法（静态方法），可以通过类方法直接初始化一个blockOperation对象。
- 第二个是实例方法（对象方法/动态方法），可以给一个已经存在的NSBlockOperation对象添加额外的任务。

和NSInvocationOperation相比，NSBlockOperation对象不用添加到操作队列也能开启新线程，但是开启新线程是有条件的。前提是一个blockOperation中需要封装多个任务。如下示例，blockOperation中只有一个任务，默认会在当前线程执行。

```objective-c
// 同步执行
NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"%@", [NSThread currentThread]);    
}];
[blkop start];

// 输出结果：
NSOperation[1839:133702] <NSThread: 0x608000076b00>{number = 1, name = main}
```

`解析：`NSBlockOperation类通过调用类方法`blockOperationWithBlock:`直接初始化一个NSBlockOperation对象。其中类方法需要一个block作为参数，该block中封装的就是这个NSBlockOperation对象要执行的任务。然后直接调用start实例方法即可触发操作的执行。无需将NSBlockOperation对象加入到操作队列中。

>  **注意：**NSBlockOperation对象如果只封装了一个任务, 那么默认会在当前线程中同步执行。



```objective-c
// 异步执行
NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"任务1- %@", [NSThread currentThread]);
}];

// 添加额外的任务
[blkop addExecutionBlock:^{
    NSLog(@"任务2- %@", [NSThread currentThread]);
}];
[blkop addExecutionBlock:^{
    NSLog(@"任务3- %@", [NSThread currentThread]);
}];
[blkop start];
// 输出结果：
2017-02-08 22:41:54.871 NSOperation[1884:142063] 任务1- <NSThread: 0x60800007cec0>{number = 1, name = main}
2017-02-08 22:41:54.871 NSOperation[1884:142100] 任务3- <NSThread: 0x6080002699c0>{number = 4, name = (null)}
2017-02-08 22:41:54.871 NSOperation[1884:142101] 任务2- <NSThread: 0x608000269800>{number = 3, name = (null)}
```

`解析：`初始化一个NSBlockOperation对象，然后调用`addExecutionBlock:`对象方法给这个NSBlockOperation对象添加额外的任务。

>  **注意：**`一般情况下`，如果一个NSBlockOperation对象封装了多个任务。那么除第一个任务外，其他的任务会在新线程（子线程）中执行。即，NSBlockOperation是否开启新线程取决于任务的个数，任务的个数多，会自动开启新线程。但是第一个被执行的任务是同步执行，除第一个任务外，其他任务是异步执行的。



#### (三) 自定义NSOperation

> https://juejin.im/post/5d26a7a2e51d45777b1a3e38

如果NSInvocationOperation和NSBlockOperation不能满足需求。

`你可以通过重写 main 或者 start 方法 来定义自己的 operations 。前一种方法非常简单，开发者不需要管理一些状态属性（例如 isExecuting 和 isFinished），当 main 方法返回的时候，这个 operation 就结束了。这种方式使用起来非常简单，但是灵活性相对重写 start 来说要少一些。`

引自[并发编程：API 及挑战](https://link.jianshu.com/?t=https%3A%2F%2Fwww.objccn.io%2Fissue-2-1%2F)。如果只是简单地自定义NSOperation，只需要重载-(void)main这个方法，在这个方法里面添加需要执行的操作。

```javascript
// EOCOperation.h
#import <Foundation/Foundation.h>

@interface EOCOperation : NSOperation

@end

// EOCOperation.m
#import "EOCOperation.h"

@implementation EOCOperation
- (void)main {
    NSLog(@"%@",[NSThread currentThread]);
}
@end
```

```javascript
// 调用自定义operation
EOCOperation *customOperation = [[EOCOperation alloc] init];
[customOperation start];

输出结果：
NSOperation[2084:169435] <NSThread: 0x600000260f80>{number = 1, name = main}
```

```javascript
EOCOperation *customOperation = [[EOCOperation alloc] init];
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
[queue addOperation:customOperation];
// 输出结果：
NSOperation[739:22292] <NSThread: 0x600000070280>{number = 3, name = (null)}
```

>  自定义operation和NSInvocationOperation一样，如果直接调用start方法，不把operation添加到操作队列中，任务直接在当前线程同步执行。 如果把自定义operation添加到操作队列，那么任务会在新线程中异步执行。 
>
>  `警告：`不要即把操作添加到操作队列中，又调用操作的start方法，这样是不允许的！否则运行时直接报错。 

```javascript
NSOperation[756:24507] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSOperationInternal _start:]: something other than the operation queue it is in is trying to start the receiver'
```

为了能够使用操作队列提供的取消功能，我们需要在main方法中经常性的判断操作有没有被取消，如果操作已经被取消，我们需要立即使main方法返回，不再执行后续代码。在以下情况可能需要判断操作是否已经取消：

- main方法的开头。因为取消可能发生在任何时候，甚至在operation执行之前。
- 执行了一段比较耗时的操作后。因为执行耗时操作期间有可能取消了该操作。
- 其他任何有可能的地方。 举例来讲：自定义operation的main函数中需要封装网络请求的URL，然后拼接参数。然后发送一个异步请求，请求网络数据。我们需要在以下地方进行判断是否已经取消操作。

```javascript
- (void)main {
    if (self.isCancelled) {
        return;
    }
    
    // 封装URL
    ......
    if (self.isCancelled) {
        return;
    }
    
    // 拼接参数
    ......
    if (self.isCancelled) {
        return;
    }
    
    // 异步请求
    ......
    if (self.isCancelled) {
        return;
    }
}
```

如果你希望拥有更多的控制权，以及在一个操作中可以执行异步任务，那么就重写 start 方法：

```javascript
    - (void)start
    {
        self.isExecuting = YES;
        self.isFinished = NO;
        // 开始处理，在结束时应该调用 finished ...
    }

    - (void)finished
    {
        self.isExecuting = NO;
        self.isFinished = YES;
    }
```

>  `注意：`这种情况下，你必须手动管理操作的状态。 为了让操作队列能够捕获到操作的改变，需要将状态的属性以配合 KVO 的方式进行实现。如果你不使用它们默认的 setter 来进行设置的话，你就需要在合适的时候发送合适的 KVO 消息。 



#### (四) NSOperation其他方法

##### (4.1) cancel方法

NSOperation除了有start方法，还有cancel方法。我们可以调用cancel方法取消未执行的操作。但是已执行或者正在执行的操作不可取消。 即便操作已经被添加到操作队列中也可以取消，只要操作没有开始被执行。 因为官方文档上是这么说的：This method does not force your operation code to stop. Instead, it updates the object’s internal flags to reflect the change in state. If the operation has already finished executing, this method has no effect. Canceling an operation that is currently in an operation queue, but not yet executing, makes it possible to remove the operation from the queue sooner than usual.

```javascript
    // 1.封装op1
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        // 封装op2
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"执行op2%@",[NSThread currentThread]);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:op2];
        // 取消op2
        [op2 cancel];
        
        NSLog(@"执行op1- %@", [NSThread currentThread]);
    }];
    [op1 start];

// 输出结果：
2017-02-09 19:46:24.745 NSOperation[1163:67542] 执行op1- <NSThread: 0x6000000770c0>{number = 1, name = main}
```

`解析：`上面代码只会执行op1，op2永远也不会执行，因为在op2执行之前就已经通过调用了cancel方法，取消了op2的执行。所以输出结果只有执行op1。且op1是在主线程执行的。 如果我们不取消op2，那么op2也会被执行。只需要注释掉取消op2的代码。

>  `注意：`我们可以通过调用cancel方法取消某个尚未执行的操作（无论这个操作是否被加入了操作队列）。但是我们不能取消正在执行或者已经执行完的操作。 

##### (4.2) completionBlock属性

NSOperation提供了一个block类型的completionBlock属性。如果想在操作执行完毕之后，还希望做一些其他的事情，可以通过completionBlock实现。

无论操作是直接调用start执行还是加入到操作队列中执行，也无论操作是同步执行还是异步执行。completionBlock永远是等待操作所有任务执行完毕最后被调用。

###### 同步执行

```javascript
    NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行%@",[NSThread currentThread]);
    }];
    blkop.completionBlock = ^{
        NSLog(@"完成");
    };
    [blkop start];

// 输出结果：
2017-02-09 20:03:30.387 NSOperation[1395:94883] 执行<NSThread: 0x600000065d40>{number = 1, name = main}
2017-02-09 20:03:30.388 NSOperation[1395:94930] 完成
```

###### 异步执行

```javascript
NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行%@",[NSThread currentThread]);
    }];
    blkop.completionBlock = ^{
        NSLog(@"完成");
    };
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:blkop];

// 输出结果:
2017-02-09 20:00:05.145 NSOperation[1364:91326] 执行<NSThread: 0x60800007d500>{number = 3, name = (null)}
2017-02-09 20:00:05.146 NSOperation[1364:91329] 完成
```

给操作设置completionBlock，必须要在操作被执行前添加，也就是在操作start之前添加，以下的做法是错误的:

```javascript
NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行%@",[NSThread currentThread]);
    }];
[blkop start];
blkop.completionBlock = ^{
        NSLog(@"完成");
    };
```

如果一个操作是被加到操作队列中，然后才设置completionBlock，这样是可以的，如下：

```javascript
    NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"执行%@",[NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:blkop];
    blkop.completionBlock = ^{
        NSLog(@"完成");
    };
```

>  `总结：`如果操作是通过调用start方法触发的，那么completionBlock必须要在start之前设置。如果操作是通过加入操作队列被触发的，那么completionBlock可以在操作添加到操作队列之后设置，只要保证此时操作没有被执行即可。 

##### (4.3) 给NSOperation添加Dependency

默认操作的执行是无序的，NSOperation之间可以通过设置依赖来保证操作执行的顺序。 比如一定要让操作A执行完后，才能执行操作B，可以这么写： `[operationB addDependency:operationA];` 操作B依赖于操作A，所以一定要等操作A执行完毕才能执行操作B。 操作的执行顺序不是取决于谁先被添加到队列中，而是取决于操作依赖。也就是说，添加顺序不会决定执行顺序，只有依赖才会决定执行顺序（maxConcurrentOperationCount = 1除外，因为maxConcurrentOperationCount = 1时，操作队列为串行队列，如果没有给操作添加依赖，此时操作的执行顺序取决于操作添加到队列中的先后顺序。即便如此，maxConcurrentOperationCount = 1时，队列中的操作也并不一定在同一个线程中执行）。

即操作依赖可以控制操作的执行顺序，使多个并行的操作可以按照串行的顺序一个一个地执行。如果没有给操作添加依赖，设置操作队列的maxConcurrentOperationCount = 1也可以控制操作的执行顺序，其执行顺序取决于操作添加到队列中的顺序。 如果操作设置了依赖，也给队列设置了maxConcurrentOperationCount = 1。那么操作被执行的顺序取决于依赖。即，依赖的优先级较高。

```javascript
    NSBlockOperation *blkop1 = [NSBlockOperation blockOperationWithBlock:^{

        NSLog(@"执行1 %@",[NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;

    NSBlockOperation *blkop2 = [NSBlockOperation blockOperationWithBlock:^{

        NSLog(@"执行2 %@",[NSThread currentThread]);
    }];
    
    [blkop1 addDependency:blkop2];
    [queue addOperation:blkop1];
    [queue addOperation:blkop2];
    
// 输出结果：
2017-02-09 20:57:13.369 NSOperation[2371:194728] 执行2 <NSThread: 0x600000267700>{number = 3, name = (null)}
2017-02-09 20:57:13.375 NSOperation[2371:194725] 执行1 <NSThread: 0x6000002615c0>{number = 4, name = (null)}
```

`解析：`虽然设置了队列的maxConcurrentOperationCount = 1，使操作队列变成一个串行队列。但是也设置了操作之间的依赖，所以最终操作的执行顺序取决于依赖。所以上面的执行结果永远是先执行操作2，再执行操作1。

>  `注意：`一定要在操作添加到队列之前设置操作之间的依赖，否则操作已经添加到队列中在设置依赖，依赖不会生效。 

问题：默认情况下，操作队列中的操作的执行顺序真的是无序的吗？ 个人认为，默认情况下，操作队列中的操作执行顺序就是其被取出的顺序，也是其被添加到队列中的顺序，操作的执行顺序是有序的，但是操作执行完成的顺序是无需的。也就是说，因为不同的操作执行完成所需要的时间不同，最先从对垒中取出执行的操作不一定先执行完成，后执行的操作不一定后执行完成。所以，给人的感觉就是操作的执行是无序的。

其实，操作的依赖特性可以用GCD的信号量机制来实现。

###### 不同队列的操作之间也可以设置依赖

依赖关系不局限于相同queue中的NSOperation对象,NSOperation对象会管理自己的依赖, 因此不同的操作队列之间的操作也可以设置依赖。如下：

```javascript
    NSBlockOperation *blkop1 = [NSBlockOperation blockOperationWithBlock:^{

        NSLog(@"执行1 %@",[NSThread currentThread]);
    }];
    
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;

    NSBlockOperation *blkop2 = [NSBlockOperation blockOperationWithBlock:^{

        NSLog(@"执行2 %@",[NSThread currentThread]);
    }];
    
    [blkop2 addDependency:blkop1];
    [queue1 addOperation:blkop1];
    [queue1 addOperation:blkop2];
    
    NSBlockOperation *blkop3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行3 %@",[NSThread currentThread]);
    }];
    [blkop3 addDependency:blkop2];
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    
    [queue2 addOperation:blkop3];
    
// 输出结果：
2017-02-09 21:20:52.270 NSOperation[2545:217909] 执行1 <NSThread: 0x60000007a480>{number = 3, name = (null)}
2017-02-09 21:20:52.272 NSOperation[2545:217909] 执行2 <NSThread: 0x60000007a480>{number = 3, name = (null)}
2017-02-09 21:20:52.273 NSOperation[2545:217907] 执行3 <NSThread: 0x60000007a080>{number = 4, name = (null)}
```

`解析：`上面代码中，不仅队列queue1中的两个操作blkop1和blkop2间设置了依赖。两个不同的操作队列queue1和queue2之间的操作blkop2和blkop3也设置了依赖。最中依赖顺序是：blkop2 依赖 blkop1，blkop3依赖blkop2。所以操作的执行顺序永远是1、2、3。

NSOperation提供了如下三个接口管理自己的依赖：

```javascript
- (void)addDependency:(NSOperation *)op;
- (void)removeDependency:(NSOperation *)op;

@property (readonly, copy) NSArray<NSOperation *> *dependencies;
```

`警告：`操作间不能循环依赖，比如A依赖B，B依赖A，这是错误的。

##### (4.4) queuePriority

NSOperation类提供了一个`queuePriority`属性，`代表操作在队列中执行的优先级`。

```javascript
@property NSOperationQueuePriority queuePriority;
```

queuePriority是一个NSOperationQueuePriority类型的枚举值，apple为NSOperationQueuePriority类型定义了一下几个值：

```javascript
typedef NS_ENUM(NSInteger, NSOperationQueuePriority) {
    NSOperationQueuePriorityVeryLow = -8L,
    NSOperationQueuePriorityLow = -4L,
    NSOperationQueuePriorityNormal = 0,
    NSOperationQueuePriorityHigh = 4,
    NSOperationQueuePriorityVeryHigh = 8
};
```

`queuePriority`默认值是`NSOperationQueuePriorityNormal`。根据实际需要我们可以通过调用queuePriority的setter方法修改某个操作的优先级。

```javascript
    NSBlockOperation *blkop1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行blkop1");
    }];
    
    NSBlockOperation *blkop2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行blkop2");
    }];
    
    // 设置操作优先级
    blkop1.queuePriority = NSOperationQueuePriorityLow;
    blkop2.queuePriority = NSOperationQueuePriorityVeryHigh;
 
    NSLog(@"blkop1 == %@",blkop1);
    NSLog(@"blkop2 == %@",blkop2);

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 操作添加到队列
    [queue addOperation:blkop1];
    [queue addOperation:blkop2];
    
    NSLog(@"%@",[queue operations]);
    for (NSOperation *op in [queue operations]) {
        NSLog(@"op == %@",op);
    }

// 输出结果：
2017-02-12 19:36:01.149 NSOperation[1712:177976] blkop1 == <NSBlockOperation: 0x608000044440>
2017-02-12 19:36:01.150 NSOperation[1712:177976] blkop2 == <NSBlockOperation: 0x6080000444d0>
2017-02-12 19:36:01.150 NSOperation[1712:177976] (
    "<NSBlockOperation: 0x608000044440>",
    "<NSBlockOperation: 0x6080000444d0>"
)
2017-02-12 19:36:01.150 NSOperation[1712:177976] op == <NSBlockOperation: 0x608000044440>
2017-02-12 19:36:01.150 NSOperation[1712:177976] op == <NSBlockOperation: 0x6080000444d0>
2017-02-12 19:36:01.150 NSOperation[1712:178020] 执行blkop1
2017-02-12 19:36:01.151 NSOperation[1712:178021] 执行blkop2
```

`解析：` 

（1.）上面创建了两个blockOperation并且分别设置了优先级。显然blkop1的优先级低于blkop2的优先级。然后调用了队列的addOperation:方法使操作入队。最后输出结果证明，操作在对列中的顺去取决于addOperation:方法而不是优先级。 

（2.）虽然blkop2优先级高于blkop1，但是bloop1却先于blkop2执行完成。所以，优先级高的操作不一定先执行完成。

>  `注意：` 
>
> （1.）优先级只能应用于相同queue中的operations。 
>
> （2.）操作的优先级高低不等于操作在队列中排列的顺序。换句话说，优先级高的操作不代表一定排在队列的前面。后入队的操作有可能因为优先级高而先被执行。PS:操作在队列中的顺序取决于队列的`addOperation:`方法。（证明代码如下） 
>
> （3.）优先级高只代表先被执行。不代表操作先被执行完成。执行完成的早晚还取决于操作耗时长短。 （4.）优先级不能替代依赖，优先级也绝不等于依赖。优先级只是对已经准备好的操作确定其执行顺序。 （5.）操作的执行优先满足依赖关系，然后再满足优先级。即先根据依赖执行操作，然后再从所有准备好的操作中取出优先级最高的那一个执行。 

##### (4.5) qualityOfService

```javascript
@property NSQualityOfService qualityOfService NS_AVAILABLE(10_10, 8_0);
```

`qualityOfService`是NSOperation类提供的一个属性。qualityOfService即`服务质量`。

#### (五) NSOperationQueue

##### (5.1) 取消

一旦操作添加到operation queue中,queue就拥有了这个Operation对象并且不能被删除，唯一能做的事情是取消。你可以调用Operation对象的cancel方法取消单个操作,也可以调用operation queue的cancelAllOperations方法取消当前queue中的所有操作。

```javascript
- (void)cancelAllOperations;
```

队列通过调用对象方法`- (void)cancelAllOperations;`可以取消队列中尚未执行的操作。但是正在执行的操作不能够取消。

##### (5.2) 暂停、恢复

```javascript
@property (getter=isSuspended) BOOL suspended;
```

队列中的操作也可以暂停、恢复。通过调用suspended的set方法控制暂停还是恢复。如果传入YES，代表暂停，传入NO代表恢复。

##### (5.3) 主队列

```javascript
@property (class, readonly, strong) NSOperationQueue *mainQueue NS_AVAILABLE(10_6, 4_0);
```

操作队列给我们提供了获取主队列的属性mainQueue。如果想让某些操作在主线程执行，可以直接把操作添加到mainQueue中。

##### (5.4) maxConcurrentOperationCount

- maxConcurrentOperationCount代表队列同一时间允许执行的最多的任务数。或者理解为同一时间允许执行的最多线程数。 
- maxConcurrentOperationCount默认为-1，代表不限制。 
- maxConcurrentOperationCount 必须要提前设置，如果队列中添加了操作再设置maxConcurrentOperationCount就无效了。

 `警告：`如果希望操作在主线程中执行，不要设置maxConcurrentOperationCount = 0。直接把操作添加到mainQueue中即可。

##### (5.5) waitUntilAllOperationsAreFinished

为了最佳的性能,你应该设计你的应用尽可能地异步操作，让应用在Operation正在执行时可以去处理其它事情。如果需要在当前线程中处理operation完成后的结果,可以使用NSOperation的waitUntilFinished方法阻塞当前线程，等待operation完成。通常我们应该避免编写这样的代码,阻塞当前线程可能是一种简便的解决方案,但是它引入了更多的串行代码,限制了整个应用的并发性,同时也降低了用户体验。绝对不要在应用主线程中等待一个Operation,只能在第二或次要线程中等待。阻塞主线程将导致应用无法响应用户事件,应用也将表现为无响应。

```javascript
    // 会阻塞当前线程，等到某个operation执行完毕  
    [operation waitUntilFinished];  
```

除了等待单个Operation完成,你也可以同时等待一个queue中的所有操作,使用NSOperationQueue的waitUntilAllOperationsAreFinished方法。注意：在等待一个 queue时,应用的其它线程仍然可以往queue中添加Operation,因此可能会加长线程的等待时间。

```javascript
    // 阻塞当前线程，等待queue的所有操作执行完毕  
    [queue waitUntilAllOperationsAreFinished];  
```

`注意：`waitUntilAllOperationsAreFinished一定要在操作队列添加了操作后再设置。即，先向operation queue中添加operation，再调用`[operationQueue waitUntilAllOperationsAreFinished]`。

```javascript
    NSBlockOperation *blkop = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行操作 %@",[NSThread currentThread]);
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:blkop];
    // waitUntilAllOperationsAreFinished就像GCD的barrier一样起到隔离作用
    // waitUntilAllOperationsAreFinished必须要在操作添加到队列后设置
    // waitUntilAllOperationsAreFinished必须要在NSLog(@"finish");之前设置
waitUntilAllOperationsAreFinished
    [queue waitUntilAllOperationsAreFinished];
    
    NSLog(@"finish");
```

##### (5.6)operationCount

operationCount，顾名思义，就是指在队列中当前操作而数量。因为只有队列中的操作被执行完成后，这个operationCount值才会改变，所以operationCount值包括当前正在执行的operation和还没有被执行的操、operation。我们获取到的operationCount只是当前队列里操作数量的瞬间值。当我们用到这个operationCount的时候，很有可能队列中实际的operationCount已经发生了改变（因为操作有可能是异步执行的）。所以，苹果不建议我们在开发中使用这个值（比如根据这个值遍历数组中的操作或者进行一些其他精确的计算），很有可能引起错误甚至程序崩溃（比如，数组越界）。

如果你非要使用的话，建议你使用KVO的方式监听队列的operationCount的变化。杜绝直接使用operationCount。好吧，这句话是苹果爸爸说的：You may monitor changes to the value of this property using [Key-value observing](https://link.jianshu.com/?t=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fetc%2Fredirect%2Fxcode%2Fcontent%2F1189%2Fdocumentation%2FGeneral%2FConceptual%2FDevPedia-CocoaCore%2FKVO.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40008195-CH16). Configure an observer to monitor the `operationCount` key path of the operation queue.

例如：工作中曾经写过的一段代码，就有可能引起崩溃： (自定义了一个NSOperationQueue，并且覆写了addOperation:方法，当初写这段代码的初衷是当操作很多的时候，舍弃多余的操作，只处理maxTaskCount个操作)

```javascript
-(void)addOperation:(NSOperation *)op{
    self.suspended = YES;
    
    NSInteger cancelCount = self.operationCount - self.maxTaskCount;
    if (self.operationCount > self.maxTaskCount) {
        for (int i = 0; i < cancelCount; i++) {
            NSOperation *op = [self.operations objectAtIndex:i];
            if([op isKindOfClass:[NSOperation class]]){
                [op cancel];
            }else{
                break;
            }
        }
    }
    
    self.suspended = NO;
    [super addOperation:op];
}
```



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

![Snip20191119_93](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_93.png)

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

![Snip20191119_95](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_95.png)



### os_unfair_lock

os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持。

- 从底层调用看，等待os_unfair_lock锁的线程会处于休眠状态，并非忙等。

注意：需要导入头文件#import <os/lock.h>

如下：

![Snip20191119_96](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_96.png)



### mutex

mutex叫做”互斥锁”，等待锁的线程会处于休眠状态。

注意：需要导入头文件#import <pthread.h>

如下：

![Snip20191119_98](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_98.png)





#### pthread_mutex **–** **递归锁**  

注意：需要使用 **PTHREAD_MUTEX_RECURSIVE **初始化。

如下：

![Snip20191119_99](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_99.png)



#### pthread_mutex **–** 条件锁

如下：

![Snip20191119_100](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_100.png)



### NSLock

**NSLock**是对**mutex普通锁**的封装。

如下：

![Snip20191119_101](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_101.png)



### NSRecursiveLock

**NSRecursiveLock**也是对**mutex递归锁**的封装，API跟NSLock基本一致。



### NSCondition

**NSCondition**是对**mutex和cond**的封装。

如下：

![Snip20191119_102](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_102.png)



### NSConditionLock

**NSConditionLock**是对**NSCondition**的进一步封装，可以设置具体的条件值。

如下：

![Snip20191119_104](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_104.png)



### dispatch_semaphore

semaphore叫做“信号量”。

- 信号量的初始值，可以用来控制线程并发访问的最大数量。
- 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步。

如下：

![Snip20191119_105](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_105.png)



### dispatch_queue

直接使用GCD的串行队列，也是可以实现线程同步的。

如下：

![Snip20191119_106](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_106.png)



### @synchronized

**@synchronized**是对**mutex递归锁**的封装。源码查看：objc4中的objc-sync.mm文件。

- @synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁、解锁操作。

如下：

![Snip20191119_107](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_107.png)



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

![Snip20191119_108](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_108.png)



### dispatch_barrier_async 异步栅栏调用

使用dispatch_barrier_async 异步栅栏时，同一时间允许多个线程做**读动作**，同一时间只允许1个线程做**写动作**，且**不允许**读动作线程和写动作线程同时进行。

注意：

- 这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的。
- 如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果。

使用如下：

![Snip20191119_109](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_109.png)

如下图所示：

![Snip20191119_110](https://github.com/BrooksWon/Blogs/blob/master/OC/Objective-C%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B04-%E5%A4%9A%E7%BA%BF%E7%A8%8B/Snip20191119_110.png)
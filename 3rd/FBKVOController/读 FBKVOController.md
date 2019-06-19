# 读 FBKVOController

## 简介

[FBKVOController](https://github.com/facebook/KVOController)是对KVO机制的一层封装，同时提供了线程安全的特性和并对如下这个**臭名昭著**的函数进行了封装，提供了干净的block的回调/自定义SEL，避免了处理这个函数的逻辑散落的到处都是；优点如下：

- 通知是通过block、action或者NSKeyValueObserving回调（即-observeValueForKeyPath:ofObject:change:context）来实现；
- 不会出现移除observer的异常；
- 在controller销毁时隐式地移除observer；
- 保证了线程安全，避免出现[这样的异常](http://openradar.appspot.com/radar?id=5305010728468480)。
  

```
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
```

下面通过具体使用来感受下两种方式的区别

## 原生KVO使用

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 将 self 注册为 self.view 的观察者, 观察的属性是self.view的backgroundColor
    [self.view addObserver:self
                   forKeyPath:NSStringFromSelector(@selector(backgroundColor))
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];
    
}

//在 self 获取 number 的变化结果
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(backgroundColor))]) {
        NSLog(@" keyPath : %@,\n object = %@,\n change = %@",keyPath,object,change);
    }
}

//移除观察者
- (void)dealloc {
    [self.view removeObserver:self forKeyPath:NSStringFromSelector(@selector(backgroundColor))];
}
```

使用 KVO 的过程也非常的别扭和痛苦：

1. 需要手动**移除观察者**，且移除观察者的**时机必须合适**；
2. 注册观察者的代码和事件发生处的代码上下文不同，**传递上下文**是通过 `void *` 指针；
3. 需要覆写 `-observeValueForKeyPath:ofObject:change:context:` 方法，比较麻烦；
4. 在复杂的业务逻辑中，准确判断被观察者相对比较麻烦，有多个被观测的对象和属性时，需要在方法中写大量的 `if`进行判断；

## FBKVOController基本使用

如果想要实现同样的业务需求，当使用 KVOController 解决上述问题时，只需要以下代码就可以达到与上面**完全相同**的效果：

```
// 观察 self.view 的 backgroundColor 变化
    [self.KVOController observe:self.view
                        keyPath:NSStringFromSelector(@selector(backgroundColor))
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          block:^(id observer, id object, NSDictionary *change) {
                              NSLog(@" observer : %@,\n object = %@,\n change = %@",object,object,change);
                          }];
```

我们可以在任意对象上**获得** `KVOController` 对象，然后调用它的实例方法 `-observer:keyPath:options:block:` 就可以检测某个对象对应的属性了，该方法传入的参数还是非常容易理解的，在 block 中也可以获得所有与 KVO 有关的参数。

使用 KVOController 进行键值观测可以说完美地解决了在使用原生 KVO 时遇到的各种问题。

1. 不需要手动移除观察者；
2. 实现 KVO 与事件发生处的代码上下文相同，不需要跨方法传参数；
3. 使用 block 来替代方法能够减少使用的复杂度，提升使用 KVO 的体验；
4. 每一个 `keyPath` 会对应一个属性，不需要在 block 中使用 `if` 判断 `keyPath`；

## KVOController 的实现

KVOController 其实是对 Cocoa 中 KVO 的封装，它的实现其实也很简单，整个框架中只有两个实现文件，先来简要看一下 KVOController 如何为所有的 `NSObject` 对象都提供 `-KVOController` 属性的吧。

### 分类

FBKVOController 不止为 Cocoa Touch 中所有的对象提供了 `-KVOController` 属性还提供了另一个 `KVOControllerNonRetaining` 属性，实现方法就是分类和 ObjC Runtime。

```
@interface NSObject (FBKVOController)

@property (nonatomic, strong) FBKVOController *KVOController;
@property (nonatomic, strong) FBKVOController *KVOControllerNonRetaining;

@end
```

从名字可以看出 `KVOControllerNonRetaining` 在使用时并不会**持有**被观察的对象，与它相比 `KVOController` 就会持有该对象了。

对于 `KVOController` 和 `KVOControllerNonRetaining` 属性来说，其实现都非常简单，对运行时非常熟悉的读者都应该知道使用关联对象就可以轻松实现这一需求。

```
- (FBKVOController *)KVOController {
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerKey);
  if (nil == controller) {
    controller = [FBKVOController controllerWithObserver:self];
    self.KVOController = controller;
  }
  return controller;
}

- (void)setKVOController:(FBKVOController *)KVOController {
  objc_setAssociatedObject(self, NSObjectKVOControllerKey, KVOController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FBKVOController *)KVOControllerNonRetaining {
  id controller = objc_getAssociatedObject(self, NSObjectKVOControllerNonRetainingKey);
  if (nil == controller) {
    controller = [[FBKVOController alloc] initWithObserver:self retainObserved:NO];
    self.KVOControllerNonRetaining = controller;
  }
  return controller;
}

- (void)setKVOControllerNonRetaining:(FBKVOController *)KVOControllerNonRetaining {
  objc_setAssociatedObject(self, NSObjectKVOControllerNonRetainingKey, KVOControllerNonRetaining, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
```

两者的 `setter` 方法都只是使用 `objc_setAssociatedObject` 按照键值简单地存一下，而 `getter` 中不同的其实也就是对于 `FBKVOController` 的初始化了。

[![easy](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/easy.jpg)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/easy.jpg)

到这里这个整个 FBKVOController 框架中的两个实现文件中的一个就介绍完了，接下来要看一下其中的另一个文件中的类 FBKVOController`。

### FBKVOController 的初始化

`FBKVOController` 是整个框架中提供 KVO 接口的类，作为 KVO 的管理者，其必须持有当前对象所有与 KVO 有关的信息，而在 FBKVOController` 中，用于存储这个信息的数据结构就是 `NSMapTable`。

[![KVOControlle](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/KVOController.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/KVOController.png)

为了使 `FBKVOController` 达到线程安全，它还必须持有一把 `pthread_mutex_t` 锁，用于在操作 `_objectInfosMap` 时使用。

再回到上一节提到的初始化问题，`NSObject` 的属性 `FBKVOController` 和 `KVOControllerNonRetaining` 的区别在于前者会持有观察者，使其引用计数加一。

```

//1.
@implementation FBKVOController
{
  NSMapTable *_objectInfosMap;
  pthread_mutex_t _lock;
}

//2.
- (instancetype)initWithObserver:(id)observer retainObserved:(BOOL)retainObserved
{
  self = [super init];
  if (nil != self) {
    // 2.
    _observer = observer;

    // 3.
    NSPointerFunctionsOptions keyOptions = retainObserved ? NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPointerPersonality : NSPointerFunctionsWeakMemory|NSPointerFunctionsObjectPointerPersonality;
    _objectInfosMap = [[NSMapTable alloc] initWithKeyOptions:keyOptions valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsObjectPersonality capacity:0];

    // 4.
    pthread_mutex_init(&_lock, NULL);
  }
  return self;
}
```

1. 首先我们看到，这个对象持有一个`pthread_mutex_t`及一个`NSMapTable`。其中`pthread_mutex_t`即为互斥锁，当多个线程竞争相同的**critical section**时，起到保护作用。`NSMapTable`可能大家接触不是很多，我们在后文会详细介绍，这里大家可以先理解为一个高级的NSDictionary。

2. 在构造函数中，首先将传入的observer进行`weak`持有，这主要为了避免**Retain Cycle**。	

   ```
   // FBKVOController.h
   
   /**
    The observer notified on key-value change. Specified on initialization.
    */
   @property (nullable, nonatomic, weak, readonly) id observer;
   ```

   

3. 这一段的内容可能大家不太熟悉，`NSPointerFunctionsOptions`简单来说就是定义`NSMapTable`中的key和value采用何种内存管理策略，包括`strong`强引用，`weak`弱引用以及`copy`（要支持NSCopying协议）

4. 初始化`pthread_mutex_t`互斥锁

接下来，使我们通过`FBKVOController`来对一个对象的某个或者某些keypath进行观察。

### KVO 的过程

使用 `FBKVOController` 实现键值观测时，大都会调用实例方法 `-observe:keyPath:options:block` 来注册成为某个对象的观察者，监控属性的变化：

```
- (void)observe:(id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FBKVONotificationBlock)block
{
  NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);
  if (nil == object || 0 == keyPath.length || NULL == block) {
    return;
  }

  // 1. create info
  _FBKVOInfo *info = [[_FBKVOInfo alloc] initWithController:self keyPath:keyPath options:options block:block];

  // 2. observe object with info
  [self _observe:object info:info];
}
```

为了方便后续阅读，简单介绍一下`_FBKVOInfo`，如下：

#### 数据结构 _FBKVOInfo

这个方法中就涉及到另外一个私有的数据结构 `_FBKVOInfo`，这个类中包含着所有与 KVO 有关的信息：

[![_FBKVOInfo](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/_FBKVOInfo.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/_FBKVOInfo.png)

`_FBKVOInfo` 在 `KVOController` 中充当的作用仅仅是一个数据结构，我们主要用它来存储整个 KVO 过程中所需要的全部信息，其内部没有任何值得一看的代码，需要注意的是，`_FBKVOInfo` 覆写了 `-isEqual:` 方法用于对象之间的判等以及方便 `NSMapTable` 的存储。

如果再有点别的什么特别作用的就是，其中的 `state` 表示当前的 KVO 状态，不过在本文中不会具体介绍。

```
typedef NS_ENUM(uint8_t, _FBKVOInfoState) {
  _FBKVOInfoStateInitial = 0,
  _FBKVOInfoStateObserving,
  _FBKVOInfoStateNotObserving,
};
```

#### 继续说observe 的过程

在使用 `-observer:keyPath:options:block:` 监听某一个对象属性的变化时，该过程的核心调用栈其实还是比较简单：

[![KVOController-Observe-Stack](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/KVOController-Observe-Stack.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/KVOController-Observe-Stack.png)

我们从栈底开始简单分析一下整个封装 KVO 的过程，其中栈底的方法，也就是我们上面提到的 `-observer:keyPath:options:block:` 初始化了一个名为 `_FBKVOInfo` 的对象：

```
- (void)observe:(nullable id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FBKVONotificationBlock)block
{
  NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);
  if (nil == object || 0 == keyPath.length || NULL == block) {
    return;
  }

  // create info
  _FBKVOInfo *info = [[_FBKVOInfo alloc] initWithController:self keyPath:keyPath options:options block:block];

  // observe object with info
  [self _observe:object info:info];
}
```

1. 对于传入的参数，构建一个内部的FBKVOInfo数据结构
2. 调用`[self _observe:object info:info];`

接下来，我们来跟踪一下`[self _observe:object info:info];`，内容如下：

```
- (void)_observe:(id)object info:(_FBKVOInfo *)info
{
  // lock
  pthread_mutex_lock(&_lock);

	// 1.
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];

  // 2. 
  _FBKVOInfo *existingInfo = [infos member:info];
  
  if (nil != existingInfo) {
    // observation info already exists; do not observe it again

    // unlock and return
    pthread_mutex_unlock(&_lock);
    return;
  }

  // lazilly create set of infos
  if (nil == infos) {
    infos = [NSMutableSet set];
    [_objectInfosMap setObject:infos forKey:object];
  }

  // add info and oberve
  [infos addObject:info];

  // unlock prior to callout
  pthread_mutex_unlock(&_lock);

	 // 3.
  [[_FBKVOSharedController sharedController] observe:object info:info];
}
```

抛开Facebook自身标记的注释，有三处比较值得我们注意：

1. 根据被观察的object获取其对应的**infos set**。这个主要作用在于避免多次对同一个keyPath添加多次观察，避免crash。**因为每调用一次addObserverForKeyPath就要有一个对应的removeObserverForKey。**
2. 从**infos set**判断是不是已经有了与此次info相同的观察。
3. 如果以上都顺利通过，将观察的信息及关系注册到`_FBKVOSharedController`中。

在这个 `_objectInfosMap` 中保存着对象以及与对象有关的 `_FBKVOInfo` 集合，如下图:



[![objectInfosMap](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/objectInfosMap.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/objectInfosMap.png)



## FBKVOSharedController

初次看到这个类的时候，我的脑海中浮现了两个问题，FBKVOSharedController是干嘛的?为什么FBKVOController还需要将观察的信息转交呢？

**其实我个人觉得这一层不是必要的**，但是按照Facebook的理念来说就是将所有的观察信息统一交由一个`FBKVOSharedController`的**单例**进行维护。如果大家读过Facebook出品的**Flux**架构，也会发现，Facebook经常喜欢维护一个类似于中间件的注册表，在这里，`FBKVOSharedController`承担的也是类似的职责。

于是，通过如下方法，我们像使用注册表一样将对KVOInfo注册。

```
- (void)observe:(id)object info:(nullable _FBKVOInfo *)info {
  pthread_mutex_lock(&_mutex);
  [_infos addObject:info];
  pthread_mutex_unlock(&_mutex);

	// 1.
  [object addObserver:self forKeyPath:info->_keyPath options:info->_options context:(void *)info];

  if (info->_state == _FBKVOInfoStateInitial) {
    info->_state = _FBKVOInfoStateObserving;
  } else if (info->_state == _FBKVOInfoStateNotObserving) {
    [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
  }
}
```

1. 代表所有的观察信息都首先由`FBKVOSharedController`进行接受，随后进行转发。

实现`observeValueForKeyPath:ofObject:Change:context`
来接收通知。

```
- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context
{
  NSAssert(context, @"missing context keyPath:%@ object:%@ change:%@", keyPath, object, change);

  _FBKVOInfo *info;

  {
    // 1
    pthread_mutex_lock(&_mutex);
    info = [_infos member:(__bridge id)context];
    pthread_mutex_unlock(&_mutex);
  }

  if (nil != info) {

    // 2
    FBKVOController *controller = info->_controller;
    if (nil != controller) {

      // 2
      id observer = controller.observer;
      if (nil != observer) {

        // 3
        if (info->_block) {
          NSDictionary<NSKeyValueChangeKey, id> *changeWithKeyPath = change;
          // add the keyPath to the change dictionary for clarity when mulitple keyPaths are being observed
          if (keyPath) {
            NSMutableDictionary<NSString *, id> *mChange = [NSMutableDictionary dictionaryWithObject:keyPath forKey:FBKVONotificationKeyPathKey];
            [mChange addEntriesFromDictionary:change];
            changeWithKeyPath = [mChange copy];
          }
          info->_block(observer, object, changeWithKeyPath);
        } else if (info->_action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
          [observer performSelector:info->_action withObject:change withObject:object];
#pragma clang diagnostic pop
        } else {
          [observer observeValueForKeyPath:keyPath ofObject:object change:change context:info->_context];
        }
      }
    }
  }
}
```

1. 根据context上下文获取对应的KVOInfo

2. 判断当前**info**的`controller ` 和 **controller**的`observer`的，是否仍然存在（因为之前我们采用的weak持有）	

   ```
   // _FBKVOInfo.m
   
   @implementation _FBKVOInfo
   {
   @public
     __weak FBKVOController *_controller;
     
     ...
   }
   ```

   ```
   // FBKVOController.h
   
   /**
    The observer notified on key-value change. Specified on initialization.
    */
   @property (nullable, nonatomic, weak, readonly) id observer;
   ```

   

3. 根据 `info`的`block`或者`selector`或者`override`进行消息转发。

[![KVOSharedControlle](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/KVOSharedController.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/KVOSharedController.png)

上图就是在使用 KVOController 时，如果一个 KVO 事件触发之后，整个框架是如何对这个事件进行处理以及回调的。

## 如何 removeObserver

在使用 KVOController 时，我们并不需要手动去处理 KVO 观察者的移除，因为所有的 KVO 事件都由私有的 `_KVOSharedController` 来处理；

[![KVOController-Unobserve-Stack](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/KVOController-Unobserve-Stack.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/KVOController-Unobserve-Stack.png)

当每一个 `KVOController` 对象被释放时，都会将它自己持有的所有 KVO 的观察者交由 `_KVOSharedController` 的 `-unobserve:infos:` 方法处理：

```
- (void)unobserve:(id)object infos:(nullable NSSet<_FBKVOInfo *> *)infos {
  pthread_mutex_lock(&_mutex);
  for (_FBKVOInfo *info in infos) {
    [_infos removeObject:info];
  }
  pthread_mutex_unlock(&_mutex);

  for (_FBKVOInfo *info in infos) {
    if (info->_state == _FBKVOInfoStateObserving) {
      [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
    }
    info->_state = _FBKVOInfoStateNotObserving;
  }
}
```

该方法会遍历所有传入的 `_FBKVOInfo`，从其中取出 `keyPath` 并将 `_KVOSharedController` 移除观察者。

除了在 `KVOController` 析构时会自动移除观察者，我们也可以通过它的实例方法 `-unobserve:keyPath:` 操作达到相同的效果；不过在调用这个方法时，我们能够得到一个不同的调用栈：

[![KVOController-Unobserve-Object-Stack](https://github.com/draveness/analyze/raw/master/contents/KVOController/images/KVOController-Unobserve-Object-Stack.png)](https://github.com/draveness/analyze/blob/master/contents/KVOController/images/KVOController-Unobserve-Object-Stack.png)

功能的实现过程其实都是类似的，都是通过 `-removeObserver:forKeyPath:context:` 方法移除观察者：

```
- (void)unobserve:(id)object info:(nullable _FBKVOInfo *)info {
  pthread_mutex_lock(&_mutex);
  [_infos removeObject:info];
  pthread_mutex_unlock(&_mutex);

  if (info->_state == _FBKVOInfoStateObserving) {
    [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
  }
  info->_state = _FBKVOInfoStateNotObserving;
}
```

不过由于这个方法的参数并不是一个数组，所以并不需要使用 `for` 循环，而是只需要将该 `_FBKVOInfo` 对应的 KVO 事件移除就可以了。

到这里，`FBKVOController`整体的实现就介绍完了，怎么样，是不是局部看自己都会实现，但是一结合起完整的设计思路，就觉得，不亏是Facebook呢。



## 一些点

### NSMapTable

之前我们在前文中提到了`NSMapTable`，现在我们来详细介绍他一下。
我们在平常的开发中都使用过`NSDictionary`或者`NSMutableDictionary`，但是这两种数据结构有其的局限性。

以`NSDictionary`为例，`NSDictionary`将`key`的`hash`值作为索引，存储对应的`value`。因此，`key`的要求是不能更改。所以，`NSDictionary`为了确保安全，对于`key`采用了**copy**的策略。

默认情况下，支持**NSCopying**协议的类型都可以作为key。但是考虑到copy带来的开销，一般情况下我们都使用简单的诸如数字或者字符串作为key。

那么，如果要使用`Object`作为key，想构建**Object to Object**的关系怎么办呢？这个时候就用到`NSMapTable`。我们可以通过NSFunctionsPointer来分别定义对key和value的储存关系，简单可以分类为`strong`,`weak`以及`copy`。而当利用`object`作为key的时候，可以定义评判相等的标准，如：**use shifted pointer hash and direct equality, object description或者size**。

具体你需要去override如下几种方法：

```
// pointer personality functions
@property (nullable) NSUInteger (*hashFunction)(const void *item, NSUInteger (* __nullable size)(const void *item));
@property (nullable) BOOL (*isEqualFunction)(const void *item1, const void*item2, NSUInteger (* __nullable size)(const void *item));
@property (nullable) NSUInteger (*sizeFunction)(const void *item);
@property (nullable) NSString * __nullable (*descriptionFunction)(const void *item);
```

在`FBKVOController`自定义的可以作为key的结构`FBKVOInfo`，就复写了

```
- (NSUInteger)hash
{
  return [_keyPath hash];
}

- (BOOL)isEqual:(id)object
{
  if (nil == object) {
    return NO;
  }
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[self class]]) {
    return NO;
  }
  return [_keyPath isEqualToString:((_FBKVOInfo *)object)->_keyPath];
}
```



### __builtin_ctzl

在创建 option的描述文本的时候调用了一个这样的方法

```
/**
 返回最后一个1 然后修改传递进来的flags

 @param ptrFlags 整体的flags
 @return 获得的最后一个1
 */
static NSUInteger enumerate_flags(NSUInteger *ptrFlags)
{
  NSCAssert(ptrFlags, @"expected ptrFlags");
  if (!ptrFlags) {
    return 0;
  }

  NSUInteger flags = *ptrFlags;
  if (!flags) {
    // 如果全是0 表示解析完成了 返回0
    return 0;
  }

  // 这个相当于把最后一个1 拿到
  NSUInteger flag = 1 << __builtin_ctzl(flags);
  // 然后把这个东西从flags中删除掉
  flags &= ~flag;
  *ptrFlags = flags;
  return flag;
}
复制代码
```

这是处理二进制位的内置函数，关于更多的此类函数相关，可以通过这个链接进行查看 [点这里](https://www.cnblogs.com/nysanier/archive/2011/04/19/2020778.html)

### FBKVOKeyPath 和  FBKVOClassKeyPath

```
/**
 This macro ensures that key path exists at compile time.
 Given a real receiver with a key path as you would call it, it verifies at compile time that the key path exists, without calling it.

 For example:

 FBKVOKeyPath(string.length) => @"length"

 Or even the complex case:

 FBKVOKeyPath(string.lowercaseString.length) => @"lowercaseString.length".
 */
#define FBKVOKeyPath(KEYPATH) \
@(((void)(NO && ((void)KEYPATH, NO)), \
({ const char *fbkvokeypath = strchr(#KEYPATH, '.'); NSCAssert(fbkvokeypath, @"Provided key path is invalid."); fbkvokeypath + 1; })))

/**
 This macro ensures that key path exists at compile time.
 Given a receiver type and a key path, it verifies at compile time that the key path exists, without calling it.

 For example:

 FBKVOClassKeyPath(NSString, length) => @"length"
 FBKVOClassKeyPath(NSString, lowercaseString.length) => @"lowercaseString.length"
 */
#define FBKVOClassKeyPath(CLASS, KEYPATH) \
@(((void)(NO && ((void)((CLASS *)(nil)).KEYPATH, NO)), #KEYPATH))
```

`((void)(NO && ((void)KEYPATH, NO))`
 这一块第一个NO和第三个NO是为了让中间的KEYPATH不进行运算，这样就能防止，这里进行了getter方法而产生不必要的问题。相关文档在这里[Compile-time Key Paths Verification]([http://lldong.github.io/2014/02/24/key-paths-validation.html](http://lldong.github.io/2014/02/24/key-paths-validation.html))



**参考**

- https://satanwoo.github.io/2016/02/27/FBKVOController/
- https://github.com/Draveness/Analyze/blob/master/contents/KVOController/KVOController.md
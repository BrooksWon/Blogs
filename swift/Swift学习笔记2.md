# Swift学习笔记2

## 从OC到Swift

**MARK、TODO、FIXME**

- `// MARK:` 类似于中的 `#progma mark`
- `// MARK: -` 类似于OC中的 `#pragma mark -`
- `// TODO:` 用于标记未完成的任务
- `// FIXME:` 用于标记待修复的问题



**条件编译**

这个没啥好说的，和OC一样~



**打印**

```swift
func log<T>(_ msg: T,
            file: NSString = #file,
            line: Int = #line,
            fn: String = #function) {
    #if DEBUG
    let prefix = "\(file.lastPathComponent)_\(line)_\(fn):"
    print(prefix, msg)
    #endif
}
```



**系统版本检测**

```swift
if #available(iOS10, macOS 10.12, *) {
    // 对于iOSp平台，只在iOS10及以上版本执行
    // 对于macOS平台，只在macOS 10.12s及以上版本执行
    // 最后*表示在其他所有平台都执行
}
```



**API可用性说明**

用法参考：*https://docs.swift.org/swift-book/ReferenceManual/Attributes.html*



**iOS程序入口**

在 AppDelegates 上面默认有个 **@UIApplicationMain** 标记，这表示编译器自动生成代码入口（main函数代码），自动设置 AppDelegate 为APP的代理。

当然、也可以删掉 **@UIApplicationMain** ，自定义入口代码：新建1个 main.swift 文件。

示例如下：

```swift
import UIKit

class MyApplication: UIApplication {}

UIApplicationMain(CommandLine.argc,
                  CommandLine.unsafeArgv,
                  NSStringFromClass(MyApplication.self),
                  NSStringFromClass(MyAppDelegate.self))
```



### Swift调用OC

新建1和桥接头文件，文件名默认格式为：`{targetName}-Bridging-Header.h` 。在 `{targetName}-Bridging-Header.h` 文件中 `#import` OC需要暴露给Swift的内容。

如下示例：

```objective-c
//  Demo-Bridging-Header.h

#import "TestPerson.h"
```

 下面是 TestPerson 的 .h 和.m 文件内容：

```objective-c
// TestPerson.h
int sum(int a, int b); // c函数

@interface TestPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithAge:(NSInteger)age name:(NSString *)name;
+ (instancetype)personWithAge:(NSInteger)age name:(NSString *)name;

- (void)run;
+ (void)run;

- (void)eat:(NSString *)food other:(NSString *)other;
+ (void)eat:(NSString *)food other:(NSString *)other;

@end

--------------------------------
// TestPerson.m  
int sum(int a, int b) {
    return a + b;
}

@implementation TestPerson

- (instancetype)initWithAge:(NSInteger)age name:(NSString *)name {
    if (self = [super init]) {
        self.age = age;
        self.name = name;
    }
    return self;
}

+ (instancetype)personWithAge:(NSInteger)age name:(NSString *)name {
    return [[self alloc] initWithAge:age name:name];
}

- (void)run {
    NSLog(@"%@ %@ -run", _name, @(_age));
}
+ (void)run {
    NSLog(@"Person +run");
}

- (void)eat:(NSString *)food other:(NSString *)other {
    NSLog(@"%@ %@ -eat %@ %@", _name, @(_age), food, other);
}
+ (void)eat:(NSString *)food other:(NSString *)other {
    NSLog(@"Person +eat %@ %@", food, other);
}
@end
```



一切准备就绪，开始用swift调用OC代码。如下：

```swift
var p = TestPerson(age: 10, name: "Jack")
p?.age = 18
p?.name = "Rose"
p?.run() //Rose 18 -run
p?.eat("apple", other: "water") //Rose 18 -eat apple water

TestPerson.run() //Person +run
TestPerson.eat("Pizza", other: "Banana") //Person +eat Pizza Banana

// 调用OC文件中的C函数
print(sum(10, 20))//30
```



**@_silgen_name**

如果C语言暴露给Swift的函数名跟Swift中的其他函数名冲突了，可以在Swift中使用 **@_silgen_name** 修改C函数名。

 比如将上面的C语言函数 sum 修改名字，操作如下：

```swift
 @_silgen_name("sum") func swift_sum(_ v1: Int32, _ v2: Int32) -> Int32;
```

修改之后，调用如下：

```swift
 print(swift_sum(11, 22)) // 33
```



## OC调用Swift

Xcode已经默认生成一个用于OC调用Swift的头文件，文件名格式是：**{targetName}-Swift.h** 。

Xcode会根据Swift代码生成对应的OC声明，写入**{targetName}-Swift.h**文件。

那么、哪些Swift代码能被OC调用呢？这取决于Swift暴露给OC哪些内容。

Swift暴露给OC调用的代码需要遵守哪些规则呢？如下：

- Swift暴露给OC的类最终继承自**NSObject**。
- 使用**@objc**修饰需要暴露给OC的成员。
- 使用@objcMembers修饰类：代表默认所有成员都会暴露给OC（包括扩展中定义的成员）；最终是否成功暴露，还需要考虑成员自身的访问级别。



下面来看一个Swift暴露给OC调用的示例：

```swift
// swift代码
@objcMembers class Car: NSObject {
    var price: Double
    var band: String
    init(price: Double, band: String) {
        self.price = price
        self.band = band
    }
    func run() {
        print(band, price, "run")
    }
    static func run() {
        print("Car run")
    }
}
extension Car {
    func test() {
        print(band, price, "test")
    }
}
```

上面说过：Xcode会根据Swift代码生成对应的OC声明，写入**{targetName}-Swift.h**文件。

文件中就是下面这些东西：

```swift
@interface Car : NSObject
@property (nonatomic) double price;
@property (nonatomic, copy) NSString * _Nonnull band;
- (nonnull instancetype)initWithPrice:(double)price band:(NSString * _Nonnull)band OBJC_DESIGNATED_INITIALIZER;
- (void)run;
+ (void)run;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end
```



下面继续看一下，OC实际的调用示例：

```objective-c
Car *c = [[Car alloc] initWithPrice:10.5 band:@"BMW"];
c.band = @"Bently";
c.price = 108.5;
[c run]; //Bently 108.5 run
[c test]; //Bently 108.5 test

[Car run]; //Car run
```



可以通过 **@objc** 重命名暴露给OC的符号名（类名、属性名、函数名等）。

如下：

```swift
@objc(TestCar)
@objcMembers class Car: NSObject {
    var price: Double
    @objc(name)
    var band: String
    init(price: Double, band: String) {
        self.price = price
        self.band = band
    }
    @objc(drive)
    func run() {
        print(band, price, "run")
    }
    static func run() {
        print("Car run")
    }
}
extension Car {
    @objc(testCar)
    func test() {
        print(band, price, "test")
    }
}
```



重命名之后的调用示例如下：

```objective-c
TestCar *c = [[TestCar alloc] initWithPrice:10.5 band:@"BMW"];
c.name = @"Bently";
c.price = 108.5;
[c drive];
[c testCar];

[TestCar run]; 
```



## 选择器（selector）

Swift依然可以哦使用选择器，使用 #selector(name) 定义一个选择器。

注意：必须是被 @objcMembers 或 @objc 修饰的方法才可以定义选择器。

如下示例：

```swift
@objcMembers class TestClass: NSObject {
    func test1(v1: Int) -> Int {
        print("test1", v1)
        return 10
    }
    func test2(v1: Int, v2: Int) {
        print("test2", v1, v2)
    }
    func test3(_ v1: Double, _ v2: Int) {
        print("test3", v1, v2)
    }
    func run() {
        perform(#selector(test1(v1:)))
        perform(#selector(test2(v1:v2:)))
        perform(#selector(test3(_:_:)))
    }
}
```



## Swift 和 OC 常见数据类型的桥接转换表

Swift和OC之间的常见数据类型可以随时随地的桥接转换，如果觉得Swift的常见数据类型复杂难用，可以考虑使用OC的。

下面是两种语言之间常见数据类型的桥接转换表：

| Swift      | 相互转换关系 | OC                  |
| ---------- | ------------ | ------------------- |
| String     | ⇌            | NSString            |
| String     | ⟵            | NSMutableString     |
| Array      | ⇌            | NSArray             |
| Array      | ⟵            | NSMutableArray      |
| Dictionary | ⇌            | NSMutableDictionary |
| Dictionary | ⟵            | NSMutableDictionary |
| Set        | ⇌            | NSSet               |
| Set        | ⟵            | NSMutableSet        |



## 只能被class继承的协议

以下三种协议只能被 类 继承。

```
protocol Runnable1: AnyObject {}
protocol Runnable2: class {}
@objc protocol Runnable3 {}
```

注意：被 **@objc** 修饰的协议，还可以暴露给OC去遵守。



**可选协议**

可以通过 @objc 定义可选协议，这种协议只能被 class 遵守。

如下示例：

```swift
@objc protocol Runnable {
    func run1()
    @objc optional func run2()
    func run3()
}
class Dog: Runnable {
    func run1() { print("Dog run1") }
    func run3() { print("Dog run3") }
}

var d = Dog()
d.run1()
d.run3()
```



## dynamic

被 `@objc dynamic` 修饰的内容具有动态性，比如调用方法会走runtime那一套流程。

示例如下：

```swift
class Dog: NSObject {
    @objc dynamic func test1() {}
    func test2() {}
}

var d = Dog()
d.test1()
d.test2()

```

d.test1()的调用流程，反汇编代码如下图所示：

![](https://github.com/BrooksWon/Blogs/blob/master/swift/Snip20191107_20.png)

d.test2()的调用流程，反汇编代码如下图所示：

![](https://github.com/BrooksWon/Blogs/blob/master/swift/Snip20191107_21.png)

显然，test1()走的是runtime流程，test2（）不是。



## KVC\KVO

Swift要想支持KVC\KVO，需要满足以下条件：

- 属性所在的类、监听器最终需继承自NSObject。
- 用 `@objc  dynamic` 修饰对应的属性。



如下示例：

```swift
class Oberserver: NSObject {
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        print("observeValue", change?[.newKey] as Any)
    }
}

class Person: NSObject {
    @objc dynamic var age: Int = 0
    var observer: Oberserver = Oberserver()
    override init() {
        super.init()
        self.addObserver(observer,
                         forKeyPath: "age",
                         options: .new,
                         context: nil)
    }
    deinit {
        self.removeObserver(observer, forKeyPath: "age")
    }
}

var p = Person()
p.age = 20 //observeValue Optional(20)
p.setValue(25, forKey: "age") //observeValue Optional(25)
```



**block方式的KVO**

直接看代码~

```swift
class Person: NSObject {
    @objc dynamic var age: Int = 0
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        observation = observe(\Person.age, options: .new) {
            (person, change) in
            print(change.newValue as Any)
        }
    }
}

var p = Person()
p.age = 20 // Optional(20)
p.setValue(25, forKey: "age") // Optional(25)
```



## 关联对象（Associated Object）

在Swift中，class依然可以使用关联对象。

默认情况下，extension不可以增加存储属性；借助关联对象，可以实现类似extension为class增加存储属性的效果。

如下示例：

```swift
class Person {}
extension Person {
    private static var AGE_KEY: Void?
    var age: Int {
        get {
            (objc_getAssociatedObject(self, &Self.AGE_KEY) as? Int) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &Self.AGE_KEY, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

var p = Person()
print(p.age) // 0
p.age = 20
print(p.age) // 20
```


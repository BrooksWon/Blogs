## 内存管理

和OC一样，Swift也是基于引用计数的ARC内存管理方案（针对堆空间）。

Swift的ARC中有3种引用：

- 强引用（strong reference）：默认情况下，引用都是强引用。
- 弱引用（weak reference）：通过**weak**定义弱引用。
  - 必须是可选类型的var，因为实力销毁后，ARC会自动将弱引用设置为nil。
  - ARC自动给弱引用设置nil时，不会触发属性观察器。
- 无主引用（unowned reference）：通过**unowned**定义无主引用。
  - 不会产生强引用，实力销毁后仍然存储着实例的内存地址（类似与OC中的 **unsafe_unretained**）。
  - 视图在实例销毁后访问无主引用，会产生运行时错误（野指针）。



**weak、unowned的使用限制**

weak、unowned只能用在类实例上面。

如下示例：

```swift
protocol Livable: AnyObject {}
class Person: Livable {}

weak var p0: Person?
weak var p1: AnyObject?
weak var p2: Livable?

unowned let p11: Person
unowned let p12: AnyObject
unowned let p13: Livable
```



**autoreleasepool**

定义:

```swift
public func autoreleasepool<Result>(invoking body: () throws -> Result) rethrows -> Result
```

使用示例：

```swift
class Person{}

autoreleasepool {
    let p = Person()
    //todo
}
```



**循环引用（Reference Cycle）**

weak、unowned 都能解决循环引用的问题，unowned 要比 weak 少一些性能消耗。

- 在声明周期中可能会变为nil的使用weak。
- 初始化赋值后再也不会变为nil的使用unowned。



**闭包的循环引用**

闭包表达式默认会对用到的外层对象产生额外的强引用（对外层进行了retain操作）。

下面代码会产生循环引用，导致Person对象无法释放。

```swift
class Person{
    var fn: (() -> ())?
    func run() {
        print("run")
    }
    deinit {
        print("deinit")
    }
}

func test() {
    let p = Person()
    p.fn = {
        p.run()
    }
}

test()
```

**在闭包表达式的捕获列表声明 weak 或 unowned 引用， 解决循环引用问题。**

可以将上面代码修改如下：

```swift
func test() {
    let p = Person()
    p.fn = {
        [weak p] in
        p?.run()
    }
}
```

或者

```swift
func test() {
    let p = Person()
    p.fn = {
        [unowned p] in
        p.run()
    }
}
```



如果想在定义闭包属性的同时引用self，这个闭包必须是lazy的（因为在实例初始化完毕之后才能引用self）。

```swift
class Person{
    // 闭包fn内部如果用到了实例成员（属性、方法），编译器会强制要求明确写出self。
    lazy var fn: (() -> ()) = {
        [weak self] in
        self?.run()
    }
    func run() {
        print("run")
    }
    deinit {
        print("deinit")
    }
}
```

如果 lazy 属性时闭包调用的结果，那么不用考虑循环引用的问题（因为闭包调用后，闭包的生命周期就结束了）。

如下示例：

```swift
class Person{
    var age: Int = 0
    // 改闭包调用后，闭包的生命周期就结束了。因此不会造成循环引用。
    lazy var getAge: Int = {
        self.age
    }()
    deinit {
        print("deinit")
    }
}

func test() {
    let p = Person()
    let _ = p.getAge
}

test()
```



**内存访问冲突**

内存访问冲突还在2个访问满足下列条件时发生：

- 至少一个是写操作。
- 它们访问的是同一块内存。
- 它们的访问时间重叠（比如在同一个函数内）。

如下示例：

```swift
// 存在内存访问冲突
// Simultaneous accesses to 0x100001198, but modification requires exclusive access
var step = 1
func increment(_ num: inout Int) {
    num += step // 同时读写一块内存空间,因才会冲突
}
increment(&step)
```

如何解决上面代码的内存访问冲突，如下即可：

```swift
// 解决内存访问冲突
var copyOfStep = step
increment(&copyOfStep)
step = copyOfStep
```



如果下面的条件可以满足， 就说明重叠方法结构体的属性是安全的。

- 你只访问实例存储属性，不是计算属性或者类属性。
- 结构体是局部变量而非全局变量。
- 结构体要么没有闭包捕获，要么只被非逃逸闭包捕获。



**指针**

Swift中也有专门的指针类型，这些都被定性为 **Unsafe**（不安全的），常见的有以下4种类型：

- **UnsafePointer<Pointee>** 类似于 const Pointee *
- **UnsafeMutablePointer<Pointee>** 类似于 Pointee *
- **UnsafeRawPointer** 类似于 const void *
- **UnsafeMutableRawPointer** 类似于 void *

如下示例：

```swift
var age = 10
func test1(_ ptr: UnsafeMutablePointer<Int>) {
    ptr.pointee += 10
}
func test2(_ ptr: UnsafePointer<Int>) {
    print(ptr.pointee)
}
test1(&age)
test2(&age) // 20
print(age) // 20

var num = 5
func test3(_ ptr: UnsafeMutableRawPointer) {
    ptr.storeBytes(of: 11, as: Int.self)
}
func test4(_ ptr: UnsafeRawPointer) {
    print(ptr.load(as: Int.self))
}
test3(&num)
test4(&num) // 11
print(num) // 11
```



**指针的应用示例**

```swift
var arr = NSArray(objects: 11, 22, 33, 44)
arr.enumerateObjects { (obj, index, stop) in
    print(index, obj)
    if index == 2 {
        stop.pointee = true
    }
}
```



**获得指向某个变量的指针**

```swift
var age = 11
var ptr1 = withUnsafeMutablePointer(to: &age) { $0 }
var ptr2 = withUnsafePointer(to: &age) { $0 }

ptr1.pointee = 22
print(ptr2.pointee) // 22
print(age) // 22

var ptr3 = withUnsafeMutablePointer(to: &age) { UnsafeMutableRawPointer($0) }
var ptr4 = withUnsafePointer(to: &age) { UnsafeRawPointer($0) }
ptr3.storeBytes(of: 33, as: Int.self)
print(ptr4.load(as: Int.self)) // 33
print(age) // 33

```



**获得指向堆空间实例的指针**

```swift
class Person {}
var person = Person()

var ptr = withUnsafePointer(to: &person) { UnsafeRawPointer($0) }
var heapPtr = UnsafeRawPointer(bitPattern: ptr.load(as: UInt.self))
print(heapPtr!)
print(heapPtr!)
```



**创建指针**

示例1

```swift
var ptrX = UnsafeRawPointer(bitPattern: 0x100001234)

// 创建
var ptr = malloc(16)
// 存
ptr?.storeBytes(of: 10, as: Int.self)
ptr?.storeBytes(of: 20, toByteOffset: 8, as: Int.self)
// 取
print((ptr?.load(as: Int.self))!) // 10
print((ptr?.load(fromByteOffset: 8, as: Int.self))!) // 20
// 销毁
free(ptr)

```



示例2

```swift
// 创建
var ptr = UnsafeMutablePointer<Int>.allocate(capacity: 3)

//存
ptr.initialize(to: 11)
ptr.successor().initialize(to: 22)
ptr.successor().successor().initialize(to: 33)


// 取
print(ptr.pointee) // 11
print((ptr + 1).pointee) // 22
print((ptr + 2).pointee) // 33

print(ptr[0]) // 11
print(ptr[1]) // 22
print(ptr[2]) // 33

// 销毁
ptr.deinitialize(count: 3)
ptr.deallocate()
```



示例3

```swift
class Person {
    var age: Int
    var name: String
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
    deinit {
        print(name ,"deinit")
    }
}

// 创建
var ptr = UnsafeMutablePointer<Person>.allocate(capacity: 3)

//存
ptr.initialize(to: Person(age: 10, name: "Jack"))
(ptr + 1).initialize(to: Person(age: 11, name: "Rose"))
(ptr + 2).initialize(to: Person(age: 12, name: "Kate"))

//Jack deinit
//Rose deinit
//Kate deinit

// 销毁
ptr.deinitialize(count: 3)
ptr.deallocate()
```



**指针之间的转换**

```swift
// 创建
var ptr = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)

//存
ptr.assumingMemoryBound(to: Int.self).pointee = 11
(ptr + 8).assumingMemoryBound(to: Double.self).pointee = 22.0

//取
print(unsafeBitCast(ptr, to: UnsafePointer<Int>.self).pointee)//11
print(unsafeBitCast(ptr + 8, to: UnsafePointer<Double>.self).pointee)//22.0

// 销毁
ptr.deallocate()
```



**unsafeBitCast** 是忽略数据类型的强制转换，不会因为数据类型的变化而改变原来的内存数据。类似于 C++ 中的 **reinterpret_cast**

```swift
class Person {}
var p = Person()
var ptr = unsafeBitCast(p, to: UnsafeRawPointer.self)
print(ptr)
```



## 字面量（Literal）

```swift
var age = 10
var isRed  = false
var name = "Jack"
```

上面代码中的10、false、"Jack"就是字面量。



**常见字面量的默认类型**

```swift
/// The default type for an otherwise-unconstrained integer literal.
public typealias IntegerLiteralType = Int

/// The default type for an otherwise-unconstrained floating point literal.
public typealias FloatLiteralType = Double

/// The default type for an otherwise-unconstrained Boolean literal.
public typealias BooleanLiteralType = Bool

/// The default type for an otherwise-unconstrained string literal.
public typealias StringLiteralType = String
```

可以通过 **typealias** 修改字面量的默认类型。

如下示例：

```swift
typealias FloatLiteralType = Float
typealias IntegerLiteralType = Int8
var age = 10 //Int8
var height = 1.68 //Float
```

Swift 自带的绝大部分类型，都支持直接通过字面量进行初始化：Bool、Int、Float、Double、String、 Array、Dictionary、Set、Optional 等。



**字面量协议**

Swift自带类型之所以能够通过字面量初始化，是因为它们遵守了对应的协议。

```swift
Bool：ExpressibleByBooleanLiteral
Int：ExpressibleByIntegerLiteral
Float、Double：ExpressibleByIntegerLiteral、ExpressibleByFloatLiteral
Dictionary：ExpressibleByDictionaryLiteral
String：ExpressibleByStringLiteral
Array、Set：ExpressibleByArrayLiteral
Optional：ExpressibleByNilLiteral
```



**字面量协议应用**

感受下面几个示例：

示例1

```swift
extension Int: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value ? 1 : 0
    }
}

var num: Int = true
print(num) // 1
```



示例2

```swift
class Student: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
    var name: String = ""
    var score: Double = 0
    required init(floatLiteral value: Double) {
        self.score = value
    }
    required init(integerLiteral value: Int) {
        self.score  = Double(value)
    }
    required init(stringLiteral value: String) {
        self.name = value
    }
    required init(extendedGraphemeClusterLiteral value: String) {
        self.name = value
    }
    required init(unicodeScalarLiteral value: String) {
        self.name = value
    }
    
    var description: String {
        "name = \(name), score = \(score)"
    }
}

var stu:Student = 90
print(stu) // name = , score = 90.0
stu = 98.5
print(stu) // name = , score = 98.5
stu = "Jack"
print(stu) // name = Jack, score = 0.0
```



示例3

```swift
struct Point {
    var x = 0.0, y = 0.0
}
extension Point: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    init(arrayLiteral elements: Double...) {
        guard elements.count > 0 else { return }
        self.x = elements[0]
        guard elements.count > 1 else { return }
        self.y = elements[1]
    }
    init(dictionaryLiteral elements: (String, Double)...) {
        for (k, v) in elements {
            if k == "x" { self.x = v }
            else if k == "y" { self.y = v }
        }
    }
}

var p: Point = [10.5, 20.5]
print(p) // Point(x: 10.5, y: 20.5)
p = ["x" : 11, "y" : 22]
print(p) // Point(x: 11.0, y: 22.0)
```



## 模式匹配（Pattern）

什么模式？

模式是用于匹配的规则，比如switch的case、捕捉catch、if\guard\while\for语句的条件等。

swift中的模式有：

- 通配符模式（Wildcard Pattern）；
- 标识符模式（Identifier Pattern）；
- 值绑定模式（Value-Binding Pattern）；
- 元组模式（Tuple Pattern）；
- 枚举Case模式（Enumeration Case Pattern）；
- 可选模式（Optional Pattern）；
- 类型转换模式（Type-Casting Pattern）；
- 表达式模式（Expression Pattern）。



**通配符模式（Wildcard Pattern）**

- `_ ` 匹配任何值。
- `_?`  匹配任何非nil值。

示例如下：

```swift
enum Life {
    case human(name: String, age: Int?)
    case animal(name: String, age: Int?)
}
func check(_ life: Life) {
    switch life {
    case .human(let name, _)://只要有名字即可, 忽略age
        print("human", name)
    case .animal(let name, _?):
        print("animal", name)//有名字，且年龄不为nil
    default:
        print("other")
    }
}

check(.human(name: "Rose", age: 20)) //human Rose
check(.human(name: "Jack", age: nil))//human Jack
check(.animal(name: "Dog", age: 5)) // animal Dog
check(.animal(name: "Cat", age: nil))//other
```



**标识符模式（Identifier Pattern）**

给对应的变量、常量名赋值。

示例如下：

```swift
var age = 10
let name = "Jack"
```



**值绑定模式（Value-Binding Pattern）**

如下示例：

```swift
let point = (3 ,2)
switch point {
case let(x, y):
    print("the point is at (\(x), \(y)).")
}
```



**元组模式（Tuple Pattern）**

如下示例：

示例1

```swift
let ponits = [(0,0), (1,0), (2,0)]
for (x, _) in points {
    print(x)
}
```

示例2

```swift
var scores = ["jack": 98, "rose": 100, "kate": 86]
for (name, score) in scores {
    print(name, score)
}
```

示例3

```swift
let name: String? = "jack"
let age = 18
let info: Any = [1 ,2]
switch (name, age, info) {
case(_?, _, _ as String):
    print("case")
default:
    print("default")
}
//default
```



**枚举Case模式（Enumeration Case Pattern）**

**if** **case** 语句等价于只有1个case的switch语句。

如下示例：

示例1

```swift
let age = 2

//原来的写法
if age >=0 && age <= 9 {
    print("[0, 9]")
}

//枚举Case模式的写法1：用在if语句中
if case 0...9 = age {
    print("[0, 9]")
}

//枚举Case模式的写法2：用在guard语句中
guard case 0...9 = age else { return }
print("[0, 9]")

//上面的几种写法等价于下面的写法:
switch age {
case 0...9: print("[0, 9]")
default: break
}
```

示例2

```swift
let ages: [Int?] = [2, 3, nil, 5]
for case nil in ages {// 匹配nil
    print("有nil值")
    break
}//有nil值
```

示例3

```swift
let points = [(1, 0), (2, 1), (3, 0)]
for case let (x, 0) in points { // 匹配第2个元素为0的项，并将第1和元素绑定到x上
    print(x)
}//1 3
```



**可选模式（Optional Pattern）**

如下示例：

示例1

```swift
let age: Int? = 42
if case .some(let x) = age { print(x) } // 匹配age，当age不为nil时，绑定到x上；符合条件则打印x
if case let x? = age { print(x) } // 匹配age，当age不为nil时，绑定到x上；符合条件则打印x
```

示例2

```swift
let ages: [Int?] = [nil, 2, 3, nil, 5]
for case let age? in ages { // 匹配age，当age不为nil时，绑定到age上；符合条件则进入循环并打印age
    print(age)
}// 2 3 5
```

示例3

```swift
let ages: [Int?] = [nil, 2, 3, nil, 5]
for item in ages {
    if let age = item { // 当item不为nil时，绑定到age上；符合条件则进入if并打印age
            print(age)

    }
}// 2 3 5 跟上面的效果是等价的
```

示例4

```swift
func check(_ num: Int?) {
    switch num {
    case 2?: print("2")
    case 4?: print("4")
    case 6?: print("6")
    case _?: print("other")// 如果不为nil，则打印other
    case _: print("nil")
}
```



**类型转换模式（Type-Casting Pattern）**

如下示例：

示例1

```swift
let num: Any = 6
switch num {
case is Int:
    //编译器依然认为num是Any类型
    print("is Int", num)
default: break
}
```

示例2

```swift
class Animal {
    func eat() {
        print(type(of: self), "eat")
    }
}
class Dog: Animal {
    func run() {
        print(type(of: self), "run")
    }
}
class Cat: Animal {
    func jump() {
        print(type(of: self), "jump")
    }
}

func check(_ animal: Animal) {
    switch animal {
    case let dog as Dog:
        dog.eat()
        dog.run()
    case is Cat:
        animal.eat()
    default: break
    }
}

//Dog eat
//Dog run
check(Dog())
//Cat eat
check(Cat())
```



**表达式模式（Expression Pattern）**

表达式模式用在case中。

如下示例：

```swift
let point = (1, 2)
switch point {
case (0, 0):
    print("(0, 0) is at the origin")
case (-2...2, -2...2):
    print("(\(point.0), \(point.1)) is near the origin")
default:
    print("the point is at (\(point.0), \(point.1))")
}
```



**自定义表达式模式**

可以通重载运算符 ~= ， 自定义表达式模式的匹配规则。

如下示例：

```swift
func isEven(_ i: Int) -> Bool {
    i % 2 == 0
}
func isOdd(_ i: Int) -> Bool {
    i % 2 != 0
}
extension Int {
    static func ~= (pattern: (Int) -> Bool, value: Int) -> Bool {
        pattern(value)
    }
}

var age = 9
switch age {
case isEven:
    print("偶数")
case isOdd:
    print("奇数")
default: print("其他")
}
```



**where**

可以使用where为模式m匹配模式匹配增加匹配条件。

如下示例；

```swift
var data = (10, "jack")
switch data {
case let (age, _) where age > 10:
    print(data.1, "age > 10")
case let (age, _) where age > 0:
    print(data.1, "age > 0")
default: break
}
```


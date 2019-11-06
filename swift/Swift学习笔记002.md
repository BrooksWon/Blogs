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


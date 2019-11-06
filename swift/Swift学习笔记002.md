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



**逃逸闭包 @escaping**

非逃逸闭包、逃逸闭包，一般都是当做参数传递给函数。

非逃逸闭包：闭包调用发生在函数结束前，闭包调用在函数作用域内。

逃逸闭包：闭包有可能在函数结束后调用，闭包调用逃离了函数的作用域，需要通过 **@escaping **声明。

如下示例：

```
import Dispatch
typealias Fn = () -> ()

// fn 是非逃逸闭包
func test1(_ fn: Fn) {
    fn()
}

// fn 是逃逸闭包
var gFn: Fn?
func test2(_ fn: @escaping Fn) {
    gFn = fn
}

// fn 是逃逸闭包
func test3(_ fn: @escaping Fn)  {
    DispatchQueue.global().async {
        fn()
    }
}
```

再来一个例子:

```swift
import Dispatch
typealias Fn = () -> ()
class Person {
    var fn: Fn
    
    //fn 是逃逸闭包
    init(fn: @escaping Fn) {
        self.fn = fn
    }
    
    func run() {
        //
        //它用到了实例成员(属性、方法), 编译器会强制要求明确写出self.
        DispatchQueue.global().async {
            self.fn()
        }
    }
}
```



**逃逸闭包的注意点**

逃逸闭包不可以捕获inout参数。




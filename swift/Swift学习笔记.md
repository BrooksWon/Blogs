# Swift学习笔记

**基于Swift5.1的学习笔记**

-  Swift完全开源: https://github.com/apple/swift，主要采用C++编写  

![](/Users/Brooks/blog/blogs/swift/Snip20191031_11.png)



**基于LLVM的程序编译流程**

![](https://github.com/BrooksWon/Blogs/blob/master/swift/%E7%BC%96%E8%AF%91%E8%BF%87%E7%A8%8B.png)

**Swift程序编译流程**

![](https://github.com/BrooksWon/Blogs/blob/master/swift/Swift%E8%AF%AD%E8%A8%80%E7%BC%96%E8%AF%91%E8%BF%87%E7%A8%8B.png)

*参考：https://swift.org/compiler-stdlib*

**swiftc** 作为swift的编译前端存放在Xcode内部（Contents/Developer/Toolschains/XcodeDefault.xctoolchain/user/bin）

swiftc 的一些操作：

- 生成语法树：swiftc -dump-ast main.swift
- 生成最简洁的SIL代码：swiftc -emit-sil main.swift
- 生成LLVM IR代码：swiftc -emit-ir main.swift -o main.ll
- 生成汇编代码：swiftc -emit-assembly main.swift -o main.s



醒木连拍两下：对汇编代码进行分析，可以掌握编程语言的本质。

插播：----------------------------------------------

作为iOS开发工程师，最主要的汇编语言是：

- AT&T汇编 —> iOS模拟器
- ARM汇编 —> iOS真机

常用汇编指令：

| 项目        | AT&T                                                         | 说明                                                         |
| ----------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 寄存器命名  | %rax                                                         |                                                              |
| 操作数顺序  | movq %rax, %rdx                                              | 将**rax**的值赋值给**rdx**                                   |
| 常数\立即数 | movq $3, %rax<br />movq 美元符号0x10, %rax                   | 将**3**赋值给**rax**<br />将**0x10**赋值给**rax**            |
| 内存赋值    | movq $0xa, 0x1ff7(%rip)                                      | 将**0xa**赋值给地址为**rip + 0x1ff7**的内存空间              |
| 取内存地址  | leap -0x18(%rbp), %rax                                       | 将**rbp - 0x18**这个地址值赋值给**rax**                      |
| jmp 指令    | jmp *%rdx<br />jmp 0x4001002<br />jmp *(%rax)                | **call** 和 **jmp**写类似                                    |
| 操作数长度  | movl %eax, %edx<br />movb $0x10, %al<br />leaw 0x10(%dx), %ax | **b** = byte（8-bit）<br />**s** = shot（16-bit integer or 32-bit floating point）<br />**w** = word（16-bit）<br />**l** = long（32-bit integer or 64-bit floating point）<br />**q** = quad（64-bit）<br />**t** = ten bytes（80-bit floating point） |

寄存器：

- 有16个常用寄存器
  - rax、rbx、rcx、rdx、rsi、rdi、rbp、rsp
  - r8、r9、r10、r11、r12、r13、r14、r15
- 寄存器用途
  - rax、rdx常作为函数返回值使用
  - rdi、rsi、rdx、rcx、r8、r9等寄存器常用于存放函数参数
  - rsp、rbp用于栈操作
  - rip作为指令指针
    - 存储着cpu下一条要执行的指令的地址
    - 一旦cpu读取一条指令，rip会自动指向下一条指令（存储下一条指令）



规律：

- 内存地址格式为：0x4bdc (%rip)，一般是全局变量，全局区（数据段）
- 内存地址格式为：-0x78 (%rbp)，一般是局部变量，栈空间
- 内存地址格式为：0x10 (%rax)，一般堆空间



lldb常用指令：

- 读取寄存器的值：
  - register read/格式
    - 如：register read/x
- 修改寄存器的值：
  - register write 寄存器名称 数值
    - 如：register write rax 0
- 读取内存中的值：
  - x/数量-格式-字节大小 内存地址
    - 如：x/3xw 0x0000010
- 修改内存中的值:
  - memory write 内存地址 数值
    - 如：memory write 0x0000010 10
- 格式:
  - x是16进制，f是浮点，d是十进制
- 字节大小：
  - b - byte 1字节
  - h - half word 2字节
  - w - word 4字节
  - g - giant word 8字节
- expression 表达式，可以简写：expr
  - 如：expression $rax = 1
- po 表达式
- print 表达式
- 单步运行，把子函数当做整体一步执行（源码级别）
  - thread step-over、next、n
- 单步运行，遇到子函数会进入子函数（源码级别）
  - thread step-in、step、s
- 单步运行，把子函数当做整体一步执行（汇编级别）
  - thread step-inst-over、nexti、ni
- 单步运行，遇到子函数会进入子函数（汇编级别）
  - thread step-inst、stepi、si
- 直接执行完当前函数的所有代码，返回到上一个函数（遇到断点会卡住）
  - thread step-out、finish

插播完毕-----------------------------------------

**学习过程的思维导图如下**：

![](/Users/Brooks/blog/blogs/swift/Swift学习笔记.png)

# 1 基础语法

- swift中一句代码尾部可以省略分号，多句代码写到同一行时必须用分号隔开
- 用**var**定义变量，**let**定义常量，编译器能自动推断出变量/常量的类型

**常量**：

- 常量只能被赋值一次，不要求在编译时期确定，但是使用之前必须被赋值一次
- 常量、变量在初始化之前，都不能使用

```
let age: Int
let name: String

print(age)//Constant 'age' used before being initialized
print(name)//Constant 'age' used before being initialized
```



**swift中常用数据类型**

![](https://github.com/BrooksWon/Blogs/blob/master/swift/swift%E5%B8%B8%E8%A7%81%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B.png)

- 整数类型一般情况下直接使用**Int**，在32bit平台、Int等价于Int32；在64bit平台、Int等价于Int64。
- 浮点类型：Float，32位，精度只有6位；Double，64位，精度至少15位。



## 流程控制

**if-self**

- if 后面的条件可以省略小括号，且条件只能是 **Bool** 类型

**while**

- repeat-while 相当于C语言中的 do-while

**for-in**

- 这个没啥可说的~

**区间类型**

- 闭区间： ClosedRange
- 半开区间：Range
- 局部穿透区间：PartialRangeThrough

```swift
//可以使用for-in打印区间内的值
for i in range1 {
    print(i)
}

//检查range3中是否包含5，并打印
print(range3.contains(5) ? 5 : 0)
```



**switch**

- case、default 后面不能写大括号{}。
- 默认可以不写 break，并不会贯穿到后面的条件。
- 可以使用 **fallthrough** 实现贯穿效果。
- switch必须要保证能处理所有情况；如果能保证处理所有情况，也可以不必使用default。
- case、default 后面至少要有一条语句，如果不想做任何事、加个 break 即可。

```swift
var number = 1.5

switch number {
case 1:
    break
case 1.5:
    print("1.5")
    fallthrough
case 2:
    print("2")
default:
    print("other")
}
```

- switch 也支持Character、String类型。
- 可以使用区间匹配、元组匹配。关于 case 匹配问题，属于模式匹配（Pattern Matching）的范畴，后面学到了再说~
- 值绑定，值绑定时可以用 let， 也可以用 var。

```swift
let point = (0, 2)

switch point {
case let (x, 0):
    print("元组的第一个元素是\(x), 第二个元素是0")
case (0, var y):
    let y2 = y
    y += 5
    print("元组的第一个元素是0, 第二个元素\(y2)加5等于\(y)")
case (let x, let y):
    print("元组的第一个元素是\(x), 第二个元素是\(y)")
}
```



**where**

- switch、for-in 中可以使用 where 条件语句。

```swift
let point = (1, -1)

switch point {
case let (x, y) where x == y:
    print("元组中俩元素相等")
case let (x, y) where x+y == 0:
    print("元组中俩元素的和为0")
default:
    print("元组的第一个元素是\(point.0), 第二个元素是\(point.1)")
}//元组中俩元素的和为0
```

```swift
// 将所有正数加起来
var numbers = [1, -2, 3, -5, 4]
var sum = 0
for num in numbers where num > 0 { // 使用where来过滤num, 正数才能进循环体参与计算
    sum += num
}
print(sum)//8

// 后面会学到一个更简单的方法解决这个问题, 所以越往后面越有意思，加油哦！
let sum2 = (numbers.filter { $0 > 0 }).reduce(0) { $0 + $1}
print(sum2)//8
```



**标签语句**

- 这个没什么好说的，直接来代码体会下即可~

```swift
outer: for i in 1...4 {
    for k in 1...4 {
        if k == 3 {
            continue outer
        }
        if i == 3 {
            break outer
        }
        print("i == \(i), k == \(k)")
    }
}
```



## 函数

**函数的声明**

格式：func 函数名字 (参数列表) -> 返回值 {函数体}

如：

```swift
func doSomething(_ number: Int) -> Int {
    //todo
    return 0
}
```

- 形参默认是let，也只能是let。
- 无返回值时，写作 Void 或者 空元组()  或者什么都不写。
- 如果整个函数体是一个单一表达式，那么函数会隐式返回这个表达式，因此可以省略return关键字。
- 可以使用元组实现多返回值。
- 函数文档注释，参考：https://swift.org/documentation/api-design-guidelines/
- 可以自定义参数标签，或者是用下划线 `_` 省略参数标签。
- 参数可以有默认值，因此在实际调用时可以选择不给带有参数默认值的参数传递的实参。
- swift允许使用可变参数 `...` ，但是一个函数最多只能有一个可变参数，且紧跟在可变参数后面的参数不能省略参数标签。

下面来看一下Swift自带的print函数：

```swift
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single
///     space (`" "`).
///   - terminator: The string to print after all items have been printed. The
///     default is a newline (`"\n"`).
public func print(_ items: Any..., separator: String = " ", terminator: String = "\n")
```

第一参数即：可变参数。因此在调用时可以传递任意个参数。

第二个参数即：第一个可变参数在打印时，用何种分隔符分隔，函数默认是空格分隔。调用时不传实参，则使用参数默认值。

第三个参数即：函数即将调用完毕时、将用何种符合结束，函数默认使用回车符 `\n`。

演示下：

```swift
//仅传可变参数，其余使用默认参数值
print(1,2,3,4)//1 2 3 4

//传递所有参数，且使用下划线作为可变参数的分割符，打印结束时换2行
print(1,2,3,4, separator: "_", terminator: "\n\n")
//1_2_3_4
//
```

- 可以用 `inout`定义一个输入输出参数：可以在函数内部修改外部实参的值
  - 可变参数不能标记为 inout；
  - inout 参数不能有默认值；
  - inout 参数只能传入可以被多次赋值的实参；
  - inout 参数的本质是地址传递（引用传递）。

**函数重载**

规则：函数名相同的前提下：参数个数不同 、参数类型不同、参数标签不同，满足任何一个 or 多个都可以称作函数重载。(**注意：函数重载和函数的返回类型无关**)

- 默认参数值和函数重载一起使用产生二义性时，编译器并不会报错。
- 可变参数、省略参数标签、函数重载一起使用产生二义性时，编译器有可能会报错。

**内联函数**

- 如果开启了编译器优化（Release模式默认会开启优化），编译器会自动将某些函数变成内联函数。
  - 优化：将函数调用展开成函数体。
- 哪些函数不会被自动内联？
  - 函数体比较长的；
  - 包含递归调用的；
  - 包含动态派发的；
  - .....
- 主动使用 `@inline` 干预：

```swift
// 永远不会被内联（即使开启了编译器优化）
@inline(never) func test() {
    print("test")
}


// 开启编译器优化后，即使代码很长，也会被内联（递归调用、动态派发函数除外）
@inline(__always) func test() {
    print("test")
}
```

在 Release 模式下，编译器已经开启优化，会自动决定哪些函数需要内联，因此没必要使用 @inline。



**函数类型（Function Type）**

每一个函数都是有类型的，函数类型由：**形式参数类型**、**返回值类型**组成。

- 函数类型可以作为函数参数、也可以作为函数函数返回值。
- 返回值是函数类型的函数，叫做高阶函数（Higher-Oder Function）。



**typealias**

用来给类型起别名的。

例如：

```swift
typealias Byte = Int8
let num: Byte = 2
```



**嵌套函数**

将函数定义在函数内部称作嵌套函数。



## 枚举

**关联值（Associated Values）**

有时将**枚举的成员值**跟**其他类型的值**关联存储在一起，会非常有用。

如下例子：

```swift
enum Score {
    case points(Int)
    case grade(Character)
}
var score = Score.points(96)
score = .grade("A")
switch score {
case let .points(i):
    print(i)
case let .grade(i):
    print(i)
}// A
```



**原始值**

枚举成员可以使用**相同类型**的默认值预先对应，这个默认值叫做：原始值。

注意：原始值不占用枚举变量的内存

- 隐式原始值（Implicitly Assigned Raw Values）
  -  如果枚举的原始类型是：Int、String，Swift会自动分配原始值。

**递归枚举**

递归枚举就是在该枚举中递归使用当前枚举类型。

**MemoryLayout**

可以使用MemoryLayout获取数类型占用的内存大小

```swift
enum Grade: String {
    case good = "A"
    case bad = "B"
}

print(MemoryLayout<Grade>.stride)//1, 分配占用的空间大小
print(MemoryLayout<Grade>.size)//1，实际用到的空间大小
print(MemoryLayout<Grade>.alignment)//1，对齐参数
```



**窥探枚举的内存结构**

第1中情况：普通枚举。代码如下：

```swift
enum Grade {
    case good
    case bad
}

var result = Grade.bad
print(MemoryLayout<Grade>.size)//1，实际用到的空间大小
print(result)
```

通过断点、查看result的内存布局，如下图所示：



![](/Users/Brooks/blog/blogs/swift/Snip20191103_8.png)

显然，**result 只占用1个字节大小，且内存中存储的就是枚举case对应的值。因为只有1个字节，所以最多能存储256种case**。



第2中情况：带有原始值的枚举。代码如下：

```swift
enum Grade: String {
    case good = "优"
    case bad = "差"
}

var result = Grade.bad
print(MemoryLayout<Grade>.size)//1，实际用到的空间大小
print(result)
```

通过断点、查看result的内存布局，如下图所示：



![](/Users/Brooks/blog/blogs/swift/Snip20191103_10.png)

看图可知，result 只占用1个字节大小，且内存中存储的就是枚举case对应的值。因为只有1个字节，所以最多能存储256种case。和 **第1种情况的结果一样**。



第3中情况：带有关联值的枚举。代码如下：

```swift
enum TestEnum {
    case test1(Int, Int, Int)
    case test2(Int, Int)
    case test3(String)
    case test4(Bool)
    case test5
}

var result = TestEnum.test1(1, 2, 3)
print(MemoryLayout<TestEnum>.size)//25，实际用到的空间大小
print(result)
```

通过断点、查看result的内存布局，如下图所示：



![](/Users/Brooks/blog/blogs/swift/Snip20191103_15_1.png)

从图中可以看出，result 占用25个字节大小，内存中前24个字节存储的就是枚举test1关联的值（1、2、3），最后1个字节存储的是枚举的第几个case（示例代码中是test1、因此该处存储的值为0）、因为只用1个字节存储case的情况种类，所以最多能存储256种case。



接下来、继续看TestEnum的其他几种case下对用的内存布局

test2 时—>

![](/Users/Brooks/blog/blogs/swift/Snip20191103_16.png)

从图中可以看出，result 占用25个字节大小，内存中前16个字节存储的就是枚举test2关联的值（5、6），第25个字节存储的是枚举的第几个case（示例代码中是test2、因此该处存储的值为1）、因为只用1个字节存储case的情况种类，所以最多能存储256种case。



test3 时—>

![img](/Users/Brooks/blog/blogs/swift/Snip20191103_17.png)

从图中可以看出，result 占用25个字节大小，内存中前2个字节存储的就是枚举test3关联的值（AB），第25个字节存储的是枚举的第几个case（示例代码中是test3、因此该处存储的值为2）、因为只用1个字节存储case的情况种类，所以最多能存储256种case。



test4 时—>

![img](/Users/Brooks/blog/blogs/swift/Snip20191103_18.png)

从图中可以看出，result 占用25个字节大小，内存中第1个字节存储的就是枚举test4关联的值（1，Bool值为true时，内存存储的是1），第25个字节存储的是枚举的第几个case（示例代码中是test4、因此该处存储的值为3）、因为只用1个字节存储case的情况种类，所以最多能存储256种case。



test5 时—>

![img](/Users/Brooks/blog/blogs/swift/Snip20191103_19.png)

从图中可以看出，result 占用25个字节大小，因为test5没有关联值、所以前24个字节空着，第25个字节存储的是枚举的第几个case（示例代码中是test5、因此该处存储的值为4）、因为只用1个字节存储case的情况种类，所以最多能存储256种case。



综上，可以总结出规律：带有关联值的枚举类型的内存布局是：**1个字节存储成员值，N个字节存储关联值（N取占用内存量最大的关联值）**。



所以，以上3种类型的枚举总结如下：

- **普通枚举** 和 **带有原始值的枚举**的内存布局是一样的，**都是分配1个字节的空间、存储枚举成员的case种类（最多支持256种）**。
- **带有关联值的枚举**的内存布局：上面说过了。



## 可选项（Optional）

可选项，一般也叫可选类型，它允许将值设置为nil。在类型，名称后面加个问号？来定义一个可选项。

**强制解包（Forced Unwrapping）**

可选项是对其他类型的一层包装，可以将它理解为一个盒子。

- 如果为nil，那么它是个空盒子；
- 如果不为nil，那么盒子里装的是：被包装类型的数据。

```swift
var age: Int? // 默认就是nil
age = 10
age = nil
```

- 如果要从可选项中取出被包装的数据（将盒子中的东西取出来），需要使用**感叹号！**进行强制解包。

```swift
var age: Int? = 10
print(age!)//10
```

- 如果对值为nil的可选项（空盒子）进行强制解包，将会产生运行时错误。

```swift
var age: Int? // 默认就是nil
print(age!)//atal error: Unexpectedly found nil while unwrapping an Optional value
```



**可选项绑定（Optional Binding）**

可以使用**可选项绑定**来判断可选项是否包含值。如果包含就自动解包，并把值赋给一个临时的常量let或者变量var，并返回true；否则返回false。

```swift
if let number = Int("123") {//可选项绑定
    print("字符串转换成功", number)
} else {
    print("字符串转换失败")
}
```

还可以连续使用多个可选项绑定，使用逗号（,）分割即可，如下：

```swift
if let first = Int("5"),//可选项绑定
    let second = Int("21"),//可选项绑定
    first < second && second < 100 {
    print("\(first) < \(second) < 100")
}
```

如果在while循环中使用可选项绑定，当自动解包失败时，**就会立即停止遍历**。

```swift
//遍历数组，将遇到的正数都加起来，如果遇到负数或者非数字，立即停止遍历
let strs = ["1", "-2", "3", "abc"]
var index = 0
var sum = 0

while let num = Int(strs[index]), num > 0 {//当遍历到-2时，一看是负数，条件不成立、立即停止遍历、挑出循环
    print(num)
    sum += num
    index += 1
}
print(sum)//1
```



**空合并运算符 ?? （Nil-Coalescing Optional）**

如：`a  ??  b` 这个；要求：a 必须是可选项，b 是不是可选项都行，但是b跟a的数据存储类型必须相同。

- 如果a不为nil，且此时b不是可选项、则a自动解包后返回；反之、则返回a。
- 如果a为nil，就返回b。

说白了，最终返回的类型是否为可选项、取决于 b 是否为可选项；**换句话说就是：返回类型和b的类型一致**。



**guard 语句**

语法：

```swift
guard 条件 else {
    //todo
    //退出当前作用域
}
```

- 当guard语句的条件为false时，就会执行大括号里面的代码；反之、就会跳过guard语句。
- guard语句特别适合用来“提前退出”
- 当使用guard语句进行可选项绑定时，绑定的常量let、变量var也能在外层作用域中使用。

```swift
func login(_ info: [String: String]) {
    guard let username = info["username"] else {
        print("请输入用户名")
        return
    }
    
    guard let password = info["password"] else {
        print("请输入密码")
        return
    }
    print(username, password)
}
```



**隐式解包（Implicitly Unwrapping Optional）**

格式：在类型后面加个感叹号！定义一个隐式解包的可选项。

- 在某种情况下，可选项一旦被设定值之后，就一直会拥有值，在这种情况下可以去掉检查，也不必每次访问的时候都进行解包，因为它能确定每次访问的时候都有值。

```swift
let n1: Int! = 10
print(n1+6)//16
```



**多重可选项**

多重可选项就是类型后面有多个问号？这就意味着：数据被多个层层包裹着，1个问号对应一个盒子。

如：

```swift
var num1: Int? = 10
var num2: Int?? = 20
var num3: Int??? = 30
```

可以使用lldb指令 `frame variable -R` 或者 `fr v -R`查看区别，如下：

```
(lldb) fr v -R num1
(Swift.Optional<Swift.Int>) num1 = some {
  some = {//1层盒子
    _value = 10
  }
}


(lldb) fr v -R num2
(Swift.Optional<Swift.Optional<Swift.Int>>) num2 = some {
  some = some {//2层盒子
    some = {//1层盒子
      _value = 20
    }
  }
}


(lldb) fr v -R num3
(Swift.Optional<Swift.Optional<Swift.Int?>>) num3 = some {
  some = some {//3层盒子
    some = some {//2层盒子
      some = {//1层盒子
        _value = 30
      }
    }
  }
}
(lldb) 
```

对应的解包拆盒子即可：

```swift
print( num1! )//10
print( num2!! )//20
print( num3!!! )//30
```



## 结构体和类

### 结构体

在Swift标准库中，绝大多数的公开类型都是结构体，而枚举和类只占很小一部分。比如：Bool、Int、Double、String、Array、Dictionary、Set等常见类型都是结构体。

所有的结构体都有一个编译器自动生成的初始化器initializer（初始化方法/构造器/构造方法）。

**结构体的初始化器**

编译器会根据情况，可能回味结构体生成多个初始化器，宗旨是：**保证所有成员都有初始值**。

**自定义初始化器**

一旦定义结构体时自定义了初始化器，编译器就不会再帮它自动生成其他初始化器。

**窥探初始化器的本质**

以下两段代码完全等效：

```swift
struct Point {
    var x: Int = 0
    var y: Int = 0
}

var p = Point()
```

```swift
struct Point {
    var x: Int
    var y: Int
    
    init() {
        x = 0
        y = 0
    }
}

var p = Point()
```

怎么看出来的呢？我们可以看一下两段源码的反汇编代码。如下：

![](/Users/Brooks/blog/blogs/swift/init汇编1.png)



注意！上面两段源码运行时都会走到上图红色标注区，也就意味着：都调用了`init()`方法。

下面进入`init()` 调用内部：

![](/Users/Brooks/blog/blogs/swift/init汇编2.png)



很明显，在 `init()` 方法内部为 x、y分别赋值0 。

总结：上面两段代码都会调用init方法、并为存储属性设置初始值。



**结构体内存结构**

```swift
struct Point {
    var x: Int = 0
    var y: Int = 0
    var origin = false
}
print(MemoryLayout<Point>.size)//17，实际占用内存为：两个Int 和 一个Bool， 8+8+1=17个字节
print(MemoryLayout<Point>.stride)//24，由于内存对齐方式是8个字节，因此系统分配空间为：8*3 = 24个字节
print(MemoryLayout<Point>.alignment)//8，内存对齐，8个字节
```



### 类

类的定义和结构体类似，但编译器并没有为类自动生成可以传入成员值的初始化器。

**类的初始化器**

- 如果类的所有成员都在定义的时候指定了初始值，编译器会为类生成无参的初始化器。
  - 成员的初始化实在这个初始化其中还完成的。

```swift
class Point {
    var x: Int = 0
    var y: Int = 0
}
let p = Point()//编译器会为Point类生成无参的初始化器
```

上面的代码和下面是等效的：

```swift
class Point {
    var x: Int
    var y: Int
    
    init() {
        x = 0
        y = 0
    }
}
let p = Point()
```



**类和结构体的本质区别**

- 结构体是值类型（枚举也是值类型），类是引用类型（指针类型）。

根据下面代码分析下内存情况（64bit环境下）：

```
struct Point {
    var x = 3
    var y = 4
}

class Size {
    var width = 1
    var height = 2
}

func test() {
    let size = Size()
    let p = Point()
}
```

![](/Users/Brooks/blog/blogs/swift/Snip20191101_9.png)



**值类型**

值类型赋给var、let或者给函数传参，是直接将所有内容拷贝一份；类似于对文件进行copy、paste操作，产生了全新的文件副本。属于深拷贝（deep copy）。

- 值类型的赋值操作：
  - 在Swift标准库中，为了提升性能，String、Array、Dictionary、Set采取了 Copy on Write 的技术。
    - 比如：仅当有 “写” 操作时，才会真正执行拷贝操作。
    - 对于标准库值类型的赋值操作，Swift能确保最佳性能。
  - 建议：不需要修改的，尽量定义成let。



**引用类型**

引用赋值给var、let或者给函数传参，是将内存地址拷贝一份；类似于制作一个文件的快捷方式（链接），指向的是同一个文件。属于浅拷贝（shallow copy）。



**对象的堆空间申请过程**

- 在Swift中，创建类的实例对象，要向对空间申请内存，大概流程如下：
  - **Class.__allocating_init()**
  - libswiftCore.dylib: **_swift_allocObject**
  - libswiftCore.dylib: **swift_slowAlloc**
  - libswiftCore.dylib: **malloc**
- 在 Mac、iOS中的 **malloc** 函数分配的内存大小总是 16 的倍数。
- 通过 `class_getInstanceSize` 可以得知类的对象至少需要占用多少内存

```swift
class Size {
    var width = 1
    var height = 2
}

let size = Size()
print(class_getInstanceSize(type(of: size)))//32
print(class_getInstanceSize(Size.self))//32
```



**引用类型的赋值操作**

根据下面代码的执行结果、窥探类对象的内存布局

```
class Size {
    var width = 0
    var height = 0
    
    init(w: Int, h: Int) {
        width = w;
        height = h
    }
}

var size = Size(w: 1, h: 2)
print(UnsafePointer(&size))//0x100002388

size = Size(w: 3, h: 4)
print(UnsafePointer(&size))//0x100002388
```

结果显示：2次打印结果都一样，说明变量 size 的内存地址没变、说白了就是指向同一块存储空间。

那么，**这块存储空间里又存储着什么呢？**

接下来、使用上面打印出的地址 `0x100002388` 去 *Xcode -> Debug ->Debug Workflow -> View Memory* 里一探究竟，如下：

可以猜测下这块内存里应该存着和Size对象相关的东西，**到底是什么呢？会不会是Size对象的内存地址呢？**我们验证下猜测、读取这块内存里前8个字节，如下图红色标注区。

![](/Users/Brooks/blog/blogs/swift/Snip20191101_91.png)



当然，也可以使用命令 `x/1gx`读取前8个字节，如下：

![](/Users/Brooks/blog/blogs/swift/Snip20191101_11.png)

接着、去 View Memory 查看下这个地址对应的内存空间里存储着什么东东？

![](/Users/Brooks/blog/blogs/swift/Snip20191101_13.png)



**1** 存储size对象的类型信息；

**2** 存储引用计数；

**3** 存储成员变量的值，即width和height的值。



总结：即使给size变量重新设置size对象，size变量本身的内存地址也不会改变，但是它的内存地址存储的**size对象的内存地址**会变化。看下图、一眼明了

![](/Users/Brooks/blog/blogs/swift/Snip20191101_14.png)



**嵌套类型**

太简单,没什么好说的~



**枚举、结构体、类都可以定义方法**

一般把定义在枚举、结构体、类内部的函数，叫做方法。

方法不占用对象内存，方法存放在代码段。



## 闭包

### 闭包表达式（Closure Expression）

在Swift中，可以使用 func 定义一个函数，也可以通过闭包表达式定义一个函数。

闭包表达式格式：

```swift
{
	(参数列表) -> 返回值类型 in
	函数体代码
}
```



### 闭包（Closure）

一个函数和它所捕获的变量/常量环境组合起来，成为闭包。

- 一般指定义在函数内部的函数；
- 一般它捕获的是外层函数的局部变量/常量。



其实，可以把闭包想想成一个类的实例对象，因此：

- 内存在堆空间；
- 捕获的局部变量/常量就是对象的成员（存储属性）；
- 组成闭包的函数就是类内部定义的方法。



**尾随闭包**

尾随闭包是一个被书写在函数调用括号外面（后面）的闭包表达式。

- 如果将一个很长的闭包表达式作为函数的最后一个实参，使用尾随闭包可以增强函数的可读性。
- 如果闭包表达式是函数的唯一实参，而且使用了尾随闭包的语法，那就不需要在函数后面写圆括号。



**自动闭包**

- @autoclosure 会自动将 **参数** 封装成**{ 参数 }**；
- @autoclosure 只支持 `（）-> T`格式的参数；
- @autoclosure 并非只支持最后1个参数；
- 有@autoclosure ，无@autoclosure，构成了函数重载；
- 空合并运算符 **??** 使用了@autoclosure 技术。

为了避免与期望冲突，使用了 @autoclosure 的地方最好明确注明清楚：这个值未必会执行。



## 属性

Swift中跟实例相关的属性可以分为两大类：

- 存储属性（Stored Property）
  - 类似于成员变量这个概念；
  - 存储于实例的内存中；
  - 结构体、类可以定义存储属性；
  - 枚举不可以定义存储属性；
- 计算属性（Computed Property）
  - 本质就是方法（函数）；
  - 不占用实例的内存；
  - 枚举、结构体、类都可以定义计算属性。

**存储属性**

关于存储属性，Swift有个明确的规定：在创建**类**或者**结构体**的实例属性时，必须为所有的存储属性设置一个合适的初始值。

- 可以在初始化器里为存储属性设置一个初始值；
- 可以分配一个默认的属性值作为属性定义的一部分。



**计算属性**

- set 传入的新值默认叫做 newValue，也可以自定义。
- 定义计算属性只能用 var， 不能用let；因为let代表常量、值是一成不变的，而计算属性的值是可能发生变化的（即使是只读计算属性）。
- 只读计算属性：只有get、没有set。

```swift
struct Circle {
    var radius: Double
    var diameter: Double {
        get {//计算属性的getter
            radius * 2
        }
        set {//计算属性的setter
            radius = newValue / 2
        }
    }
}
```

**枚举 rawValue 原理**

枚举原始值rawValue的本质是：只读计算属性。

如下：

```swift
enum TestEnum: Int {
    case test1 = 1, test2 = 2, test3 = 3
    var rawValue: Int {
        switch self {
        case .test1:
            return 10
        case .test2:
            return 20
        case .test3:
            return 30
        }
    }
}

print(TestEnum.test2.rawValue)//20
```



**延迟存储属性（Lazy Stored Property）**

使用 lazy 可以定义一个延迟存储属性，在第一次用到属性的时候才会进行初始化。

- lazy 属性必须是 var，不能是 let；因为 let 必须在实例的初始化方法完成之前就拥有值。
- 如果多条线程同时第一次访问 lazy 属性，无法保证属性只被初始化 1 次。

延迟存储属性注意点：**挡结构体包含一个延迟存储属性时，只有var才能访问延迟存储属性；因为延迟存储属性初始化时需要改变结构体的内存。**

```swift
struct Point {
    var x = 0
    var y = 0
    lazy var z = 0//延迟存储属性
}
let p = Point()
print(p.z)//Cannot use mutating getter on immutable value: 'p' is a 'let' constant
```

**属性观察器**

可以为**非 lazy 的var存储属性**设置属性观察器。

- willSet 会传递新值，默认叫 newValue；
- didSet会传递旧值，默认叫 oldValue；

注意：**在初始化器中设置属性值不会触发willSet和didSet，在属性定义时设置初始值也不会触发willSet和didSet**。

```swift
struct Circle {
    var radius: Double {
        willSet {
            print("willSet", newValue)
        }
        didSet {
            print("didSet", oldValue, radius)
        }
    }
    
    init() {
        radius = 2.0
        print("Circle init")
    }
}

// Circle init
var c = Circle()

// willSet 10.5
// didSet 2.0 10.5
c.radius = 10.5

print(c.radius)// 10.5
```



**全局变量、局部变量**

属性观察器、计算属性的功能，同样可以作用在全局变量、局部变量身上。



**inout的本质**

inout 的本质就是引用传递（地址传递）。



**类型属性（Type Property）**

严格来说，属性可以分为：**实例属性** 和 **类型属性**。

- 实例属性（Instance Property）：只能通过实例去访问。
  - 存储实例属性（Store Instance Property）：存储在实例内存中，每个实例都有1份。
  - 计算实例属性（Computed Instance Property）。
- 类型属性（Type Property）：只能通过类型去访问。
  - 存储类型属性（Stored Type Property）：整个程序运行过程中，就只有一份内存（类似于全局变量）。
  - 计算类型属性（Computed Type Property）。

可以通过 **static** 定义类型属性，如果是类、也可以使用关键字 **class**。

```swift
struct Car {
    static var count: Int = 0//存储类型属性
    init() {
        Car.count += 1//通过类型访问存储类型属性
    }
}

let c1 = Car()
let c2 = Car()
let c3 = Car()
print(Car.count)// 3
```



类型属性需要注意的点：

- 不同于存储实例属性，你必须给存储类型属性设定初始值，因为类型没有像实例那样的init初始化器来初始化类型存储属性。
- 存储类型属性默认就是lazy，会在第一次使用的时候才初始化；就算被多个线程同时访问，也能保证只会初始化1次。
- 存储类型属性可以是let。
- 枚举也可以定义类型属性（存储类型属性、计算类型属性）。



**使用存储类型属性实现单例模式**

```swift
public class FileManager {
    public static let shared = FileManager()
    private init() {}
}
```

或者

```swift
public class FileManager {
    public static let shared = {
       //...
       //...
        return FileManager()
    }()
    private init() {}
}
```





## 方法（Method）

枚举、结构体、类都可以定义实例方法、类型方法。

- 实例方法（Instance Method）：通过实例对象调用。
- 类型方法（Type Method）：通过类型调用，使用 static 或者 class 关键字定义。

```swift
class Car {
    static var count: Int = 0//存储类型属性
    init() {
        Car.count += 1
    }
    
    static func getCount() -> Int {//类型方法
        count // 在类型方法中：count 等价于 self.count、Car.self.count、Car.count
    }
}

let c1 = Car()
let c2 = Car()
let c3 = Car()
print(Car.count)// 3
```

 注意：**self** 在实例方法中代表当前实例对象、在类型方法中代表当前类型。



**mutating**

结构体和枚举是值类型，默认情况下，值类型的属性不能被自身的实例方法修改；在func关键字前加 **mutating** 可以允许中修改行为。

```swift
struct Point {
    var x = 0, y = 0
    mutating func moveBy(deltaX: Int, deltaY: Int) {
        x += deltaX
        y += deltaY
    }
}
```

**discardableResult**

在func前面加个 @discardableResult， 可以消除：函数调用后返回值未被使用的警告⚠️。

```swift
@discardableResult
func get() -> Int {
    return 10
}
```



## 下标（subscript）

使用 subscript 可以给任意类型（枚举、结构体、类）添加下标功能。

subscript 的语法类似于实例方法、计算属性，其本质就是方法（函数）。

- subscript 中定义的返回值决定了：get方法的返回值类型 和 set方法中newValue的类型。
- subscript可以接受多个参数，并且类型任意。

```swift
struct Point {
    var x = 0.0, y = 0.0
    subscript(index: Int) -> Double {
        set {
            if index == 0 {
                x = newValue
            } else if index == 1 {
                y = newValue
            }
        }
        
        get {
            if index == 0 {
                return x
            } else if index == 1 {
                return y
            }
            return 0
        }
    }
}
var p = Point()
p[0] = 11.1
p[1] = 22.2
print(p.x) // 11.1
print(p.y) // 22.2
print(p[0])// 11.1
print(p[1])// 22.2
```



**下标的细节**

- subscript可以没有set方法，但是必须要有get方法；如果只有get方法，可以省略get。
- 可以设置参数标签。
- 下标可以是类型方法。

```swift
struct Point {
    var x = 0.0, y = 0.0
    
    //为subscript设置参数标签。不像普通函数参数一样、函数参数如果不设置参数标签、参数名字默认成为参数标签，subscript不是。
    subscript(index value: Int) -> Double {
        get{
            if value == 0 {
                return x
            } else if value == 1 {
                return y
            }
            return 0
        }
        set {
            if value == 0 {
                x = newValue
            } else if value == 1 {
                y = newValue
            }
        }
    }
}
var p = Point()
p[index: 0] = 11.1// 如果为subscript设置了参数标签，调用时也需要带上参数标签
p[index: 1] = 22.2// 如果为subscript设置了参数标签，调用时也需要带上参数标签
print(p.x) // 11.1
print(p.y) // 22.2
print(p[index:0])// 11.1
print(p[index:1])// 22.2
```



## 继承（Inheritance）

值类型（枚举、结构体）不支持继承，只有类支持继承。

没有父类的类称为：基类。Switf中没有像java、OC那样的规定：任何类最终都要继承某个基类。

子类可以重写父类的下标、方法、属性，但是必须加上 override 关键字。



**窥探一下继承类实例对象的内存结构**

有下面继承关系：

```swift
class Animal {
    var age = 0
}
class Dog: Animal {
    var weight = 0
}
class ErHa: Dog {
    var iq = 0
}
```

接着创建一个 Dog 实例对象：

```swift
let d = Dog()
d.age = 10
d.weight = 20
print(d)
print(MemoryLayout.stride(ofValue: d))//8
```

然后断点、窥探一下实例对象d的内存布局，如下：



![](/Users/Brooks/blog/blogs/swift/Snip20191103_1.png)

从上图的红色标注区可以看出：

- 实例对象的前8个字节存储对象类型信息的地址，
- 接着后8个字节存储着对象的引用计数地址；
- 最后16个字节存储着成员变量age 和 weight的值：10 和20 。

让我再创建一个 ErHa 实例对象：

```swift
let e = ErHa()
e.age = 11
e.weight = 21
e.iq = 31
print(e)
print(MemoryLayout.stride(ofValue: e))//8
```

然后断点、窥探一下实例对象e的内存布局，如下：



![](/Users/Brooks/blog/blogs/swift/Snip20191103_2.png)

依然从上图的红色标注区分析：

- 实例对象的前8个字节存储对象类型信息的地址，
- 接着后8个字节存储着对象的引用计数地址；
- 最后24个字节存储着成员变量age 、 weight和iq的值：11 、21和31 。



从对上面2个实例对象的内存布局窥探结果得出 —> 实例对象内存中存储着：**对象类型信息地址、对象的引用计数地址、所有成员变量的值（包括从父类继承过来的成员变量）**。



**重写实例方法、下标**

只需要在重写时添加 override 关键尖子即可。简单，没什么可说的~



**重写类型方法、下标**

需要注意的点：**被class修饰的类型方法、下标，允许被子类重写，被 static 修饰的类型方法、下标，不允许被子类重写**。



**重写属性**

- 子类可以将父类的属性（存储、计算）重写为计算属性。

- 子类不可以将父类属性重写为存储属性。
- 只能重写var属性，不能重写let属性。
- 重写时：属性名、类型要一直。
- 子类重写后的属性权限 **不能小于 **父类属性的权限。
  - 如果父类的属性时只读的，那么子类重写后的属性可以是只读的、也可以是可读写的。
  - 如果父类的属性是可写的，那么子类重写后的属性必须是可写的。



**重写实例属性**

简单、没什么可说的~



**重写类型属性**

需要注意的点：**被class修饰的计算类型属性、可以被子类重写；被static修饰的类型属性（存储、计算），不可以被子类重写**。



**属性观察器**

可以在子类中为父类属性（除了只读计算属性、let属性）添加属性观察器。


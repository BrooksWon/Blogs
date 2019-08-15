# Swift学习笔记2一Swift 基本数据类型

## 变量和常量

### 声明常量和变量

- 使用关键字 let 来声明常量
- 使用关键字 var 来声明变量

```swift
let requestTimeOut = 60
var currentRequestTime = 0
```

- 可以在一行中声明多个变量或常量，用逗号分隔

```swift
let a = 1, b = 2, c = 3
var x = 0.0, y = 0.0, z = 0.0
```

### 类型标注

- 添加类型标注的方法是在变量或常量的名字后边加一个冒号，再跟一个空格，最后加上要使用的类型名称
- 在声明一个变量或常量的时候提供类型标注，来明确变量或常量能够储存值的类型
- 可以在一行中定义多个相关的变量为相同的类型，用逗号分隔，只要在最后的变量名字后边加上类型标注

```swift
var welcomeMsg1: String
var welcomeMsg2 = "Hello World"
var welcomeMsg3, welcomeMsg4: String
```

### 变量和常量命名

- 常量和变量的名字几乎可以使用任何字符，甚至包括 Unicode 字符 
- 常量和变量的名字不能包含空白字符、数学符号、箭头、保留的(或者无效的) Unicode 码位、连线和制表符。也不能以数字开头，尽管数字几乎可以使用在名字其他的任何地方 

```swift
let π = 3.14//✅
let ² = "平方"//✅
let 🙂 = "微笑"//✅
let 你好 = "hello"//✅
let -> = "箭头"//❎
```

### 打印常量和变量

- print(_:separator:terminator:) 
- 字符串插值 

```swift
let welcomeMsg = "你好，世界"
print("\(welcomeMsg)")
```



## 基本数据类型

### 整型

- Swift 提供了 8，16，32 和 64 位编码的有符号和无符号整数
  - 命名方式: 例如 8 位无符号整数的类型是 UInt8 ，32 位有符号整数的类型是 Int32 
  - 通过 min 和 max 属性来访问每个整数类型的最小值和最大值 

- Swift 提供了一个额外的整数类型: Int ，它拥有与当前平台的原生字相同的长度 
- 同时 Swift 也提供 UInt 类型，来表示平台长度相关的无符号整数 
- 建议在用到整数的地方都使用 Int 

```swift
let age1 = 32
let age2: Int8 = 32
var age3: Int
age3 = 998

print("age is \(age1)")
print("Int8 min \(Int8.min), Int8 max \(Int8.max)")
print("Int min \(Int.min), Int max \(Int.max)")
```



### 浮点类型

- Double:64 位浮点数，至少有 15 位数字的精度 Float:32 位浮点数，至少有 6 位数字的精度；

- 在两种类型都可以的情况下，推荐使用 Double 类型。

  ```swift
  var doubleNum: Double
  var floatNum: Float
  
  doubleNum = 3.141592678347863274672354746738264823 //只会保留15位小数
  floatNum = 9.012345837385435634 //只会保留6位小数
  
  print("float \(floatNum), double \(doubleNum)")
  ```

### 数值范围

| 类型   | 大小  | 区间值                                      |
| ------ | ----- | ------------------------------------------- |
| Int8   | 1字节 | -128 到 127                                 |
| UInt8  | 1字节 | 0 到 255                                    |
| Int32  | 4字节 | -2147483648 到 2147483647                   |
| UInt32 | 4字节 | 0 到 4294967295                             |
| Int64  | 8字节 | -9223372036854775808 到 9223372036854775807 |
| Uint64 | 8字节 | 0 到 18446744073709551615                   |
| Float  | 4字节 | 1.2E-38 到 3.4E+38 (~6 digits)              |
| Double | 8字节 | 2.3E-308 到 1.7E+308 (~15 digits)           |

### Bool

- Bool：true 和 false

```swift
var flag: Bool
flag = true
print(flag)

flag = false
print(flag)
```

- Swift 的类型安全机制会阻止你用一个非布尔量的值替换掉 Bool

```
let i = 1
if i {
    print(i)
}

编译器会报错❌：'Int' is not convertible to 'Bool'
```

上述代码应该如下表示

```swift
let i = 1
if i == 1 {
    print(i)
}
```

### 类型别名

> 类型别名是一个为已存在类型定义的一个可选择的名字，
>
> 当你想通过在一个在上下文中看起来更合适可具有表达性的名字来引用一个已存在的类型时，这时别名就非常有用了。

- 使用关键字 `typealias` 定义一个类型的别名

```swift
typealias AudioSample = Int8
let sameple: AudioSample = 32
```

### Tuple

- 元组可以把多个值合并成单一的复合型的值
- 元组内的值可以是任何类型，而且可以不必是同一类型

```swift
let error = (1, "没有权限")
print(error)//输出：(1, "没有权限")
print(error.0)//输出：1
print(error.1)//输出：没有权限
```

#### 元素命名

- 元组中的每一个元素可以指定对应的元素名称

```swift
let error = (errorCode: 1, errorMessage: "没有权限")
print(error.errorCode)
print(error.errorMessage)
```



- 如果没有指定名称的元素也可以使用下标的方式来引用

```
let error = (1, "没有权限")
print(error.0)//输出：1
print(error.1)//输出：没有权限
```



#### Tuple 修改

- 用 var 定义的元组就是可变元组，let 定义的就是不可变元组
- 不管是可变还是不可变元组，元组在创建后就不能增加和删除元素
- 可以对可变元组的元素进行修改，但是不能改变其类型
- any 类型可以改为任何类型

```swift
var error: (errorCode: Any, errorMessage: String) = (1, "没有权限")
error.errorCode = "code"
print(error.errorCode)
```



#### Tuple 分解

- 可以将一个元组的内容分解成单独的常量或变量

```swift
let error = (1, "没有权限")
let (errorCode, errorMessage) = error
print(errorCode)
print(errorMessage)
```



- 如果只需要使用其中的一部分数据，不需要的数据可以用下滑线 ` _ `代替

```swift
let error = (1, "没有权限")
let (_, errorMessage) = error
print(errorMessage)
```



#### 作为函数返回值

- 可以使用 Tuple 为函数返回多个值
- 返回值的 Tuple 可以在函数的返回类型部分被命名

```
func writeToFile(content: String) -> (erroCode: Int, errorMessage: String) {
    return (1, "没有权限")
}

print(writeToFile(content: ""))
```



### Optional

- 通过在变量类型后面加 `?` 表示: `这里有一个值，他等于 x` 或者 `这里根本没有值` 

- 你可以通过给可选变量赋值一个 nil 来将之设置为没有值

  - 在 Objective-C 中 nil 是一个指向不存在对象的指针 
  - 在 Swift 中， nil 不是指针，他是值缺失的一种特殊类型，任何类型的可选项都可以设 置成 nil 而不仅仅是对象类型 

  ```swift
  var str: String = nil //❌'nil' cannot initialize specified type 'String'
  var str2: String? = nil
  ```

  

#### 为什么需要 Optional

- Objective-C 里的 nil 是无类型的指针
- Objective-C 里面的数组、字典、集合等不允许放入 nil
- Objective-C 所有对象变量都可以为 nil
- Objective-C 只能用在对象上，而在其他地方又用其他特殊值(例如NSNotFound)表示值的缺失 



#### Optional-If 语句以及强制展开

- 可选项是没法直接使用的， 需要用!展开之后才能使用(意思是我知道这个可选项里边有值，展开吧) 

  ```swift
  var str: String? = "abc"
  let count = str.count//❌value of optional type 'String?' must be unwrapped to refer to member 'count' of wrapped base type 'String'
  ```

  正确姿势是

  ```swift
  var str: String? = "abc"
  if str != nil {
      let count = str!.count
  }
  ```

  

#### Optional-强制展开

- 使用 ! 来获取一个不存在的可选值会导致运行错误，在使用!强制展开之前必须确保可选项中包含一个非 nil 的值

  ```swift
  var str: String?
  let count = str!.count//❌Unexpectedly found nil while unwrapping an Optional value
  ```

  正确姿势

  ```swift
  var str: String? = "abc"
  let count = str!.count
  ```

  

#### Optional-绑定

- 可以使用可选项绑定来判断可选项是否包含值，如果包含就把值赋给一个临时的常量或者变量

- 可选绑定可以与 if 和 while 的语句使用来检查可选项内部的值，并赋值给一个变量或常量

- 同一个 if 语句中包含多可选项绑定，用逗号分隔即可。如果任一可选绑定结果是 nil 或者布尔值为 false ，那么整个 if 判断会被看作 false

  ```swift
  var str: String? = "abc"
  if let actualStr = str {
      let count = actualStr.count
      print(count)
  }
  ```

  

#### Optional-隐式展开

- 有些可选项一旦被设定值之后，就会一直拥有值，在这种情况下，就可以去掉检查的需求，也不必每次访问的时候都进行展开，通过在声明的类型后边添加一个叹号( String! )而非问号( String? ) 来书写隐式展开可 选项 

- 隐式展开可选项主要被用在 Swift 类的初始化过程中

  ```swift
  var str: String! = "abc"
  let count = str.count
  ```

  

#### Optional-可选链

- 可选项后面加问号，如果可选项不为 nil，返回一个可选项结果，否则返回 nil 

  ```swift
  var str: String? = "abc"
  let count = str?.count
  let lastIndex = count-1//error: value of optional type 'Int?' must be unwrapped to a value of type 'Int
  ```

  正确姿势

  ```swift
  var str: String? = "abc"
  let count = str?.count
  if count != nil {
      let lastIndex = count!-1
      print(lastIndex)
  }
  ```

  

#### Optional-实现探究

- Optional 其实是标准库里的一个 enum 类型，用标准库实现语言特性的典型

  ![](https://github.com/BrooksWon/Blogs/blob/master/swift/Optional.png)

- Optional.none 就是 nil，Optional.some 则包装了实际的值

  ```swift
  var str: Optional<String> = "abc"
  if let actualStr = str {
      let count = actualStr.count
      print(count)
  }
  ```

  

##### Optional-展开实现

- 泛型属性 `unsafelyUnwrapped`

  ![](https://github.com/BrooksWon/Blogs/blob/master/swift/unsafelyUnwrapped.png)

- 理论上我们可以直接调用 unsafelyUnwrapped 获取可选项的值

  ```swift
  var str: String? = "abc"
  let count = str.unsafelyUnwrapped.count
  ```

  

## 字符串

### 字符串-初始化

#### 初始化空串

- 字面量

  ```swift
  var emptyString = ""
  ```

- 初始化器语法

  ```swift
  var anotherEmptyString = String()
  ```

- iEmpty 检查是否为空串

  ```swift
  var str: String = String()
  if str.isEmpty {
      print("nothing")//输出nothing
  }
  ```

  

#### 字面量

- 字符串字面量是被双引号(”)包裹的固定顺序文本字符

- Swift 会为 str 常量推断类型为 String

  ```swift
  let string = "some string"
  ```

  

#### 多行字面量

- 多行字符串字面量是用三个双引号引起来的一系列字符

- 多行字符串字面量把所有行包括在引号内，开始和结束默认不会有换行符

- 当你的代码中在多行字符串字面量里包含了换行，那个换行符同样会成为字符串里的值。如果你想要使用换行符来让你的代码易读，却不想让换行符成为字符串的值，那就在那些行的末尾使用反斜杠( \ )

  ```swift
  let softWrappedQuotation = """
  This framework allows you to pick something with a picker presented as an action sheet. In addition, it allows you to add actions arround the presented picker which behave like a button and can be tapped by the user. The result looks very much like an UIActionSheet or UIAlertController with a UIPickerView and some UIActions attached.
  
  Besides being a fully-usable project, RMPickerViewController also is an example for an use case of RMActionController. You can use it to learn how to present a picker other than UIPickerView.
  """
  print(softWrappedQuotation)
  
  /*
  This framework allows you to pick something with a picker presented as an action sheet. In addition, it allows you to add actions arround the presented picker which behave like a button and can be tapped by the user. The result looks very much like an UIActionSheet or UIAlertController with a UIPickerView and some UIActions attached.
  
  Besides being a fully-usable project, RMPickerViewController also is an example for an use case of RMActionController. You can use it to learn how to present a picker other than UIPickerView.
  */
  ```

  ```swift
  let softWrappedQuotation1 = """
  This framework allows you to pick something with a picker presented as an action sheet. In addition, it allows you to add actions arround the presented picker which behave like a button and can be tapped by the user. The result looks very much like an UIActionSheet or UIAlertController with a UIPickerView and some UIActions attached.\
  
  Besides being a fully-usable project, RMPickerViewController also is an example for an use case of RMActionController. You can use it to learn how to present a picker other than UIPickerView.
  """
  print(softWrappedQuotation1)
  
  /*
  This framework allows you to pick something with a picker presented as an action sheet. In addition, it allows you to add actions arround the presented picker which behave like a button and can be tapped by the user. The result looks very much like an UIActionSheet or UIAlertController with a UIPickerView and some UIActions attached.
  Besides being a fully-usable project, RMPickerViewController also is an example for an use case of RMActionController. You can use it to learn how to present a picker other than UIPickerView.
  */
  ```

- 要让多行字符串字面量起始或结束于换行，就在第一或最后一行写一个空行

- 多行字符串可以缩进以匹配周围的代码。双引号( """ )前的空格会告诉 Swift 其他行前应该有多少空白是需要忽略的

- 如果你在某行的空格超过了结束的双引号( """ )，那么这些空格会被包含

  ![](/Users/Brooks/blog/blogs/swift/多行字面量.png)

  

#### 字符串里的特殊字符

- 转义特殊字符 \0 (空字符)， \\ (反斜杠)， \t (水平制表符)， \n (换行符)， \r(回车符)， \" (双引号) 以及 \' (单引号) 
- 任意的 Unicode 标量，写作 \u{n}，里边的 n 是一个 1-8 位的16 进制数字，其值是合法 Unicode 值
- 可以在多行字符串字面量中包含双引号( " )而不需转义。要在多行字符串中包含文本 """ ，转义至
  少一个双引号

```swift
let wisWords = "\"Imagination is more important than knowledge\" -Einstein"
let dollarSign = "\u{24}"
let blackHeart = "\u{2665}"
let sparklingHeart = "\u{1F496}"
```



#### 扩展字符串分隔符(Raw String)

- 在字符串字面量中放置扩展分隔符来在字符串中包含特殊字符而不让它们真的生效
- 把字符串放在双引号( " )内并由井号( # )包裹
- 如果字符串里有 "# 则首尾需要两个 ##
- 如果你需要字符串中某个特殊符号的效果，使用匹配你包裹的井号数量的井号并在前面写转义符号 \

```swift
let str = #"Line 1\nLine 2 "#
let str1 = #"Line 1\#nLine 2 "#
let str2 = ###"Line 1\###nLine 2 "###
print(str)
print(str1)
print(str2)

/*
Line 1\nLine 2 
Line 1
Line 2 
Line 1
Line 2 
*/
```



### 字符串-操作

#### 字符串的可变性

- var 指定的可以修改
- let 指定的不可修改
- 对比 Objective-C(NSString 和 NSMutableString)

```swift
var variableString = "hello"
variableString += " world"
//variableString is now "hello world"
let contstantString = "你好"
contstantString += "世界"
//error: left side of mutating operator isn't mutable: 'contstantString' is a 'let' constant
```



#### 字符串是值类型

- String 值在传递给方法或者函数的时候会被复制过去，赋值给常量或者变量的时候也是一样
- Swift 编译器优化了字符串使用的资源，实际上拷贝只会在确实需要的时候才进行

```swift
var str = "abc"
var str1 = str
print(str == str1)//true
str += "def"
print(str)//abcdef
print(str1)//abc
print(str == str1)//falese
```



#### 操作字符

- for-in 循环遍历 String 中的每一个独立的 Character
- Character 类型
- String 值可以通过传入 Character 数组来构造

```swift
for character in "Dog!🐶" {
    print(character)
}
/*
D
o
g
!
🐶
*/
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
print(catCharacters)//["C", "a", "t", "!", "🐱"]
```



#### 字符串拼接

- 使用加运算符( +)创建新字符串

- 使用加赋值符号( +=)在已经存在的 String 值末尾追加一个 String 值

- 使用 String 类型的 append() 方法来可以给一个 String 变量的末尾追加 Character 值

  

#### 字符串插值

- 字符串插值是一种从混合常量、变量、字面量和表达式的字符串字面量构造新 String 值的方法
- 每一个你插入到字符串字面量的元素都要被一对圆括号包裹，然后使用反斜杠前缀
- 类似于 NSString 的 stringWithFormat 方法，但是更加简便，更强大

```swift
let multiplier = 3
print("\(multiplier) times 2.5 is \(Double(3) * 2.5)")
```

- 可以在扩展字符串分隔符中创建一个包含在其他情况下会被当作字符串插值的字符

  ```swift
  print(#"Wirte an anterpolated string in Swift use \(multiplier)."#)//Wirte an anterpolated string in Swift use \(multiplier).
  ```

  

- 要在使用扩展分隔符的字符串中使用字符串插值，在反斜杠后使用匹配首尾井号数量的井号

  ```swift
  print(#"6 times 7 is \#(6 * 7)."#)//6 times 7 is 42.
  ```

  

### 字符串-访问和修改

#### 字符串索引

- 每一个 String 值都有相关的索引类型， String.Index，它相当于每个 Character 在字符串中的位置
- startIndex 属性来访问 String 中第一个 Character 的位置。 endIndex 属性就是 String中最后一个字符后的位置
- endIndex 属性并不是字符串下标脚本的合法实际参数
- 如果 String 为空，则 startIndex 与 endIndex 相等

```swift
let str = "hello Swift!"
print(str[str.startIndex])//h

let str1 = ""
if str1.startIndex == str1.endIndex {
    print("空串")//空串
}

if str1.isEmpty {
    print("空串")//空串
}
```

- 使用 index(before:) 和 index(after:) 方法来访问给定索引的前后

  ```swift
  let str = "hello Swift!"
  
  str[str.index(before: str.endIndex)]//!
  str[str.index(after: str.startIndex)]//e
  ```

  

- 要访问给定索引更远的索引，你可以使用 index(_:offsetBy:)

  ```
  str[str.index(before: str.endIndex)]//!
  str[str.index(after: str.startIndex)]//e
  str[str.index(str.startIndex, offsetBy: 6)]//S
  ```

  

- 使用 indices 属性来访问字符串中每个字符的索引

#### 插入

- 插入字符，使用 insert(_:at:) 方法
- 插入另一个字符串的内容到特定的索引，使用 insert(contentsOf:at:) 方法

```swift
var str = "hello"
str.insert("!", at: str.endIndex)//hello!
str.insert(contentsOf: " Swift", at: str.index(before: str.endIndex))//hello Swift!
```



#### 删除

- 移除字符，使用 remove(at:)方法
- 移除一小段特定范围的字符串，使用 removeSubrange(_:) 方法

```swift
var str = "hello Swift!"
str.remove(at: str.index(before: str.endIndex))//hello Swift

let range = str.startIndex ..< str.index(str.startIndex, offsetBy: 6)
str.removeSubrange(range)//Swift

str.removeLast()//Swif
str.removeFirst()//wif
```



### 字符串-子串和字符串比较

#### 子字符串

- 使用下标或者类似 prefix(_:) 的方法得到的子字符串是 Substring 类型
- Substring 拥有 String 的大部分方法
- Substring 可以转成 String 类型

```swift
var str = "hello, World!"
let index = str.firstIndex(of: ",") ?? str.endIndex
let beginning = str[..<index]
let netStr = String(beginning)//hello
```

- 子字符串重用一部分原字符串的内存，修改字符串或者子字符串之前都不需要花费拷贝内存的代价

- String 和 Substring 都遵循 StringProtocol 协议，也就是说它基本上能很方便地兼容所有
  接受 StringProtocol 值的字符串操作函数

  ![](/Users/Brooks/blog/blogs/swift/子字符串.png)

  

#### 字符串比较

- 字符串和字符相等性(==和!=)
- 前缀相等性 hasPrefix(_:)
- 后缀相等性 hasSuffix(_:)

```swift
var str = "hello, World"
var str1 = "hello"
print(str == str1)//false
print(str.hasPrefix("hello"))//true
print(str.hasSuffix("World"))//true
```


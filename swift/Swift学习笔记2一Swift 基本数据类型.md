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

  ![](/Users/Brooks/blog/blogs/swift/Optional.png)

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

  ![](/Users/Brooks/blog/blogs/swift/unsafelyUnwrapped.png)

- 理论上我们可以直接调用 unsafelyUnwrapped 获取可选项的值

  ```swift
  var str: String? = "abc"
  let count = str.unsafelyUnwrapped.count
  ```

  

## 字符串

### 字符串-初始化

#### 初始化空串

#### 字面量

#### 多行字面量

#### 字符串里的特殊字符

#### 扩展字符串分隔符(Raw String)

### 字符串-操作

#### 字符串的可变性

#### 字符串是值类型

#### 操作字符

#### 字符串拼接

#### 字符串插值

### 字符串-访问和修改

#### 字符串索引

#### 插入

#### 删除

### 字符串-子串和字符串比较

#### 子字符串

#### 字符串比较
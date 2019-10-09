# Swift学习笔记6—函数和闭包

[TOC]



## 1. 函数

### 1.1 函数的定义

#### 1.1.1 基本概念

- 函数是一个独立的代码块，用来执行特定的任务。通过给函数一个名字来定义它的功能，并且在需要的时候，通过这个名字来“调用”函数执行它的任务。
- Swift 统一的函数语法十分灵活，可以表达从简单的无形式参数的 C 风格函数到复杂的每一个形式参 数都带有局部和外部形式参数名的 Objective-C 风格方法的任何内容。形式参数能提供一个默认的值 来简化函数的调用，也可以被当作输入输出形式参数被传递，它在函数执行完成时修改传递来的变 量。
- **Swift 中的每一个函数都有类型，由函数的形式参数类型和返回类型组成**。你可以像 Swift 中其他类 型那样来使用它，这使得你能够方便的将一个函数当作一个形式参数传递到另外的一个函数中，也可 以在一个函数中返回另一个函数。函数同时也可以写在其他函数内部来在内嵌范围封装有用的功能。

#### 1.1.2 定义和调用函数

- 当你定义了一个函数的时候，你可以选择定义一个或者多个命名的分类的值作为函数的输入 (所谓的形式参数)，并且/或者定义函数完成后将要传回作为输出的值的类型(所谓它的返回 类型)
- 每一个函数都有一个函数名，它描述函数执行的任务。要使用一个函数，你可以通过“调用”函数的名字并且传入一个符合函数形式参数类型的输入值(所谓实际参数)来调用这个函数。给函数提供的实际参数的顺序必须符合函数的形式参数列表顺序。

```swift
func greet(person: String) -> String {
    let greeting = "Hello," + person + "!"
    return greeting
}
```

#### 1.1.3 无形式参数的函数

- 函数没有要求必须输入一个参数，可以没有形式参数。
- 函数的定义仍然需要在名字后边加一个圆括号，即使它不接受形式参数也得这样做。当函数被调用的时候也要在函数的名字后边加一个空的圆括号。

```swift
func sayHello() -> String {
    return "hello"
}
print(sayHello())
```

#### 1.1.4 多形式参数的函数

- 函数可以输入多个形式参数，可以写在函数后边的圆括号内，用逗号分隔。

```swift
func greet(person: String, alreadyGreeted: Bool) -> String {
    if alreadyGreeted {
        return "say hello again"
    } else {
        return "hello" + person + "!"
    }
}
print(greet(person: "Tim", alreadyGreeted: true))
```

#### 1.1.5 无返回值的函数

- 函数定义中没有要求必须有一个返回类型。
- 不需要返回值，函数在定义的时候就没有包含返回箭头( ->)或者返回类型。
- 严格来讲，函数 greet(person:)还是有一个返回值的，尽管没有定义返回值。没有定义返回类 型的函数实际上会返回一个特殊的类型 Void。它其实是一个空的元组，作用相当于没有元素的 元组，可以写作 () 。

```swift
func greet(person: String) {
    print("hello, \(person)!")
}
greet(person: "Dave")
```

#### 1.1.6 多返回值的函数

- 为了让函数返回多个值作为一个复合的返回值，你可以使用元组类型作为返回类型。

```swift
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var curentMin = array[0]
    var curentMax = array[0]
    for value in array {
        if value < curentMin {
            curentMin = value
        } else if value > curentMax {
            curentMax = value
        }
    }
    return (curentMin, curentMax)
}

let minMaxValue = minMax(array: [8,3,9,1,5])
print("min:\(minMaxValue.min), max:\(minMaxValue.max)")
```

#### 1.1.7 可选元组返回类型

- 如果元组在函数的返回类型中有可能“没有值”，你可以用一个可选元组返回类型来说明整个元组的可能 是 nil 。写法是在可选元组类型的圆括号后边添加一个问号( ?)例如 (Int, Int)? 或者 (String, Int, Bool)? 。

```swift
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty {
        return nil
    }
    var curentMin = array[0]
    var curentMax = array[0]
    for value in array {
        if value < curentMin {
            curentMin = value
        } else if value > curentMax {
            curentMax = value
        }
    }
    return (curentMin, curentMax)
}

if let minMaxValue = minMax(array: [8,3,9,1,5]) {
    print("min:\(minMaxValue.min), max:\(minMaxValue.max)")
}
```

#### 1.1.8 隐式返回的函数

- 如果整个函数体是一个单一表达式，那么函数隐式返回这个表达式。

```swift
func greeting(for person: String) -> String {
    "hello," + person + "!"//函数隐式返回这个表达式的值, 等效  `return "hello," + person + "!"`
}
print(greeting(for: "Dave"))
//hello,Dave!
```

### 1.2 函数实际参数标签和形式参数名

#### 1.2.1 默认参数标签

- 每一个函数的形式参数都包含实际参数标签和形式参数名。实际参数标签用在调用函数的时候;在调用函数的时候每一个实际参数前边都要写实际参数标签。形式参数名用在函数的实现当中。默认情况下，形式参数使用它们的形式参数名作为实际参数标签。
- 所有的形式参数必须有唯一的名字。尽管有可能多个形式参数拥有相同的实际参数标签，唯一的实际参数标签有助于让你的代码更加易读。

```swift
func somwFunction(firstParameterName: Int, secondParameterName: Int) {
    //do something
}
somwFunction(firstParameterName: 1, secondParameterName: 2)
```

#### 1.2.1 指定实际参数标签

- 在提供形式参数名之前写实际参数标签，用空格分隔。
- 如果你为一个形式参数提供了实际参数标签，那么这个实际参数就必须在调用函数的时候使用标签。
- 实际参数标签的使用能够让函数的调用更加明确，更像是自然语句，同时还能提供更可读的函数体并更清晰地表达你的意图。

```swift
func greet(person: String, from hometown: String) -> String {
    return "Hello,\(person)! Glad you could visit from \(hometown)."
}
print(greet(person: "Bill", from: "Cupertino"))
```

#### 1.2.2 省略实际参数标签

- 如果对于函数的形式参数不想使用实际参数标签的话，可以利用下划线( _ )来为 这个形式参数代替显式的实际参数标签。

```swift
func somwFunction(_ firstParameterName: Int, secondParameterName: Int) {
    //do something
}
somwFunction(1, secondParameterName: 2)
```

### 1.3  形式参数

#### 1.3.1  默认形式参数值

- 你可以通过在形式参数类型后给形式参数赋一个值来给函数的任意形式参数定义一个默认值。
- 如果定义了默认值，你就可以在调用函数时候省略这个形式参数。

```swift
func somwFunction(parameterName: Int = 12) {
    //do something
}
somwFunction()

```

#### 1.3.2 可变形式参数

- **一个可变形式参数可以接受零或者多个特定类型的值**。当调用函数的时候你可以利 用可变形式参数来声明形式参数可以被传入值的数量是可变的。可以通过在形式参 数的类型名称后边插入三个点符号( ...)来书写可变形式参数。
- **传入到可变参数中的值在函数的主体中被当作是对应类型的数组**。

```swift
func arithmeticMean(_ numbers: Double...) -> Double {
    var total:Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

print(arithmeticMean(1, 2, 3, 4, 5))//3.0
```

#### 1.3.3 输入输出形式参数

- 可变形式参数只能在函数的内部做改变。如果你想函数能够修改一个形式参数的值，而且你想这些改变在函数结束之后依然生效，那么就需要将形式参数定义为输入输出形式参数。
- 在形式参数定义开始的时候在前边添加一个 inout 关键字可以定义一个输入输出形式参数。输入输出形式参 数有一个能输入给函数的值，函数能对其进行修改，还能输出到函数外边替换原来的值。
- 你只能把变量作为输入输出形式参数的实际参数，在将变量作为实际参数传递给输入输出形式参数的时候， 直接在它前边添加一个和符号 ( &) 来明确可以被函数修改。
- 输入输出形式参数不能有默认值，可变形式参数不能标记为 inout。

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let tmp = a
    a = b;
    b = tmp
}

var a = 1
var b = 3
swap(&a, &b)
```

### 1.4 函数类型

- 每一个函数都有一个特定的函数类型，它由形式**参数类型，返回类型组成**。

```swift
func add(_ a: Int, _ b: Int) -> Int {
    return a+b
}

func multiply(_ a: Int, _ b: Int) -> Int {
    return a*b
}
```

上面两个函数的类型都是 `(Int, Int) -> Int`

- **你可以像使用 Swift 中的其他类型一样使用函数类型**。例如，你可以给一个常量或变 量定义一个函数类型，并且为变量指定一个相应的函数。

- ```swift
  var function:(Int, Int) -> Int
      
  function = add(_:_:)
  print(function(2, 3))//5
  
  function = multiply(_:_:)
  print(function(2, 3))//6
  ```

- **函数类型作为形式参数类型**: 你可以利用使用一个函数的类型例如 `(Int, Int) -> Int`  作为其他函数的形式参数类型。 这允许你预留函数的部分实现从而让函数的调用者在调用函数的时候提供。

- ```swift
  func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
      print("Result: \(mathFunction(a, b))")
  }
  
  printMathResult(add(_:_:), 3, 6)//9
  printMathResult(multiply(_:_:), 3, 6)//18
  ```

- **函数类型作为返回类型**：你可以利用函数的类型作为另一个函数的返回类型。写法是在函数的返回箭头( ->) 后立即写一个完整的函数类型。

- ```swift
  func stepForward(_ input: Int) -> Int {
      return input + 1
  }
  func stepBackward(_ input: Int) -> Int {
      return input - 1
  }
  
  func chooseStepFunction(backwards: Bool) -> (Int) -> Int {
      return backwards ? stepBackward : stepForward
  }
  
  var currentValue = 3
  let moveStepFunction = chooseStepFunction(backwards: currentValue > 0)//back
  print(moveStepFunction(currentValue))//2
  ```

### 1.5 内嵌函数

- 可以在函数的内部定义另外一个函数。这就是内嵌函数。
- 内嵌函数在默认情况下在外部是被隐藏起来的，但却仍然可以通过包裹它们的函数来调用它们。包裹的函数也可以返回它内部的一个内嵌函数来在另外的范围里使用。

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(_ input: Int) -> Int {
        return input + 1
    }
    func stepBackward(_ input: Int) -> Int {
        return input - 1
    }
    
    return backward ? stepBackward : stepForward
}

var currentValue = -4
let moveStepFunction = chooseStepFunction(backward: currentValue > 0)//forward
print(moveStepFunction(currentValue))//-3
```



## 2. 闭包

### 2.1 闭包的概念

- 闭包是可以在你的代码中被传递和引用的功能性独立代码块。
- 闭包能够捕获和存储定义在其上下文中的任何常量和变量的引用，这也就是所谓的闭 合并包裹那些常量和变量，因此被称为“闭包”，Swift 能够为你处理所有关于捕获 的内存管理的操作。
- 在函数章节中有介绍的全局和内嵌函数，实际上是特殊的闭包。闭包符合如下三种形式中的一种:
  - 全局函数是一个有名字但不会捕获任何值的闭包;
  - 内嵌函数是一个有名字且能从其上层函数捕获值的闭包;
  - 闭包表达式是一个轻量级语法所写的可以捕获其上下文中常量或变量值的没有名字的闭包。

### 2.2 闭包表达式

### 2.3 尾随闭包

- 如果你需要将一个很长的闭包表达式作为函数最后一个实际参数传递给函数，使用尾随闭包将增强函数的可读性。尾随闭包是一个被书写在函数形式参数的括号外面(后面)的闭包表达式。

- ```swift
  let names = ["zhangsan", "lisi", "wangwu", "zhaoliu"]
  var soutedNames = names.sorted{ $0 > $1}
  print(soutedNames)
  ```

### 2.4 捕获值

- **一个闭包能够从上下文捕获已被定义的常量和变量**。即使定义这些常量和变量的原作用域已经不存在，闭包仍能够在其函数体内引用和修改这些值。

- ```swift
  func makeIncrementer(forInrementer amount: Int) -> () -> Int {
      var runningTotal = 0
      func inrementer() -> Int {
          runningTotal += amount
          return runningTotal
      }
      return inrementer
  }
  ```

- 作为一种优化，如果一个值没有改变或者在闭包的外面，Swift 可能会使用这个值的 拷贝而不是捕获。

- Swift也处理了变量的内存管理操作，当变量不再需要时会被释放。

```swift
let inrementByTen = makeIncrementer(forInrementer: 10)//() -> Int
inrementByTen()//10
inrementByTen()//20
inrementByTen()//30
```

- 如果你建立了第二个 incrementer ,它将会有一个新的、独立的 runningTotal 变量的 引用。

```swift
let inrementByFive = makeIncrementer(forInrementer: 5)//() -> Int
inrementByFive()//5
inrementByFive()//10
inrementByFive()//15
```

### 2.5 闭包是引用类型

- 在 Swift 中，函数和闭包都是引用类型。
- 无论你什么时候赋值一个函数或者闭包给常量或者变量，你实际上都是将常量和变量设置为对函数和闭包的引用。

```swift
let inrementByTen = makeIncrementer(forInrementer: 10)//() -> Int
inrementByTen()//10
inrementByTen()//20
inrementByTen()//30

let inrementByFive = makeIncrementer(forInrementer: 5)//() -> Int
inrementByFive()//5

inrementByTen()//40

let alsoInrementByTen = inrementByTen
alsoInrementByTen()//50
```

- 如果你分配了一个闭包给类实例的属性，并且闭包通过引用该实例或者它的成员来捕获实例，你将在闭包和实例间会产生循环引用。

### 2.6 逃逸闭包

- 当闭包作为一个实际参数传递给一个函数的时候，并且它会在函数返回之后调用，我 们就说这个闭包逃逸了。当你声明一个接受闭包作为形式参数的函数时，你可以在形 式参数前写 @escaping 来明确闭包是允许逃逸的。
- 闭包可以逃逸的一种方法是被储存在定义于函数外的变量里。比如说，很多函数接收闭包实际参数来作为启动异步任务的回调。函数在启动任务后返回，但是闭包要直到任务完成——闭包需要逃逸，以便于稍后调用。

```swift
var completionHanders: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHanders.append(completionHandler)
}
```

- 让闭包 @escaping 意味着你必须在闭包中显式地引用 self

```swift
var completionHanders: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHanders.append(completionHandler)
}

func someFunctionWithNoneEscapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNoneEscapingClosure { x = 200 }
    }
}

let  instance = SomeClass()
instance.doSomething()
print(instance.x)//200

completionHanders.first?()
print(instance.x)//100
```

### 2.7 自动闭包

- 自动闭包是一种自动创建的用来把作为实际参数传递给函数的表达式打包的闭包。它不接受任何实际参数，并且当它被调用时，它会返回内部打包的表达式的值。

- 这个语法的好处在于通过写普通表达式代替显式闭包而使你省略包围函数形式参数的括号。

  ![自动闭包](/Users/Brooks/blog/blogs/swift/自动闭包.png)

- 自动闭包允许你延迟处理，因此闭包内部的代码直到你调用它的时候才会运行。对于有副作用或者占用资源的代码来说很有用，因为它可以允许你控制代码何时才进行求值。

- ```swift
  var customersInLine = ["zhangsan", "lisi", "wangwu", "zhangliu"]
  print(customersInLine.count)//4
  
  let customersProvider = { customersInLine.removeFirst() }
  print(customersInLine.count)//4
  
  print("Now serving \(customersProvider())!")//Now serving zhangsan!
  print(customersInLine.count)//3
  ```

- 当你传一个闭包作为实际参数到函数的时候，你会得到与延迟处理相同的行为。

- ```swift
  var customersInLine = ["zhangsan", "lisi", "wangwu", "zhangliu"]
  
  func serve(customer customerProvider: () -> String) {
      print("Now serving \(customerProvider())!")
  }
  
  serve(customer: { customersInLine.removeFirst() })//Now serving zhangsan!
  ```

- 通过 @autoclosure 标志标记它的形式参数使用了自动闭包。现在你可以调用函数就 像它接收了一个 String 实际参数而不是闭包。实际参数自动地转换为闭包，因为 customerProvider 形式参数的类型被标记为 @autoclosure 标记。

- ```swift
  var customersInLine = ["zhangsan", "lisi", "wangwu", "zhangliu"]
  
  func serve(customer customerProvider: @autoclosure () -> String) {
      print("Now serving \(customerProvider())!")
  }
  
  serve(customer: customersInLine.removeFirst())//Now serving zhangsan!
  ```

### 2.8 自动+逃逸

- 如果你想要自动闭包允许逃逸，就同时使用 @autoclosure 和 @escaping 标志。

- ```swift
  var customersInLine = ["zhangsan", "lisi", "wangwu", "zhangliu"]
  var customerProviders: [() -> String] = []
  func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
      customerProviders.append(customerProvider)
  }
  collectCustomerProviders(customersInLine.removeFirst())
  collectCustomerProviders(customersInLine.removeFirst())
  
  print("Colected \(customerProviders.count) closures.")
  for customerProvider in customerProviders {
      print("Now serving \(customerProvider())!")
  ```

### 3. 如何使用Swift中的高阶函数

#### 3.1 map

- 对于原始集合里的每一个元素，以一个变换后的元素替换之形成一个新的集合

  ![](/Users/Brooks/blog/blogs/swift/map.png)

  ```swift
  let results = [2.0, 4.0, 5.0, 7.0]
  let allResults = results.map{ $0 * $0 }
  print(allResults)//[4.0, 16.0, 25.0, 49.0]
  ```

   

#### 3.2 filter

- 对于原始集合里的每一个元素，通过判定来将其丢弃或者放进新集合

  ![](/Users/Brooks/blog/blogs/swift/filter.png)

  ```swift
  let results = [1, 4, 10, 15]
  let passMarks = results.filter{ $0 % 2 == 0 }
  print(passMarks)//[4, 10]	
  ```

  

#### 3.3 reduce

- 对于原始集合里的每一个元素，作用于当前累积的结果上

  ![](/Users/Brooks/blog/blogs/swift/reduce.png)

  ```swift
  let results = [2.0, 4.0, 5.0, 7.0]
  let reduceResults = results.reduce(100) { $0 + $1 }
  print(reduceResults)//118.0
  ```

  

  

#### 3.4 flatMap

- 对于元素是集合的集合，可以得到单级的集合 

- ```swift
  let results = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  let allResults = results.flatMap{ $0.map{ $0 * 10 } }
  let passMarks = results.flatMap{ $0.filter{ $0 > 5 } }
  
  print(allResults)//[10, 20, 30, 40, 50, 60, 70, 80, 90]
  print(passMarks)//[6, 7, 8, 9]
  ```

#### 3.5 compactMap

- 过滤空值

- ```swift
  let names: [String?] = ["zhangsan", nil, "lisi", nil, "wangwu"]
  let validNames = names.compactMap{ $0 }
  print(validNames)//["zhangsan", "lisi", "wangwu"]
  let counts = names.compactMap{ $0?.count }
  print(counts)//[8, 4, 6]
  ```

## 4. 函数式编程 1

### 4.1 从一个题目说起

读入一个文本文件，确定所有单词的使用频率并从高到低排序，打印出所有单词及其频率的排序列表。

> 这道题目出自计算机科学史上的著名事件，是当年 Communications of the ACM 杂 志“Programming Pearls”专栏的作者 Jon Bentley 向计算机科学先驱 Donald Knuth 提出的挑战。

- 传统解决方案

- ```swift
  let NON_WORDS: Set = ["and", "of", "to" , "in", "at", "on"]
  
  
  /// 统计单词出现的频率
  /// - Parameter words: 输入文本
  /// - Returns: 输出文本中单词出现的频率字典，key为单词，value为该单词在文本中出现的次数
  func wordFreq(words: String) -> [String:Int] {
      var wordDic: [String: Int] = [:]
      let wordList = words.split(separator: " ")
      for word in wordList {
          let lowerCaseWord = word.lowercased()
          if !NON_WORDS.contains(lowerCaseWord) {
              if let count = wordDic[lowerCaseWord] {
                  wordDic[lowerCaseWord] = count + 1
              } else {
                  wordDic[lowerCaseWord] = 1
              }
          }
      }
      return wordDic
  }
  
  // test case
  let words = """
  The following example creates an array of integers from an array literal then appends the elements of another collection. Before appending the array allocates new storage that is large enough store the resulting elements
  """
  print(wordFreq(words: words))//调用
  print(wordFreq(words: words).sorted{ $0.value > $1.value })// 使用sorted函数即可完成对单词出现次数的降序排列
  ```

- 函数式

- ```swift
  /// 函数式
  /// 统计单词出现的频率
  /// - Parameter words: 输入文本
  /// - Returns: 输出文本中单词出现的频率字典，key为单词，value为该单词在文本中出现的次数
  func wordFreq2(words: String) -> [String: Int] {
      var wordDic: [String: Int] = [:]
      let wordList = words.split(separator: " ")
      wordList.map{ $0.lowercased() }
          .filter(){ !NON_WORDS.contains($0) }
          .forEach{ (word) in
          wordDic[word] = (wordDic[word] ?? 0) + 1
      }
      return wordDic
  }
  ```



## 5. 函数编程 2

假设我们有一个名字列表，其中一些条目由单个字符构成。现在的任务是，将除去单字符条目之外的列表内容，放在一个逗号分隔的字符串里返回，且每个名字的首字母都要大写。

- 命令式解法
  - 命令式编程是按照“程序是一系列改变状态的命令”来建模的一种编程风格。传统的 for 循 环是命令式风格的绝好例子:先确立初始状态，然后每次迭代都执行循环体中的一系列命令。

```swift
let employee = ["jack", "s", "m", "stu", "bob"]
func cleanNames(names: Array<String>) -> String {
    var cleanNames = ""
    for name in names {
        if name.count > 1 {
            cleanNames += ( name.first!.uppercased() + name.dropFirst() ) + ","
        }
    }
    cleanNames.dropLast()
    return cleanNames
}

print(cleanNames(names: employee))
```

- 函数式解法
  - 函数式编程将程序描述为表达式和变换，以数学方程的形式建立模型，并且尽量避免可变的 状态。函数式编程语言对问题的归类不同于命令式语言。如前面所用到的几种操作 (filter、transform、convert)，每一种都作为一个逻辑分类由不同的函数所代表，这些 函数实现了低层次的变换，但依赖于开发者定义的高阶函数作为参数来调整其低层次运转机 构的运作。

```swift
let employee = ["jack", "s", "m", "stu", "bob"]

let cleanNames = employee.filter(){ $0.count > 1 }
    .map{ $0.first!.uppercased() + $0.dropFirst() }
    .joined(separator: ",")

print(cleanNames)
```

### 5.1 具有普遍意义的基本构造单元

- 筛选（filter）
- 映射（map）
- 折叠 / 化约（foldLeft / reduce）等
# Swift学习笔记4-流程控制

## 1.0 循环控制

### 1.1 for-in 循环

- 使用 for-in 循环来遍历序列，比如一个范围的数字，数组中的元素或者字符串中的字符。

  ```swift
  for i in 0...3 {//遍历区间
      print(i)
  }
  
  for c in "Hello, World" {////遍历字符串的自字符
      print(c)
  }
  
  for name in ["张三", "李四", "王五"] {//遍历数组
      print(name)
  }
  ```

- 遍历字典:  当字典遍历时，每一个元素都返回一个 (key, value) 元组，你可以在 for-in 循环体中使用显 式命名常量来分解 (key, value) 元组成员。

  ```swift
  for (name, age) in ["张三": 23, "李四": 24, "王五": 25] {
      print(name, age)
  }
  
  for item in ["张三": 23, "李四": 24, "王五": 25] {
      print(item.key, item.value)
  }
  
  for item in ["张三": 23, "李四": 24, "王五": 25] {
      print(item.0, item.1)
  }
  ```

- 如果你不需要序列的每一个值，你可以使用下划线来取代遍历名以忽略值。

- ```swift
  let base = 3
  let power = 5
  var answer = 1
  
  for _ in 1...power {
      answer *= base
  }
  ```

- for-in 分段区间:

  - 使用 stride(from:to:by:) 函数来跳过不想要的标记 (开区间)。

  - ```
    let minuteInterval = 5
    for tickMark in stride(from: 0, to: 50, by: minuteInterval) {
        print(tickMark)
    }
    //0
    //5
    //10
    //15
    //20
    //25
    //30
    //35
    //40
    //45
    ```

    

  - 闭区间也同样适用，使用 stride(from:through:by:) 即可。

  - ```
    let minuteInterval = 5
    for tickMark in stride(from: 0, through: 50, by: minuteInterval) {
        print(tickMark)
    }
    //0
    //5
    //10
    //15
    //20
    //25
    //30
    //35
    //40
    //45
    //50
    ```

    

### 1.2 while 循环

- repeat-while 循环 (Objective-C do-while)

- ```swift
  var count = 0
  repeat {
      print(count)
      count += 1
  } while count < 5
  //0
  //1
  //2
  //3
  //4
  ```

  

## 2.0 switch

- switch 语句会将一个值与多个可能的模式匹配。然后基于第一个成功匹配的模式来执行合适的 代码块。
- switch 语句一定得是全面的。就是说，给定类型里每一个值都得被考虑到并且匹配到一个 switch 的 case。如果无法提供一个 switch case 所有可能的值，你可以定义一个默认匹配所有 的 case 来匹配所有未明确出来的值。这个匹配所有的情况用关键字 default 标记，并且必须在 所有 case 的最后出现。
- Objective-C switch 语句如果不全面，仍然可以运行。

### 2.1 没有隐式贯穿:

- 相比 C 和 Objective-C 里的 switch 语句来说，Swift 里的 switch 语句不会默认从匹配 case 的末尾贯穿到下一个 case 里。
- 相反，整个 switch 语句会在匹配到第一个 switch 的 case 执行完毕之后退出，不再需要显式 的 break 语句。
- 每一个 case 的函数体必须包含至少一个可执行的语句。
- 在一个 switch 的 case 中匹配多个值可以用逗号分隔，并且可以写成多行。

```swift
let character: Character = "c"
switch character {
case "a","b":
    print(character)
default:
    print("没有匹配到")
}
```

### 2.2 区间匹配

- switch 的 case 的值可以在一个区间中匹配

  ```swift
  let score = 86
  var str: String?
  
  switch score {
  case 0:
      str = "缺考 或者 未交卷"
  case 0..<60:
      str = "不及格"
  case 60..<75:
      str = "及格"
  case 75..<85:
      str = "良"
  case 85..<100:
      str = "优秀"
  default:
      str = "满分💯"
  }
  
  print(str ?? "默认值")//优秀
  ```

### 2.3 元组匹配

- 你可以使用元组来在一个 switch 语句中测试多个值
- 使用下划线(_)来表明匹配所有可能的值

```swift
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0):
    print("(\(somePoint.0), 0) is on the x-axis")
case (0, _):
    print("(\0, \(somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
}
//(1, 1) is inside the box
```

### 2.4 值绑定

- switch 的 case 可以将匹配到的值临时绑定为一个常量或者变量，来给 case 的函数体使用。
- 如果使用 var 关键字，临时的变量就会以合适的值来创建并初始化。对这个变量的任何改变 都只会在 case 的函数体内有效。

```swift
let anotherPoint = (2, 1)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with an x value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
//somewhere else at (2, 1)
```

### 2.5 where 字句

- switch case 可以使用 where 分句来检查是否符合特定的约束

  ```swift
  let yetAnotherPoint = (1, -1)
  switch yetAnotherPoint {
  case let (x, y) where x == y:
      print("\(x), \(y) is on the line x == y")
  case let (x, y) where x == -y:
      print("\(x), \(y) is on the line x == -y")
  case let (x, y):
      print("\(x), \(y) is just some arbitrary point")
  }
  //1, -1 is on the line x == -y
  ```

### 2.6 复合匹配

- 多种情形共享同一个函数体的多个情况可以在 case 后写多个模式来复合，在每个模式之间用 逗号分隔。如果任何一个模式匹配了，那么这个情况都会被认为是匹配的。如果模式太长，可 以把它们写成多行。

  ```swift
  let character: Character = "x"
  switch character {
  case "a", "b", "c", "d", "e", "f":
      print("'\(character)' 在 a-f 内")
  case "g"..."m":
      print("'\(character)' 在 g-m 内")
  case "n", "o", "p", "q", "r", "s","t",
       "u", "v", "w", "x", "y","z":
      print("'\(character)' 在 n-z 内")
  default:
      print("没有匹配到")
  }
  ```

#### 2.6.1 复合匹配 - 值绑定

- 复合匹配同样可以包含值绑定。所有复合匹配的模式都必须包含相同的值绑定集合，并且复合情况中的每一个绑定都得有相同的类型格式。这才能确保无论复合匹配的那部分命中了，接下来的函数体中的代码都能访问到绑定的值并且值的类型也都相同。

  ```swift
  let point = (9, 0)
  switch point {
  case (let distance, 0), (0, let distance):
      print("On an axis, \(distance) from the origin")
  default:
      print("Not on an axis")
  }
  ```

  

## 3.0 控制转移

- continue 
- break 
- fallthrough
- return 
- throw

### 3.1 continue

- continue 语句告诉循环停止正在做的事情并且再次从头开始循环的下一次遍历。它是说“我 不再继续当前的循环遍历了”而不是离开整个的循环。

### 3.2 break

- break 语句会立即结束整个控制流语句。当你想要提前结束 switch 或者循环语句或者其他情 况时可以在 switch 语句或者循环语句中使用 break 语句。
- 当在循环语句中使用时，break 会立即结束循环的执行，并且转移控制到循环结束花括号( } )后的第一行代码上。当前遍历循环里的其他代码都不会被执行，并且余下的遍历循环也 不会开始了。
- 当在 switch 语句里使用时， break 导致 switch 语句立即结束它的执行，并且转移控制到 switch 语句结束花括号( } )之后的第一行代码上。

### 3.3 fallthrough

- 如果你确实需要 C 或者 Objective-C 风格的贯穿行为，你可以选择在 switch 每个 case 末尾 使用 fallthrough 关键字。

  ```swift
  let number = 5
  var description = "the number \(number) is"
  switch number {
  case 2, 3, 5, 7, 11, 13, 17, 19:
      description += " a prime number, and also"
      fallthrough
  default:
      description += " an integer."
  }
  
  print(description)
  //the number 5 is a prime number, and also an integer.
  ```

### 3.4 语句标签

- 可以用语句标签来给循环语句或者条件语句做标记。在一个条件语句中，你可以使用一个语句 标签配合 break 语句来结束被标记的语句。在循环语句中，你可以使用语句标签来配合 break 或者 continue 语句来结束或者继续执行被标记的语句。

## 4.0 guard 和检查 API 可用性

### 4.1 guard

- guard 语句，类似于 if 语句，基于布尔值表达式来执行语句。使用 guard 语句来要求一个条 件必须是真才能执行 guard 之后的语句。与 if 语句不同，guard 语句总是有一个 else 分句 — else 分句里的代码会在条件不为真的时候执行。

- ```swift
  func checkIPAddress(ip: String) -> (Int, String) {
      let compoments = ip.split(separator: ".")
      
      guard compoments.count == 4 else {
          return (100, "the ip address must has four compoments")
      }
      
      guard let first = Int(compoments[0]), first >= 0 && first < 256 else {
          return (1, "the first compoment is wrong")
      }
      
      guard let second = Int(compoments[1]), second >= 0 && second < 256 else {
          return (2, "the second compoment is wrong")
      }
      
      guard let third = Int(compoments[2]), third >= 0 && third < 256 else {
          return (3, "the third compoment is wrong")
      }
      
      guard let four = Int(compoments[3]), four >= 0 && four < 256 else {
          return (4, "the four compoment is wrong")
      }
      
      return (0, "")
  }
  
  print(checkIPAddress(ip: "127.0.0.-1"))
  //(4, "the four compoment is wrong")
  ```

  

### 4.2 检查 API 的可用性

- Swift 拥有内置的对 API 可用性的检查功能，它能够确保你不会悲剧地使用了对部属目标不可 用的 API。
- 你可以在 if 或者 guard 语句中使用一个可用性条件来有条件地执行代码，基于在运行时你想 用的哪个 API 是可用的。

## 5.0 模式和模式匹配

### 5.1 模式

- 模式代表单个值或者复合值的结构。
- 例如，元组 (1, 2) 的结构是由逗号分隔的，包含两个元素的列表。因为模式代表一种值的结 构，而不是特定的某个值，你可以利用模式来匹配各种各样的值。比如，(x, y) 可以匹配元 组 (1, 2)，以及任何含两个元素的元组。除了利用模式匹配一个值以外，你可以从复合值中提 取出部分或全部值，然后分别把各个部分的值和一个常量或变量绑定起来。

### 5.2 模式分类

- Swift 中的模式分为两类:一种能成功匹配任何类型的值，另一种在运行时匹配某个特定值时 可能会失败。
  - 第一类模式用于解构简单变量、常量和可选绑定中的值。此类模式包括通配符模式、标识符模式，以及包含前两种模式的值绑定模式和元组模式。你可以为这类模式指定一个类型标注，从而限制它们只能匹配某种特定类型的值。
  - 第二类模式用于全模式匹配，这种情况下你试图匹配的值在运行时可能不存在。此类模式 包括枚举用例模式、可选模式、表达式模式和类型转换模式。你在 switch 语句的 case 标 签中，do 语句的 catch 子句中，或者在 if、while、guard 和 for-in 语句的 case 条件句 中使用这类模式。

- 模式有如下几种分类：
  - 通配符模式(Wildcard Pattern)
  - 标识符模式(Identifier Pattern)
  - 值绑定模式(Value-Binding Pattern)
  - 元组模式(Tuple Pattern)
  - 枚举用例模式(Enumeration Case Pattern)
  - 可选项模式(Optional Pattern)
  - 类型转换模式(Type-Casting Pattern)
  - 表达式模式(Expression Pattern)

#### 5.2.1 通配符模式(Wildcard Pattern)

- 通配符模式由一个下划线(_)构成，用于匹配并忽略任何值。当你想忽略被匹配的值时可以 使用该模式。

- ```swift
  for _ in 1...3 {
      //todo
  }
  ```

#### 5.2.2 标识符模式(Identifier Pattern)

- 标识符模式匹配任何值，并将匹配的值和一个变量或常量绑定起来。

- ```swift
  let someValue = 42
  ```

#### 5.2.3 值绑定模式(Value-Binding Pattern)

- 值绑定模式把匹配到的值绑定给一个变量或常量。把匹配到的值绑定给常量时，用关键字 let，绑定给变量时，用关键字 var。

- ```swift
  let point = (3, 2)
  switch point {
  // 将 point 中的元素绑定到 x 和 y
  case let (x, y):
      print("The point is at (\(x), \(y))")
  }
  ```

#### 5.2.4 元组模式(Tuple Pattern)

- 元组模式是由逗号分隔的，具有零个或多个模式的列表，并由一对圆括号括起来。元组模式匹配相应元组类型的值。

- 你可以使用类型标注去限制一个元组模式能匹配哪种元组类型。例如，在常量声明 let (x, y): (Int, Int) = (1, 2) 中的元组模式 (x, y): (Int, Int) 只匹配两个元素都是 Int 类型的元组。

- 当元组模式被用于 for-in 语句或者变量和常量声明时，它仅可以包含通配符模式、标识符模式、可 选模式或者其他包含这些模式的元组模式。

- ```swift
  let points = [(0, 0), (1, 0), (1, 1), (2, 0), (2, 1)]
  for (x, y) in points where y == 0 {
      print("(\(x), \(y))")
  }
  //(0, 0)
  //(1, 0)
  //(2, 0)
  ```

#### 5.2.5 枚举用例模式(Enumeration Case Pattern)

- 枚举用例模式匹配现有的某个枚举类型的某个用例。枚举用例模式出现在 switch 语句中的 case 标签中，以及 if、while、guard 和 for-in 语句的 case 条件中。

#### 5.2.6 可选项目模式(Optional Pattern)

- 可选项模式匹配 Optional<Wrapped> 枚举在 some(Wrapped) 中包装的值。

- ```swift
  let someOptional: Int? = 42
  //方式1
  if case .some(let x) = someOptional {
      print(x)
  }
  
  //方式2
  if case let x? = someOptional {
      print(x)
  }
  ```

- 可选项目模式为 for-in 语句提供了一种迭代数组的简便方式，只为数组中非 nil 的元素执行循 环体。

- ```swift
  let someOptionals: [Int?] = [nil, 2, 3, nil, 5]
  for case let numbser? in someOptionals {
      print("Found a \(numbser)")
  }
  //Found a 2
  //Found a 3
  //Found a 5
  ```

#### 5.2.7 类型转换模式(Type-Casting Pattern)

- 有两种类型转换模式，is 模式和 as 模式。is 模式只出现在 switch 语句中的 case 标签中。is 模式和 as 模式形式如下:
  - is 类型
  - 模式 as 类型
- is 模式仅当一个值的类型在运行时和 is 模式右边的指定类型一致，或者是其子类的情况下， 才会匹配这个值。is 模式和 is 运算符有相似表现，它们都进行类型转换，但是 is 模式没有返回类型。
- as 模式仅当一个值的类型在运行时和 as 模式右边的指定类型一致，或者是其子类的情况下， 才会匹配这个值。如果匹配成功，被匹配的值的类型被转换成 as 模式右边指定的类型。

```swift
protocol Animal {
    var name: String { get }
}

struct Dog: Animal {
    var name: String {
        return "dog"
    }
    var runSpeed: Int
}

struct Bird: Animal {
    var name: String {
        return "bird"
    }
    var flightHeight: Int
}

struct Fish: Animal {
    var name: String {
        return "fish"
    }
    var depth: Int
}

let animals: [Any] = [Dog(runSpeed: 55), Bird(flightHeight: 2000), Fish(depth: 100)]

for animal in animals {
    switch animal {
    case let dog as Dog:
        print("\(dog.name) can run \(dog.runSpeed)")
    case let fish as Fish:
        print("\(fish.name) can dive depth \(fish.depth)")
    case is Bird:
        print("bird can fly!")
    default:
        print("unknown animal!")
    }
}
```

#### 5.2.8 表达式模式(Expression Pattern)

- 表达式模式代表表达式的值。表达式模式只出现在 switch 语句中的 case 标签中。

- 表达式模式代表的表达式会使用 Swift 标准库中的 ~= 运算符与输入表达式的值进行比较。如 果 ~= 运算符返回 true，则匹配成功。默认情况下，~= 运算符使用 == 运算符来比较两个相 同类型的值。它也可以将一个整型数值与一个 Range 实例中的一段整数区间做匹配。

  ```swift
  let point = (1, 2)
  switch point {
  case (0, 0):
      print("(0, 0) is at the origin.")
  case (-2...2, -2...2):
      print("(\(point.0), \(point.1)) is near the origin.")
  default:
      print("the point is at (\(point.0), \(point.1))")
  }
  //(1, 2) is near the origin.
  ```

- 可以重载 ~= 运算符来提供自定义的表达式匹配行为

- ```swift
  let point = (0, 0)
  
  func ~= (pattern: String, value: Int) -> Bool {
      return pattern == "\(value)"
  }
  
  switch point {
  case ("0", "0"):
      print("(0, 0) is at the origin.")
  case (-2...2, -2...2):
      print("(\(point.0), \(point.1)) is near the origin.")
  default:
      print("the point is at (\(point.0), \(point.1))")
  }
  //(0, 0) is at the origin.
  ```

- 自定义类型默认也是无法进行表达式模式匹配的，也需要重载 ~= 运算符。

- ```swift
  struct Employee {
      var salary: Float
  }
  
  let e = Employee(salary: 45000)
  
  func ~= (lhs: Range<Float>, rhs: Employee) -> Bool {
      return lhs.contains(rhs.salary)
  }
  
  switch e {
  case 0.0..<10000:
      print("艰难生活")
  case 10000..<30000:
      print("小康生活")
  case 30000..<50000:
      print("活得很滋润")
  default:
      break
  }
  //活得很滋润
  ```

  
# Swift学习笔记7—面向对象编程

## 1. Swift面向对象概述

### 1.1 面向对象的三大特性

- 继承 
- 封装 
- 多态

### 1.2 基本单元

- 枚举
- 结构体 
- 类 
- 协议 
- 扩展

### 1.3 面向对象概述

- 从整体的功能上看 Swift 的枚举、结构体、类三者具有完全平等的地位。
- Swift 的类、结构体、枚举中都可以定义(属性、方法、下标、构造体、嵌套类型)。 
- 在 Swift 中，枚举和结构体是值类型的，类是引用类型。

### 1.4 类和结构体相似点

- 定义属性用来存储值;
- 定义方法用于提供功能;
- 定义下标脚本用来允许使用下标语法访问值;
- 定义初始化器用于初始化状态;
- 可以被扩展来默认所没有的功能;
- 遵循协议来针对特定类型提供标准功能。

### 1.5 类和结构体不同点

- 继承允许一个类继承另一个类的特征;
- 类型转换允许你在运行检查和解释一个类实例的类型;
- 反初始化器允许一个类实例释放任何其所被分配的资源;
- 引用计数允许不止一个对类实例的引用。

## 2. 枚举从此站起来了

### 2.1 枚举语法

- 用 enum 关键字来定义一个枚举，然后将其所有的定义内容放在一个大括号({})中；
- 多个成员值可以出现在同一行中，要用逗号隔开。

```swift
enum CompassPoint {
    case north
    case sourth
    case east
    case west
}
```

- 每个枚举都定义了一个全新的类型。正如 Swift 中其它的类型那样，它们的名称(例如: CompassPoint)需要首字母大写。给枚举类型起一个单数的而不是复数的名字，从而使得它们能够顾名思义。

### 2.2 使用 switch 语句来匹配枚举值

- 你可以用 switch 语句来匹配每一个单独的枚举值。

- ```swift
  enum CompassPoint {
      case north, sourth, east, west
  }
  
  let direction = CompassPoint.north
  switch direction {
  case .north:
      print("北")
  case .sourth:
      print("南")
  case .east:
      print("东")
  case .west:
      print("西")
  }
  ```

### 2.3 遍历枚举的 case

- 对于某些枚举来说，如果能有一个集合包含了枚举的所有情况就好了。你可以通过在枚举名字 后面写 : `CaseIterable` 来允许枚举被遍历。Swift 会暴露一个包含对应枚举类型所有情况的集 合名为 allCases。

  ```swift
  //遍历枚举，需要遵循 CaseIterable 协议
  enum CompassPoint: CaseIterable {
      case north
      case sourth
      case east
      case west
  }
  print(CompassPoint.allCases)
  ```

### 2.4 枚举的关联值

- 可以定义 Swift 枚举来存储任意给定类型的关联值，如果需要的话不同枚举成员关联值的类型 可以不同。

```swift
//枚举的关联值
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productCode = Barcode.upc(1, 2, 3, 4)
print(productCode)//upc(1, 2, 3, 4)
```

- 绑定关联值。

```swift
//绑定关联值
switch productCode {
case .upc(let a, let b, let c, let d):
    print("upc:\(a)-\(b)-\(c)-\(d)")
case .qrCode(let code):
    print("qrCode:\(code)")
}
```



### 2.5 枚举的原始值

- 枚举成员可以用相同类型的默认值预先填充(称为原始值)。

```swift
//预设值
enum ControlCharacter: String {
    case tab = "\t"
    case line = "\n"
}
print(ControlCharacter.tab.rawValue)
```

- 预设原始值

  - 当你在操作存储整数或字符串原始值枚举的时候，你不必显式地给每一个成员都分配一个原始 值。当你没有分配时，Swift 将会自动为你分配值。

  ```swift
  enum CompassPoint: Int {
      case north = 5
      case sourth
      case east
      case west
  }
  print(CompassPoint.east.rawValue)
  ```

### 2.6 从原始值初始化枚举

- 如果你用原始值类型来定义一个枚举，那么枚举就会自动收到一个可以接受原始值类型的值的 初始化器(叫做 rawValue 的形式参数)然后返回一个枚举成员或者 nil 。你可以使用这个初始 化器来尝试创建一个枚举的新实例。

```swift
//使用原始值创建/初始化枚举
enum CompassPoint: Int {
     case north = 5
     case sourth
     case east
     case west
}
let direction = CompassPoint(rawValue: 6)
print(direction)//sourth
let direction2 = CompassPoint(rawValue: 9)
print(direction2)//nil
```

### 2.7 递归枚举

- 递归枚举是拥有另一个枚举作为枚举成员关联值的枚举。当编译器操作递归枚举时必须插入间 接寻址层。你可以在声明枚举成员之前使用 indirect 关键字来明确它是递归的。
  - 如说表达式(5 + 4) * 2 在乘法右侧有一个数但有其他表达式在乘法的左侧。

```swift
//递归枚举
indirect enum ArithmeticExpression {
    case number(Int)
    case add(ArithmeticExpression, ArithmeticExpression)
    case mutiply(ArithmeticExpression, ArithmeticExpression)
}

let firstExpression = ArithmeticExpression.number(5)
let secondExpression = ArithmeticExpression.number(4)
let addExpression = ArithmeticExpression.add(firstExpression, secondExpression)
let thirdExpression = ArithmeticExpression.number(2)
let mutiplyExpression = ArithmeticExpression.mutiply(addExpression, thirdExpression)

func eval(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case .number(let num):
        return num
    case .add(let first, let second):
        return eval(first) + eval(second)
    case .mutiply(let first, let second):
        return eval(first) * eval(second)
    }
}

print(eval(mutiplyExpression))
```

## 3. 如何为类、结构体、枚举添加属性

### 3.1 存储属性

- 在其最简单的形式下，存储属性是一个作为特定类和结构体实例一部分的常量或变 量。存储属性要么是变量存储属性(由 var 关键字引入)要么是常量存储属性(由 let 关键字引入)。

- 常量结构体实例的存储属性：

  - 如果你创建了一个结构体的实例并且把这个实例赋给常量，你不能修改这个实例的
    属性，即使是声明为变量的属性。

- 延迟存储属性：

  - 延迟存储属性的初始值在其第一次使用时才进行计算。你可以通过在其声明前标注 lazy 修 饰语来表示一个延迟存储属性。
  - 如果被标记为 lazy 修饰符的属性同时被多个线程访问并且属性还没有被初始化，则无法保 证属性只初始化一次。

  ```swift
  //延迟存储属性
  class DataImporter {
      var fileName = "data.txt"
      init() {
          print("DataImporter inits")
      }
  }
  
  class DataManager {
      lazy var importer = DataImporter()
      var data = [String]()
  }
  
  let manager = DataManager()
  manager.data.append("some data")
  manager.data.append("more data")
  print("manager.data.append finish")
  print(manager.importer.fileName)
  
  //manager.data.append finish
  //DataImporter inits
  //data.txt
  ```

### 3.2 计算属性

- 除了存储属性，类、结构体和枚举也能够定义计算属性，而它实际并不存储值。相反，它提供
  一个读取器和一个可选的设置器来间接得到和设置其它的属性和值。
- 简写 setter:
  - 如果一个计算属性的设置器没有为将要被设置的值定义一个名字，那么它将被默认命名为 newValue 。
- 简写 getter:
  - 如果整个 getter 的函数体是一个单一的表达式，那么 getter 隐式返回这个表达式。

```swift
//为结构体添加属性
struct Point {
    var x = 0
    var y = 0
}
struct Size {
    var width = 0
    var height = 0
}
struct Rect {
    var origin: Point
    var size: Size

    var center: Point {
        get {
            Point(x: origin.x + size.width, y: origin.y + size.height)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }
}
```

### 3.3 只读计算属性

- 一个有读取器但是没有设置器的计算属性就是所谓的只读计算属性。只读计算属性返回一个
  值，也可以通过点语法访问，但是不能被修改为另一个值。
- 你必须用 var 关键字定义计算属性(包括只读计算属性)为变量属性，因为它们的值不是固 定的。 let 关键字只用于常量属性，用于明确那些值一旦作为实例初始化就不能更改。

```swift
struct Rect {
    var origin: Point
    var size: Size

    var center: Point {
        return Point(x: origin.x + size.width, y: origin.y + size.height)
    }
}
```

## 4. 如何为类、结构体、枚举添加属性观察者

- willSet 会在该值被存储之前被调用。
- didSet 会在一个新值被存储后被调用。
- 如果你实现了一个 willSet 观察者，新的属性值会以常量形式参数传递。你可以在你的 willSet 实现中为这个参数定义名字。如果你没有为它命名，那么它会使用默认的名字 newValue 。
- 如果你实现了一个 didSet 观察者，一个包含旧属性值的常量形式参数将会被传递。你可以为 它命名，也可以使用默认的形式参数名 oldValue 。如果你在属性自己的 didSet 观察者里给 自己赋值，你赋值的新值就会取代刚刚设置的值。

```swift
//属性观察器
class Stepcounter {
    var totalSteps: Int = 0 {
        willSet {
            print(newValue)
        }

        didSet {
            print(oldValue)
        }
    }
}

var counter = Stepcounter()
counter.totalSteps = 100
counter.totalSteps = 360
counter.totalSteps = 812
```

- 全局和局部变量:
  - 观察属性的能力同样对全局变量和局部变量有效。全局变量是定义在任何函数、方法、闭包
    或者类型环境之外的变量。局部变量是定义在函数、方法或者闭包环境之中的变量。

```swift
//为全局变量添加属性观察器
var count: Int = 0 {
    willSet {
        print(newValue)
    }
    didSet {
        print(oldValue)
    }
}
count = 100
count = 200
```



## 5. 如何为类、结构体、枚举添加类型属性

- 使用 static 关键字来定义类型属性。对于类类型的计算类型属性，你可以使用 class 关键字 来允许子类重写父类的实现。

```swift
//类型属性
class SomeClass {
    static var storedTypeProperty = "some Value"
    static var computedTypeProperty: Int {
        return 27
    }
    class var overideableComputedTypeProperty: Int {
        return 108
    }
}

class Class2: SomeClass {
    override class var overideableComputedTypeProperty: Int {
        return 220
    }
}

print(Class2.overideableComputedTypeProperty)//220
```

## 6. 如何为类、结构体、枚举添加方法

### 6.1 实例方法

- 实例方法是属于特定类实例、结构体实例或者枚举实例的函数。他们为这些实例提供功能
  性，要么通过提供访问和修改实例属性的方法，要么通过提供与实例目的相关的功能。

```swift
//为结构体添加实例方法
struct Point {
    var x = 0
    var y = 0

    func prinInfo() {
        print(x, y)
    }
}

let p = Point.init(x: 1, y: 2)
p.prinInfo()
```

#### 6.1.1 实例方法 与 self

- 每一个类的实例都隐含一个叫做 self 的属性，它完完全全与实例本身相等。你可以使用 self 属性来在当前实例当中调用它自身的方法。
- 实际上，你不需要经常在代码中写 self。如果你没有显式地写出 self，Swift 会在你于方法中 使用已知属性或者方法的时候假定你是调用了当前实例中的属性或者方法。
- 例外就是当一个实例方法的形式参数名与实例中某个属性拥有相同的名字的时候。在这种情 况下，形式参数名具有优先权，并且调用属性的时候使用更加严谨的方式就很有必要了。你 可以使用 self 属性来区分形式参数名和属性名。

#### 6.1.2 在实例方法中修改属性

- 结构体和枚举是值类型。默认情况下，值类型属性不能被自身的实例方法修改。
- 你可以选择在 func 关键字前放一个 mutating 关键字来指定方可以修改属性。

```swift
//为结构体添加异变方法
struct Point {
    var x = 0
    var y = 0

    mutating func moveby(x: Int, y: Int) {
       self.x += x//修改属性
       self.y += y//修改属性
    }
}

var p = Point.init(x: 0, y: 0)
p.moveby(x: 2, y: 2)
print(p.x)
print(p.y)
```

- 在 mutating 方法中赋值给 self:
  - Mutating 方法可以指定整个实例给隐含的 self 属性

```swift
//为结构体添加异变方法
struct Point {
    var x = 0
    var y = 0

    mutating func moveby(x: Int, y: Int) {
        self = Point.init(x: self.x + x, y: self.y + y)//在 mutating 方法中赋值给 self
    }
}

var p = Point.init(x: 0, y: 0)
p.moveby(x: 2, y: 2)
print(p.x)
print(p.y)
```

#### 6.1.3 枚举的 mutating 方法

- 枚举的异变方法可以设置隐含的 self 属性为相同枚举里的不同成员。

```swift
enum TriStateSwitch {
    case off, low, high
    
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

var ovenLight = TriStateSwitch.low
print(ovenLight.next())//high
print(ovenLight.next())//off
```



### 6.2 类型方法

- 通过在 func 关键字之前使用 static 关键字来明确一个类型方法。类同样可以使用 class 关键 字来允许子类重写父类对类型方法的实现。

```swift
struct Point {
    var x = 0
    var y = 0

    static func printTypePoint() {
        print("A Point")
    }
}
Point.printTypePoint()//使用类型名字直接调用方法名
```



## 7. 如何为类、结构体、枚举添加下标

- 类、结构体和枚举可以定义下标，它可以作为访问集合、列表或序列成员元素的快捷方式。你
  可使用下标通过索引值来设置或检索值而不需要为设置和检索分别使用实例方法。
- 你可以为一个类型定义多个下标，并且下标会基于传入的索引值的类型选择合适的下标重载使
  用。下标没有限制单个维度，你可以使用多个输入形参来定义下标以满足自定义类型的需求。

### 7.1 下标语法

- 下标脚本允许你通过在实例名后面的方括号内写一个或多个值对该类的实例进行查询。它的 语法类似于实例方法和计算属性。使用关键字 subscript 来定义下标，并且指定一个或多个 输入形式参数和返回类型，与实例方法一样。与实例方法不同的是，下标可以是读写也可以 是只读的。

```swift
struct TimeTable {
    let multiplier: Int
    subscript (index: Int) -> Int {
        return multiplier * index
    }
}

let threeTimesTable = TimeTable(multiplier: 3)
print(threeTimesTable[6])//18
```

### 7.2 下标参数

- 下标可以接收任意数量的输入形式参数，并且这些输入形式参数可以是任意类型。下标也可
  以返回任意类型。**下标可以使用变量形式参数和可变形式参数，但是不能使用输入输出形式**
  **参数或提供默认形式参数值**。

```swift
//为结构体添加下标操作
struct Matrix {
    var rows: Int
    var columns: Int
    var grid: [Double]

    init(rows: Int, columns: Int) {
        self.rows = rows;
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }

    subscript(row: Int, columns: Int) -> Double {
        get {
            return grid[row * columns + columns]
        }
        set {
            grid[row * columns + columns] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[1, 0] = 9.9
matrix[0, 1] = 8.8
print(matrix[1, 0])
print(matrix[0, 1])
```

### 7.3 类型下标

- 实例下标，如果上文描述的那样，你在对应类型的实例上调用下标。你同样也可以定义类型 本身的下标。这类下标叫做类型下标。你可通过在 subscript 关键字前加 static 关键字来标 记类型下标。在类里则使用 class 关键字，这样可以允许子类重写父类的下标实现。

```swift
//为结构体添加类型下标
enum CompassPoint: Int {
    case north = 1
    case sourth
    case east
    case west

    static subscript(index: Int) -> CompassPoint {
        get {
            return CompassPoint(rawValue: index)!
        }
    }
}

let direction = CompassPoint[2]
print(direction)
```

## 8.如何进行类的初始化和反初始化

### 8.1 初始化器

- 初始化器在创建特定类型的实例时被调用。

```swift
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}

var f = Fahrenheit()
print(f.temperature)//32.0
```

- 默认的属性值
  - 如上所述，你可以在初始化器里为存储属性设置初始值。另外，指定一个默认属性值作为属
    性声明的一部分。当属性被定义的时候你可以通过为这个属性分配一个初始值来指定默认的
    属性值。

```swift
struct Fahrenheit {
    var temperature = 32.0
}

var f = Fahrenheit()
print(f.temperature)//32.0
```

### 8.2 默认的初始化器

- Swift 为所有没有提供初始化器的结构体或类提供了一个默认的初始化器来给所有的属性提供 了默认值。这个默认的初始化器只是简单地创建了一个所有属性都有默认值的新实例。

```swift
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}

var item = ShoppingListItem()
print(item.name ?? "默认值为nil")//默认值为nil
```

### 8.3 自定义初始化

- 可以提供初始化形式参数作为初始化器的一部分，来定义初始化过程中的类型和值的名称。
  初始化形式参数与函数和方法的形式参数具有相同的功能和语法。

```swift
struct Celsius {
    var temperatureInCelsius: Double
    
    init(fromFarenheit fatenheit: Double) {
        temperatureInCelsius  = (fatenheit - 32.0) / 1.8
    }
    
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFarenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
```

### 8.4 在初始化中分配常量属性

- 在初始化的任意时刻，你都可以给常量属性赋值，只要它在初始化结束是设置了确定的值即
  可。一旦为常量属性被赋值，它就不能再被修改了。

```swift
class SurveyQuestion {
    let text: String
    var respons: String?
    
    init(text: String) {
        self.text = text
    }
    
    func ask() {
        print(text)
    }
}

let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.respons = "I also like beets."
```

### 8.5 结构体的成员初始化器

- 如果结构体类型中没有定义任何自定义初始化器，它会自动获得一个成员初始化器。不同于
  默认初始化器，结构体会接收成员初始化器即使它的存储属性没有默认值。

```swift
struct Fahrenheit {
    var temperature: Double
}

var f = Fahrenheit(temperature: 32.0)
print(f.temperature)//32.0
```

### 8.6 值类型的初始化器委托

- 初始化器可以调用其他初始化器来执行部分实例的初始化。这个过程，就是所谓的初始化器
  委托，避免了多个初始化器里冗余代码。

```swift
struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
```

### 8.7 类的继承和初始化

- 所有类的存储属性(包括从它的父类继承的所有属性)都必须在初始化期间分配初始值。
- Swift 为类类型定义了两种初始化器以确保所有的存储属性接收一个初始值。这些就是所谓的指定初始化器和便捷初始化 器。 
- 指定初始化器是类的主要初始化器。指定的初始化器可以初始化所有那个类引用的属性并且调用合适的父类初始化器来继续这个初始化过程给父类链。
- 类偏向于少量指定初始化器，并且一个类通常只有一个指定初始化器。指定初始化器是初始化开始并持续初始化过程到父类链的“传送”点。
- 每个类至少得有一个指定初始化器。如同在初始化器的自动继承里描述的那样，在某些情况下，这些需求通过从父类继承一个或多个指定初始化器来满足。
- 便捷初始化器是次要的。你可以在相同的类里定义一个便捷初始化器来调用一个指定的初始化器作为便捷初始化器来给指定
- 初始化器设置默认形式参数。你也可以为具体的使用情况或输入的值类型定义一个便捷初始化器从而创建这个类的实例。
- 如果你的类不需要便捷初始化器你可以不提供它。在为通用的初始化模式创建快捷方式以节省时间或者类的初始化更加清晰明了的时候使用便捷初始化器。

#### 8.7.1 指定初始化器和便捷初始化器

- 用与值类型的简单初始化器相同的方式来写类的指定初始化器。

```swift
init(parameters) {
    statements
}
```

- 用 convenience 修饰符放到 init 关键字前定义便捷初始化器。

```swift
convenience init(parameters) {
    statements
}
```

#### 8.7.2 类的初始化委托

- 指定初始化器必须从它的直系父类调用指定初始化器。
- 便捷初始化器必须从相同的类里调用另一个初始化器。
- 便捷初始化器最终必须调用一个指定初始化器。

![](/Users/Brooks/blog/blogs/swift/page58image24519616.png) 

#### 8.7.3 两段式初始化

- Swift 的类初始化是一个两段式过程。在第一个阶段，每一个存储属性被引入类分配了一个初始值。 一旦每个存储属性的初始状态被确定，第二个阶段就开始了，每个类都有机会在新的实例准备使用之 前来定制它的存储属性。
- 两段式初始化过程的使用让初始化更加安全，同时在每个类的层级结构给与了完备的灵活性。两段式
  初始化过程可以防止属性值在初始化之前被访问，还可以防止属性值被另一个初始化器意外地赋予不
  同的值。

##### 8.7.3.1 安全检查

1. 指定初始化器必须保证在向上委托给父类初始化器之前，其所在类引入的所有属性都要初始化完 成。
2. 指定初始化器必须先向上委托父类初始化器，然后才能为继承的属性设置新值。如果不这样做， 指定初始化器赋予的新值将被父类中的初始化器所覆盖。
3. 便捷初始化器必须先委托同类中的其它初始化器，然后再为任意属性赋新值(包括同类里定义的 属性)。如果没这么做，便捷构初始化器赋予的新值将被自己类中其它指定初始化器所覆盖。
4. 初始化器在第一阶段初始化完成之前，不能调用任何实例方法、不能读取任何实例属性的值，也 不能引用 self 作为值。

```swift
class Person {
    var name: String
    var age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    convenience init() {
        self.init(name: "[Unnamed]", age: 0)
    }
}

class Teacher: Person {
    var salary: Double
    init(name: String, age: Int, salary: Double) {
        self.salary = salary
        super.init(name: name, age: age)
        self.name += "老师"
    }
    convenience init(name: String) {
        self.init(name: name, age: 30, salary: 5000)
    }
    
    func showInfo() {
        print(name, age, salary)
    }
}

let t = Teacher.init(name: "zhangsan")
t.showInfo()//zhangsan老师 30 5000.0
```

##### 8.7.3.2 两段式初始化过程-阶段1

![](/Users/Brooks/blog/blogs/swift/page66image24616464.png) 

8.7.3.3 两段式初始化过程-阶段2

1. 从顶部初始化器往下，链中的每一个指定初始化器都有机会进一步定制实例。初始化器现在 能够访问 self 并且可以修改它的属性，调用它的实例方法等等;
2. 最终，链中任何便捷初始化器都有机会定制实例以及使用 slef 。

![](/Users/Brooks/blog/blogs/swift/page67image24385840.png) 

#### 8.8 初始化器的继承和重写

- 不像在 Objective-C 中的子类，Swift 的子类不会默认继承父类的初始化器。Swift 的这种机 制防止父类的简单初始化器被一个更专用的子类继承并被用来创建一个没有完全或错误初始 化的新实例的情况发生。只有在特定情况下才会继承父类的初始化器。
- 如果你想自定义子类来实现一个或多个和父类相同的初始化器，你可以在子类中为那些初始
  化器提供定制的实现。
- 当你写的子类初始化器匹配父类指定初始化器的时候，你实际上可以重写那个初始化器。因此，在子类的初始化器定义之前你必须写 override 修饰符。如同默认初始化器所描述的那 样，即使是自动提供的默认初始化器你也可以重写。

#### 8.8.1 初始化器的自动继承

- 如果你的子类没有定义任何指定初始化器，它会自动继承父类所有的指定初始化器。
- 如果你的子类提供了所有父类指定初始化器的实现——要么是通过规则1继承来的，要么通过在定义中提供自定义实现的——那么它自动继承所有的父类便捷初始化器。

#### 8.9 可失败初始化器

- 定义类、结构体或枚举初始化时可以失败在某些情况下会管大用。这个失败可能由以下几种
  方式触发，包括给初始化传入无效的形式参数值，或缺少某种外部所需的资源，又或是其他
  阻止初始化的情况。
- 为了妥善处理这种可能失败的情况，在类、结构体或枚举中定义一个或多个可失败的初始化 器。通过在 init 关键字后面添加问号( init? )来写。

##### 8.9.1 可失败初始化器 init!

- 通常来讲我们通过在 init 关键字后添加问号 ( init? )的方式来定义一个可失败初始化器以创建 一个合适类型的可选项实例。另外，你也可以使用可失败初始化器创建一个隐式展开具有合 适类型的可选项实例。通过在 init 后面添加惊叹号( init! )是不是问号。

#### 8.10 必要初始化器

- 在类的初始化器前添加 required 修饰符来表明所有该类的子类都必须实现该初始化器。



#### 8.11 反初始化

- 在类实例被释放的时候，反初始化器就会立即被调用。你可以是用 deinit 关键字来写反初始 化器，就如同写初始化器要用 init 关键字一样。反初始化器只在类类型中有效。
- 反初始化器会在实例被释放之前自动被调用。你不能自行调用反初始化器。父类的反初始化
  器可以被子类继承，并且子类的反初始化器实现结束之后父类的反初始化器会被调用。父类
  的反初始化器总会被调用，就算子类没有反初始化器。
- 每个类当中只能有一个反初始化器。反初始化器不接收任何形式参数，并且不需要写圆括
  号。

```swift
deinit {
    //todo
}
```



## 9. 继承

### 9.1 定义基类

- 任何不从另一个类继承的类都是所谓的基类。
- Swift 类不会从一个通用基类继承。你没有指定特定父类的类都会以基类的形式创建。

### 9.2 子类

- 子类是基于现有类创建新类的行为。子类从现有的类继承了一些特征，你可以重新定义它
  们。你也可以为子类添加新的特征。
- 为了表明子类有父类，要把子类写在父类的前面，用冒号分隔。

### 9.3 访问父类的方法、属性和下标脚本

- 你可以通过super前缀访问父类的方法、属性或者下标。
  - 一个命名为 someMethod() 的重写方法可以通过 super.someMethod() 在重写方法的实现中调用父类版本的 someMethod() 方法；
  - 一个命名为 someProperty 的重写属性可以通过 super.someProperty 在重写的 getter 或 setter 实现中访问父类版本的 someProperty 属性；
  - 一个命名为 someIndex 的重写下标脚本可以使用 super[someIndex] 在重写的下标脚本 实现中访问父类版本中相同的下标脚本。

### 9.3 重写

- 子类可以提供它自己的实例方法、类型方法、实例属性，类型属性或下标脚本的自定义实
  现，否则它将会从父类继承。这就所谓的重写。
- 要重写而不是继承一个特征，你需要在你的重写定义前面加上 override 关键字。这样做说明 你打算提供一个重写而不是意外提供了一个相同定义。意外的重写可能导致意想不到的行 为，并且任何没有使用 override 关键字的重写都会在编译时被诊断为错误。

#### 9.3.1  重写方法

- 可以在的子类中重写一个继承的实例或类型方法来提供定制的或替代的方法实现。

```swift
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "\(currentSpeed)"
    }
    
    func makeNoise() {
        //todo
    }
}

class Train: Vehicle {
    override func makeNoise() {
        print("呜呼！呜呼")
    }
}

let t = Train()
t.makeNoise()
```

#### 9.3.2 重写属性的 getter 和 setter

- 可以提供一个自定义的 getter (和 setter，如果合适的话)来重写任意继承的属性，无论在最 开始继承的属性实现为储属性还是计算属性。

```swift
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "\(currentSpeed)"
    }
    
    func makeNoise() {
        //todo
    }
}

class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

let car = Car()
car.currentSpeed = 24.0
car.gear = 3
print("Car: \(car.description)")
```

#### 9.3.3 重写属性的观察器

- 可以使用属性重写来为继承的属性添加属性观察器。这就可以让你在继承属性的值改变时得到通知，无论这个属性最初如何实现。

  - 不能给继承而来的常量存储属性或者只读属性添加属性观察器。这些属性的值不能被设置，所以提供 willSet 或 didSet 实现作为重写的一部分也是不合适的。
  - 不能为同一个属性同事提供重写的 setter 和重写的属性观察器。如果你想要监听属性值的改变，并且你已经为那个属性提供了一个自定义的 setter，那么你从自定的 setter里就可以监听任意值的改变。

  ```swift
  class Car: Vehicle {
      var gear = 1
      override var description: String {
          return super.description + " in gear \(gear)"
      }
  }
  
  class AutomaticCar: Car {
      override var currentSpeed: Double {
          didSet {
              gear = Int(currentSpeed / 10.0) + 1
          }
      }
  }
  
  let automaticCar = AutomaticCar()
  automaticCar.currentSpeed = 35.0
  print("Car: \(automaticCar.description)")
  ```

#### 9.3.4 阻止重写

- 可以通过标记为 final 来阻止一个方法、属性或者下标脚本被重写。通过在方法、属性或者下 标脚本的关键字前写 final 修饰符(比如 final var ， final func ， final class func ， final subscript )。



## 10. 多态和类型转换

### 10.1 类型检查

- 使用类型检查操作符 ( is )来检查一个实例是否属于一个特定的子类。如果实例是该子类类 型，类型检查操作符返回 true ，否则返回 false 。

```swift
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let automaticCar = AutomaticCar()

let isU = automaticCar is AutomaticCar
let isU2 = automaticCar is Car

print("isU - \(isU)")//true
print("isU2 - \(isU2)")//true
```

### 10.2 向下类型转换

- 某个类类型的常量或变量可能实际上在后台引用自一个子类的实例。当你遇到这种情况时你 可以尝试使用类型转换操作符( as? 或 as! )将它向下类型转换至其子类类型。
- 由于向下类型转换可能失败，类型转换操作符就有了两个不同形式。条件形式， as? ，返回 了一个你将要向下类型转换的值的可选项。强制形式， as! ，则将向下类型转换和强制展开 结合为一个步骤。

```swift
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}

class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

let car = AutomaticCar()
let autoCat = car as? AutomaticCar
let autoCat2 = car as! AutomaticCar


print("car - \(car)")
print("autoCat - \(autoCat!)")
print("autoCat2 - \(autoCat)")
```

### 10.3 Any 和 AnyObject

- Swift 为不确定的类型提供了两种特殊的类型别名：
  - AnyObject 可以表示任何类类型的实例。
  - Any 可以表示任何类型，包括函数类型。

### 10.4 嵌套类型

- Swift 中的类，结构体和枚举可以进行嵌套，即在某一类型的内部定义类型，这种类型嵌套 在 Java 中称为内部类，在 C# 中称为嵌套类。
- 嵌套类型的能够访问它外部的成员。



## 11. 扩展 extension

- 扩展为现有的类、结构体、枚举类型、或协议添加了新功能。这也包括了为无访问权限的源代码扩展类
  型的能力(即所谓的逆向建模)。
- 扩展和 Objective-C 中的 category 类似。(与 Objective-C 的分类不同的是，Swift 的扩展没有名 字。)

### 11.1 extension 的能力

- 添加计算实例属性和计算类型属性;
- 定义实例方法和类型方法;
- 提供新初始化器;
- 定义下标;
- 定义和使用新内嵌类型;
- 使现有的类型遵循某协议
- <u>扩展可以向一个类型添加新的方法，但是不能重写已有的方法</u>。

#### 11.1.1 计算属性

- 扩展可以向已有的类型添加计算实例属性和计算类型属性。

```swift
extension Double {
    var km: Double {
        return self * 1000.0
    }
}

let oneInch = 25.4.km
print(oneInch)
```

#### 11.1.2 初始化器

- 扩展可向已有的类型添加新的初始化器。这允许你扩展其他类型以使初始化器接收你的自定义类型
  作为形式参数，或提供该类型的原始实现中未包含的额外初始化选项。
- 扩展能为类添加新的便捷初始化器，但是不能为类添加指定初始化器或反初始化器。指定初始化器 和反初始化器 必须由原来类的实现提供。

#### 11.1.3 方法

- 扩展可以为已有的类型添加新的实例方法和类型方法。

```swift
extension Int {
    func repetitions(tash: () -> Void) {
        for _ in 0..<self {
            tash()
        }
    }
}

3.repetitions {
    print("Hello!")
}
```

##### 11.1.3.1 mutating 方法

- 扩展的实例方法仍可以修改(或异变)实例本身。结构体和枚举类型方法在修改 self 或本身的 属性时必须标记实例方法为 mutating ，和原本实现的异变方法一样。

```swift
extension Int {
    mutating func square() {
        self = self * self
    }
}

var someInt = 3
someInt.square()
print(someInt)//9
```

#### 11.1.4 下标

- 扩展能为已有的类型添加新的下标。

#### 11.1.5 添加内嵌类型

- 扩展可以为已有的类、结构体和枚举类型添加新的内嵌类型。

```swift
extension Int {
    enum Kind {
        case negative, zero, positive
    }
    
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
        return .positive
        default:
            return .negative
        }
    }
}

print(2.kind)//positive
```



## 12. 协议 **protocol**

### 12.1 协议的语法

- 自定义类型声明时，将协议名放在类型名的冒号之后来表示该类型采纳一个特定的协议。多个
  协议可以用逗号分开列出。
- 若一个类拥有父类，将这个父类名放在其采纳的协议名之前，并用逗号分隔。

### 12.2 属性要求

- 协议可以要求所有遵循该协议的类型提供特定名字和类型的实例属性或类型属性。协议并不会具体说明属性是
  储存型属性还是计算型属性——它只具体要求属性有特定的名称和类型。协议同时要求一个属性必须明确是可
  读的或可读的和可写的。
- 若协议要求一个属性为可读和可写的，那么该属性要求不能用常量存储属性或只读计算属性来满足。若协议只
  要求属性为可读的，那么任何种类的属性都能满足这个要求，而且如果你的代码需要的话，该属性也可以是可
  写的。

```swift
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotToBeSettable: Int { get }
}
```

```swift
protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

var john = Person(fullName: "John Appleseed")
print(john.fullName)//按照协议必须可以访问 fullName
```

- 在协议中定义类型属性时在前面添加 static 关键字。当类的实现使用 class 或 static 关键字前 缀声明类型属性要求时，这个规则仍然适用。

```

```

### 12.3 方法要求

- 协议可以要求采纳的类型实现指定的实例方法和类方法。这些方法作为协议定义的一部分，书写方式
  与正常实例和类方法的方式完全相同，但是不需要大括号和方法的主体。允许变量拥有参数，与正常
  的方法使用同样的规则。但在协议的定义中，方法参数不能定义默认值。
- 正如类型属性要求的那样，当协议中定义类型方法时，你总要在其之前添加 static 关键字。即使在类 实现时，类型方法要求使用 class 或 static 作为关键字前缀，前面的规则仍然适用。

#### 12.3.1 mutating 方法要求

- 若你定义了一个协议的实例方法需求，想要异变任何采用了该协议的类型实例，只需在协议里 方法的定义当中使用 mutating 关键字。这允许结构体和枚举类型能采用相应协议并满足方法 要求。

### 12.4 初始化器要求

- 协议可以要求遵循协议的类型实现指定的初始化器。和一般的初始化器一样，只用将初始化器
  写在协议的定义当中，只是不用写大括号也就是初始化器的实体。

```swift
protocol SomeProtocol {
    init(parameter: Int)
}
```

#### 12.4.1 初始化器要求的类实现

- 你可以通过实现指定初始化器或便捷初始化器来使遵循该协议的类满足协议的初始化器要求。 在这两种情况下，你都必须使用 required 关键字修饰初始化器的实现。

```swift
protocol SomeProtocol {
    init(parameter: Int)
}

class SomeClass: SomeProtocol {
    required init(parameter: Int) {
        //todo
    }
}
```

- 如果一个子类重写了父类指定的初始化器，并且遵循协议实现了初始化器要求，那么就要为这 个初始化器的实现添加 required 和 override 两个修饰符。

```swift
protocol SomeProtocol {
    init()
}

class SomeClass {
    init() {
        //todo
    }
}

class SubClass: SomeClass, SomeProtocol {
    // 'required' 是遵循协议需要写的，'override' 是继承父类需要写的
    required override init() {
        //
    }
}
```

### 12.5 将协议作为类型

- 在函数、方法或者初始化器里作为形式参数类型或者返回类型;
- 作为常量、变量或者属性的类型;
- 作为数组、字典或者其他存储器的元素的类型。

### 12.6 协议继承

- 协议可以继承一个或者多个其他协议并且可以在它继承的基础之上添加更多要求。协议继承的
  语法与类继承的语法相似，只不过可以选择列出多个继承的协议，使用逗号分隔。

```swift
protocol Protocol_1 {
    func someFunc_1()
}

protocol Protocol_2 {
    func someFunc_2()
}

protocol Protocol_3: Protocol_1, Protocol_2 {
    func someFunc_3()
}
```



### 12.7 类专用的协议

- 通过添加 AnyObject 关键字到协议的继承列表，你就可以限制协议只能被类类型采纳(并且 不是结构体或者枚举)。

```swift
protocol SomeProtocol: AnyObject {
    //
}
```

### 12.8 协议组合

- 可以使用协议组合来复合多个协议到一个要求里。协议组合行为就和你定义的临时局部协议一样拥有构
  成中所有协议的需求。协议组合不定义任何新的协议类型。
- 协议组合使用 SomeProtocol & AnotherProtocol 的形式。你可以列举任意数量的协议，用和符号连接 ( & )，使用逗号分隔。除了协议列表，协议组合也能包含类类型，这允许你标明一个需要的父类。

```swift
protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)")
}

let p = Person(name: "zhangsan", age: 21)
wishHappyBirthday(to: p)
```

### 12.9 可选协议要求

- 你可以给协议定义可选要求，这些要求不需要强制遵循协议的类型实现。可选要求使用 optional 修饰符作为前缀放在协议的定义中。可选要求允许你的代码与 Objective-C 操作。 协议和可选要求必须使用 @objc 标志标记。注意 @objc 协议只能被继承自 Objective-C 类或 其他 @objc 类采纳。它们不能被结构体或者枚举采纳。



## 13. 协议 and 扩展

### 13.1 在扩展里添加协议遵循

- 你可以扩展一个已经存在的类型来采纳和遵循一个新的协议，就算是你无法访问现有类型的源
  代码也行。扩展可以添加新的属性、方法和下标到已经存在的类型，并且因此允许你添加协议
  需要的任何需要。

### 13.2 有条件地遵循协议

- 泛型类型可能只在某些情况下满足一个协议的要求，比如当类型的泛型形式参数遵循对应协议 时。你可以通过在扩展类型时列出限制让泛型类型有条件地遵循某协议。在你采纳协议的名字 后面写泛型 where 分句。

### 13.3 使用扩展声明采纳协议

- 如果一个类型已经遵循了协议的所有需求，但是还没有声明它采纳了这个协议，你可以让通过
  一个空的扩展来让它采纳这个协议。

### 13.4 协议扩展

- 协议可以通过扩展来提供方法和属性的实现以遵循类型。这就允许你在协议自身定义行为，而
  不是在每一个遵循或者在全局函数里定义。

```swift
//RandomNumberGenerator 是官方的 Protocol
extension RandomNumberGenerator {
    
    //为协增加扩展方法 randomBool
    func randomBool() -> Bool {
        return arc4random() % 2 == 0
    }
}

var generator = SystemRandomNumberGenerator()
print("number - \(generator.next())")
print("bool - \(generator.randomBool())")
```

#### 13.4.1 提供默认实现

- 你可以使用协议扩展来给协议的任意方法或者计算属性要求提供默认实现。如果遵循类型给这
  个协议的要求提供了它自己的实现，那么它就会替代扩展中提供的默认实现。

```swift
protocol Run {
    func run()
}

// 利用扩展为协议提供默认实现
extension Run {
    func run() {
        print("run...")
    }
}

struct Person: Run {
    var name: String
}

let p = Person(name: "zhangsan")
p.run()//run...
```

如果Person类提供了自己的协议实现，将会覆盖协议提供的默认实现，如下：

```swift
protocol Run {
    func run()
}

// 利用扩展为协议提供默认实现
extension Run {
    func run() {
        print("run...")
    }
}

struct Person: Run {
    var name: String
    func run() {
        print("\(name) run...")
    }
}

let p = Person(name: "zhangsan")
p.run()//zhangsan run...
```

### 13.5 给协议扩展添加限制

- 当你定义一个协议扩展，你可以明确遵循类型必须在扩展的方法和属性可用之前满足的限制。 在扩展协议名字后边使用 where 分句来写这些限制。

```swift
extension Collection where Iterator.Element: Hashable {
    //
}
```



## 14. 面向协议编程

- OOP
  - 几乎所有的编程语言都支持OOP，Java、Ruby等语言的设计理念中几乎将一切事物都看作对 象，对象即中心、对象即真理。
  - OOP 的缺陷:
    - 继承机制要求你在开始之前就能设计好整个程序的框架、结构、事物间的连接关系。这要求开发者 必须有很好的分类设计能力，将不同的属性和方法分配的合适的层次里面去。设计清晰明了的继承 体系总是很难的。 <u>(C++标准库不是面向对象的</u>)。
    - 结构天生对改动有抵抗特性。这也是为什么OOP领域中所有程序员都对重构讳莫如深，有些框架到 最后代码量急剧膨胀变得难以维护从而失控。(<u>修改行为比修改结构简单</u>)。
    - 继承机制带来的另一个问题就:很多语言都不提供多继承，我们不得不在父类塞入更多的内容，子 类中会存在无用的父类属性和方法，而这些冗余代码给子类带来的一定的风险，而且对于层级很深 的代码结构来说Bug修复将会成为难题。 (<u>组合优于继承</u>)。
    - 对象的状态不是我们的编码的好友，相反是我们的敌人。对象固有的状态在分享和传递过程中是很 难追踪调试的，尤其在并行程序编码中问题就更加明显。OOP 所带来的可变、不确定、复杂等特征 完全与并行编程中倡导的小型化、核心化、高效化完全背离。 (<u>值类型优于引用类型</u>)。
- POP
  - protocol oriented programming
- OOP vs POP
  - OOP - 主要关心对象是什么
  - POP - 主要关心对象做什么



<u>需求</u>：*如果一个人- Human，既是可能是田径队员- Runner、也可能是游泳队员- Swimmer、还可能是全能选手- AllAroundAthlete，怎样设计？*

一种 pop 实现方案如下：

```swift
/// 协议： 人
protocol Human {
    var name: String { get set}
    var age: Int { get set}
    
    func sayHi()
}

/// 协议： 赛跑技能
protocol Runnable {
    func run()
}


/// 协议： 游泳技能
protocol Swimming {
    func swim()
}


/// 田径队员
struct Runner: Human, Runnable {
    var name: String
    var age: Int

    func sayHi() {
        print("Hi, I'm \(name)")
    }

    func run() {
        print("run")
    }
}


/// 游泳队员
struct Swimmer: Human, Swimming {
    var name: String
    var age: Int

    func sayHi() {
        print("Hi, I'm \(name)")
    }

    func swim() {
        print("swim")
    }
}


/// 全能选手
struct AllAroundAthlete: Human, Runnable, Swimming {
    var name: String
    var age: Int

    func sayHi() {
        print("Hi, I'm \(name)")
    }

    func run() {
        print("run")
    }

    func swim() {
        print("swim")
    }
}

let all = AllAroundAthlete(name: "zhangsan", age: 30)
all.run()
all.swim()
all.sayHi()
```



或者，将人：Human 设计为 `class` 。 如下：

```swift
/// 类： 人
class Human {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func sayHi() {
        print("Hi, I'm \(name)")
    }
}

/// 协议： 赛跑技能
protocol Runnable {
    func run()
}


/// 协议： 游泳技能
protocol Swimming {
    func swim()
}


/// 田径队员
class Runner: Human, Runnable {
    func run() {
        print("run")
    }
}


/// 游泳队员
class Swimmer: Human, Swimming {
    func swim() {
        print("swim")
    }
}


/// 全能选手
class AllAroundAthlete: Human, Runnable, Swimming {
    func run() {
        print("run")
    }

    func swim() {
        print("swim")
    }
}

let all = AllAroundAthlete.init(name: "zhangsan", age: 30)
all.run()
all.swim()
all.sayHi()
```


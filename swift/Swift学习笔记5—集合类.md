# Swift学习笔记5—集合类

## 1. 数组 Array

### 1.1 在Swift中创建数组的N中方式

#### 1.1.1 字面量创建数组

- 可以使用数组字面量来初始化一个数组，它是一种以数组集合来写一个或者多个值的简写方式。数组字面量写做一系列的值，用逗号分隔，用方括号括起来。

  ```swift
  let array = [1, 2, 3, 4]
  ```

- 字面量创建空数组

  - 创建空数组的时候必须携带类型信息
  - 如果内容已经提供了类型信息，比如说作为函数的实际参数或者已经分类了的变量或常量，你可以通过空数组字面量来创建一个空数组

  ```swift
  let array1: [Int] = []
  let array2: [String] = []
  ```

#### 1.1.2 初始化器创建数组

- 使用初始化器有两种方式

  - [类型]()
  - Array<类型>()

  ```swift
  var array1 = [String]()
  var array2 = Array<String>()
  ```

- 初始化器参数

  - `init(repeating repeatedValue: Element, count: Int)`

    ```swift
    var array = Array.init(repeating: "name", count: 5)//重复某个元素N次并返回数组
    ```

    

  - `init(arrayLiteral elements: Element...)`

  - ```swift
    var array1 = Array.init(arrayLiteral: "A", "B", "C", "D")//依次将传入的元素填充进数组并返回数组
    ```

    

  - `init<S>(_ elements: S) where S : Sequence, Self.Element == S.Element`

  - ```swift
    let array1 = [Int](0...7)
    var array2 = Array.init(array1)
    ```

  - `init(from decoder: Decoder) throws`

### 1.2 数组-遍历和索引

#### 1.2.1 遍历

- for-In

- forEach方法

  - 无法使用 break 或 continue 跳出或者跳过循环
  - 使用 return 只能退出当前一次循环的执行体

  ```swift
  func todo() {
      let array1 = [Int](0...7)
      array1.forEach { (num) in
          if num == 3 {
              return
          }
          print(num)
      }
  }
  todo()
  //0
  //1
  //2
  //4
  //5
  //6
  //7
  ```

- 同时得到索引和值: enumerated()

  ```swift
  let array = ["zhangsan", "lisi", "wangwu"]
  for (index, num) in array.enumerated() {
      print("\(index):\(num)")
  }
  ```

- 使用 Iterator 遍历数组

  ```swift
  let array = [Int](0...7)
  var numIterator = array.makeIterator()
  while let num = numIterator.next() {
      print(num * 10)
  }
  ```

#### 1.2.2 索引

- startIndex 返回第一个元素的位置，对于数组来说，永远都是 0。

- endIndex 返回最后一个元素索引 +1 的位置，对于数组来说，等同于count 。

- 如果数组为空，startIndex 等于 endIndex 。

- indices 获取数组的索引区间

- ```swift
  let array = [Int](0...7)
  for i in array.indices {
      print(array[i] * 10)
  }
  ```

  

### 1.3 数组-查找操作

#### 1.3.1 判断是否包含指定元素

- contains(_:) 判断数组是否包含给定元素
- contains(where:) 判断数组是否包含符合给定条件的元素

```swift
let array = [Int](0...7)
print(array.contains(6))
print(array.contains(where: { (num: Int) -> Bool in
    if num % 2 == 0 {
        return false
    }
    return true
}))
```

#### 1.3.2 判断所有元素符合某个条件

- allSatisfy(_:) 判断数组的每一个元素都符合给定的条件

- ```swift
  let array = [10, 20, 30, 40]
  print(array.allSatisfy({ (num: Int) -> Bool in
      return num > 20
  }))//false
  print(array.allSatisfy({$0 >= 10}))//true
  ```

#### 1.3.3 查找元素

- first 返回数组第一个元素(optional)，如果数组为空，返回 nil 。
- last 返回数组最后一个元素(optional)，如果数组为空，返回 nil 。 
- first(where:) 返回数组第一个符合给定条件的元素(optional)。 
- last(where:) 返回数组最后一个符合给定条件的元素(optional)。

```swift
let array = [10, 20, 30, 40]
print(array.first)//Optional(10)
print(array.last)//Optional(40)
print(array.first(where: {$0 > 10}))//Optional(20)
print(array.last(where: {$0 < 40}))//Optional(30)
```

#### 1.3.4 查找索引

- firstIndex(of:) 返回给定的元素在数组中出现的第一个位置(optional)
- lastIndex(of:) 返回给定的元素在数组中出现的最后一个位置(optional)
- firstIndex(where:) 返回符合条件的第一个元素的位置(optional)
- lastIndex(where:) 返回符合条件的最后一个元素的位置(optional)

```swift
let array = [10, 20, 30, 70, 30, 20, 50]
print(array.firstIndex(of: 30))//Optional(2)
print(array.lastIndex(of: 20))//Optional(5)
print(array.lastIndex(where: {$0 > 60}))//Optional(3)
print(array.firstIndex(where: {$0 > 15}))//Optional(1)
```

#### 1.3.5 查找最大最小元素

- min() 返回数组中最小的元素
- max() 返回数组中最大的元素

```swift
let array = [10, 20, 30, 70, 30, 20, 50]
print(array.min())//Optional(10)
print(array.max())//Optional(70)
```

- min(by:) 利用给定的方式比较元素并返回数组中的最小元素 
- max(by:) 利用给定的方式比较元素并返回数组中的最大元素

```swift
let array = [(30, "error1"), (10, "error2"), (20, "error3")]
print(array.min(by: {a, b in a.0 < b.0}))//Optional((10, "error2"))
print(array.max(by: {a, b in a.0 < b.0}))//Optional((30, "error1"))
```



### 1.4 数组-添加和删除元素

#### 1.4.1 在末尾添加

- append(_:) 在末尾添加一个元素
- append(contentsOf: ) 在末尾添加多个元素

```swift
var array = [Int](0...3)
array.append(4)
array.append(contentsOf: 100...105)
```

#### 1.4.2 在任意位置插入

- insert(_:at:) 在指定的位置插入一个元素
- insert(contentsOf: at:) 在指定位置插入多个元素

```swift
var array = [Int](0...3)
array.insert(5, at: 1)
array.insert(contentsOf: 100...103, at: 2)
```

- 字符串也是 Collection ，Element 是 Character 类型。

  ```swift
  var array: [Character] = ["a", "b", "c"]
  array.insert(contentsOf: "hello", at: 0)
  print(array)//["h", "e", "l", "l", "o", "a", "b", "c"]
  ```

#### 1.4.3 移除单个元素

- remove(at:) 移除并返回指定位置的一个元素
- removeFirst() 移除并返回数组的第一个元素
- removeLast() 移除并返回数组的最后一个元素
- popLast() 移除并返回数组的最后一个元素(optional)，如果数组为空返回nil 。

```swift
var array: [Character] = ["a", "b", "c", "d"]
array.remove(at: 1)
array.removeFirst()
array.removeLast()
array.popLast()
```

#### 1.4.4移除多个元素

- removeFirst(:) 移除数组前面多个元素 
- removeLast(:) 移除数组后面多个元素

```swift
var array: [Character] = ["a", "b", "c", "d"]
array.removeFirst(2)
array.removeLast(2)
```

- removeSubrange(_:) 移除数组中给定范围的元素
- removeAll() 移除数组所有元素
- removeAll(keepingCapacity:) 移除数组所有元素，保留数组容量

```swift
var array: [Character] = ["a", "b", "c", "d"]
array.removeSubrange(1...2)
//array.removeAll()
array.removeAll(keepingCapacity: true)
```



### 1.5 ArraySlice

- ArraySlice 是数组或者其他 ArraySlice 的一段连续切片，和原数组共享内存。 
- 当要改变 ArraySlice 的时候，ArraySlice 会 copy 出来，形成单独内存。
-  ArraySlice 拥有和 Array 基本完全类似的方法

#### 1.5.1 通过 Drop 得到 ArraySlice

- dropFirst(:) “移除”原数组前面指定个数的元素得到一个 ArraySlice 
- dropLast(:) “移除”原数组后面指定个数的元素得到一个 ArraySlice 
- drop(:) “移除”原数组符合指定条件的元素得到一个 ArraySlice

```swift
let array = [5,2,10,1,0,100,46,99]
array.dropFirst()
array.dropFirst(3)
array.dropLast()
array.dropLast(3)
print(array.drop{$0 < 15})
```

#### 1.5.2 通过 prefix 得到 ArraySlice

- prefix() 获取数组前面指定个数的元素组成的 ArraySlice
- prefix(upTo: ) 获取数组到指定位置(不包含指定位置)前面的元素组成的 ArraySlice 
- prefix(through: ) 获取数组到指定位置(包含指定位置)前面的元素组成的 ArraySlice 
- prefix(while: ) 获取数组前面符合条件的元素(到第一个不符合条件的元素截止)组成的 ArraySlice

```swift
let array = [5,2,10,1,0,100,46,99]
array.prefix(4)
array.prefix(upTo: 4)
array.prefix(through: 4)
print(array.prefix(while: {$0 < 10}))
```

#### 1.5.3 通过 suffix 得到 ArraySlice

- suffix() 获取数组后面指定个数的元素组成的 ArraySlice
- suffix(from: ) 获取数组从指定位置到结尾(包含指定位置)的元素组成的 ArraySlice

```swift
let array = [5,2,10,1,0,100,46,99]
array.suffix(3)
array.suffix(from: 5)
```

#### 1.5.4 通过 Range 得到 ArraySlice

- 可以通过对数组下标指定 Range 获取 ArraySlice，可以使用闭区间、半开半闭区间、单侧区 间、甚至可以只使用 ... 来获取整个数组组成的 ArraySlice 。

```swift
let array = [5,2,10,1,0,100,46,99]
array[3...5]
array[3..<5]
array[...2]
array[..<2]
array[6...]
array[...]
```

#### 1.5.5 ArraySlice 转为 Array

- ArraySlice 无法直接赋值给一个 Array 的常量或变量，需要使用 Array(slice) 。

```swift
var array = [5,2,10,1,0,100,46,99]
let slice = array[3...5]
array = Array(slice)
```

#### 1.5.6 ArraySlice 和原 Array 相互独立

- ArraySlice 和原 Array 是相互独立的，它们添加删除元素不会影响对方.

  ```swift
  var array = [5,2,10]
  var slice = array.dropLast()
  array.append(333)
  print(slice)//[5, 2]
  slice.append(555)
  print(array)//[5, 2, 10, 333]
  ```

  

### 1.6 数组-重排操作

#### 1.6.1 数组元素的随机化

- shuffle() 在原数组上将数组元素打乱，只能作用在数组变量上。 
- shuffled() 返回原数组的随机化数组，可以作用在数组变量和常量上。

```swift
var array = [Int](1...8)
array.shuffle()
print(array)//[4, 7, 5, 2, 8, 3, 6, 1]

let array1 = [Int](1...8)
let array2 = array1.shuffled()
print(array2)//[2, 5, 7, 8, 3, 1, 4, 6]
```

#### 1.6.2 数组的逆序

- reverse() 在原数组上将数组逆序，只能作用在数组变量上。
- reversed() 返回原数组的逆序“集合表示”，可以作用在数组变量和常量上，该方法不 会分配新内存空间。

```
var array = [Int](1...8)
array.reverse()
print(array)//[8, 7, 6, 5, 4, 3, 2, 1]

let array1 = [Int](1...8)
let array2 = array1.reversed()
print(array2)// ReversedCollection<Array<Int>>(_base: [1, 2, 3, 4, 5, 6, 7, 8])
```

#### 1.6.3 数组的分组

- partition(by belongsInSecondPartition: (Element) throws -> Bool) 将数组以某个 条件分组，数组前半部分都是不符合条件的元素，数组后半部分都是符合条件的元素。

```swift
var array = [10,20,45,30,98,101,30,4]
let index = array.partition(by: {$0 > 30})
print(array)//[10, 20, 4, 30, 30, 101, 98, 45]
let partition1 = array[..<index]
let partition2 = array[index...]
print(partition1)//[10, 20, 4, 30, 30]
print(partition2)//[101, 98, 45]
```

#### 1.6.4 数组的排序

- sort() 在原数组上将元素排序，只能作用于数组变量。
- sorted() 返回原数组的排序结果数组，可以作用在数组变量和常量上。

```swift
var array = [10,20,45,30,98,101,30,4]
array.sort()
print(array)//[4, 10, 20, 30, 30, 45, 98, 101]

let array1 = [10,20,45,30,98,101,30,4]
let array2 = array1.sorted()
print(array2)//[4, 10, 20, 30, 30, 45, 98, 101]
```

#### 1.6.5 交换数组两个元素

- swapAt(_:_:) 交换指定位置的两个元素

```swift
var array = [1,7,5]
array.swapAt(0, 2)
print(array)//[5, 7, 1]
```

### 1.7 数组-拼接操作

- 字符串数组拼接
  - joined() 拼接字符串数组里的所有元素为一个字符串
  - joined(separator:) 以给定的分隔符拼接字符串数组里的所有元素为一个字符串

```swift
var array = ["Hello", "Swift"]
print(array.joined())
print(array.joined(separator: ","))
//HelloSwift
//Hello,Swift
```

- 元素为 Sequence 数组的拼接

  - joined() 拼接数组里的所有元素为一个更大的 Sequence

    ```swift
    let array = [0..<3, 8..<10, 15..<17]
    for range in array {
        print(range)
    }
    //0..<3
    //8..<10
    //15..<17
    
    for i in array.joined() {
        print(i)
    }
    //0
    //1
    //2
    //8
    //9
    //15
    //16
    ```

    

  - joined(separator:) 以给定的分隔符拼接数组里的所有元素为一个更大的 Sequence

    ```swift
    let array = [[1,2,3], [4,5,6], [7,8,9]]
    let joined = array.joined(separator: [-1, -2])
    print(Array(joined))//[1, 2, 3, -1, -2, 4, 5, 6, -1, -2, 7, 8, 9]
    ```



### 1.8 数组的底层实现探究

留个坑先~

### 1.9 如何使用数组来实现栈和队列

#### 1.9.1 Stack 栈

- 栈( Stack )是一种后入先出( Last in First Out )的数据结构，仅限定在栈顶进行插 入或者删除操作。栈结构的实际应用主要有数制转换、括号匹配、表达式求值等等。

  ![](/Users/Brooks/blog/blogs/swift/Stack.png)

  ```swift
  ///使用数组实现栈
  struct Stack<T> {
      private var elements = [T]()
      
      var conut: Int {
          return elements.count
      }
      
      var isEmpty: Bool {
          return elements.isEmpty
      }
      
      var peek: T? {
          return elements.last
      }
      
      mutating func push(_ element: T) {
          elements.append(element)
      }
      
      mutating func pop() ->T? {
          return elements.popLast()
      }
  }
  
  //test case
  var stack = Stack<Int>()
  stack.push(1)
  stack.push(3)
  stack.push(7)
  print(stack.pop() ?? 0)
  print(stack.conut)
  print(stack.peek!)
  
  ```

  

#### 1.9.2 Queue 队列

- 队列在生活中非常常见。排队等位吃饭、在火车站买票、通过高速路口等，这些生活中 的现象很好的描述了队列的特点:先进先出 ( FIFO, first in first out )，排在最前面的 先出来，后面来的只能排在最后面。

  ![Queue](/Users/Brooks/blog/blogs/swift/Queue.png)

  ```swift
  ///使用数组实现队列
  struct Queue<T> {
      private var elements = [T]()
      
      var conut: Int {
          return elements.count
      }
      
      var isEmpty: Bool {
          return elements.isEmpty
      }
      
      var peek: T? {
          return elements.first
      }
      
      mutating func enqueue(_ element: T) {
          elements.append(element)
      }
      
      mutating func dequeue() ->T? {
          return isEmpty ? nil : elements.removeFirst()
      }
  }
  
  //test case
  var  queue = Queue<Int>()
  queue.enqueue(1)
  queue.enqueue(3)
  queue.enqueue(7)
  print(queue.dequeue() ?? 0)
  print(queue.conut)
  print(queue.peek!)	
  ```

  

## 2. 集合 Set

- Set 是指具有某种特定性质的具体的或抽象的对象汇总而成的集体。其中，构成 Set 的 这些对象则称为该 Set 的元素。
- 集合的三个特性
  - 确定性 :给定一个集合，任给一个元素，该元素或者属于或者不属于该集合，二者必居其一。
  -  互斥性 : 一个集合中，任何两个元素都认为是不相同的，即每个元素只能出现一次。
  - 无序性 : 一个集合中，每个元素的地位都是相同的，元素之间是无序的。
- Swift 的集合类型写做 Set<Element>，这里的 Element 是 Set 要储存的类型。不同与数 组，集合没有等价的简写。

### 2.1 创建Set

- #### 使用初始化器语法来创建一个确定类型的空 Set

  ```swift
  var letters = Set<Character>()
  ```

- 使用数组字面量创建 Set

  ```swift
  var course: Set<String> = ["English", "Math", "History"]
  ```

### 2.2 Set 类型的哈希值

- 为了能让类型储存在 Set 当中，它必须是可哈希的——就是说类型必须提供计算它自身哈希值的方法。

- 所有 Swift 的基础类型(比如 String, Int, Double, 和 Bool)默认都是可哈希的，并且可以用于 Set 或者 Dictionary 的键。

- 自定义类型需要实现 Hashable 协议

  ```swift
  struct Person {
      var name: String
      var age: Int
  }
  
  extension Person: Hashable {
      func hash(into hasher: inout Hasher) {
          hasher.combine(age)
          hasher.combine(name)
      }
  }
  
  var persons = Set<Person>()
  persons.insert(Person(name: "zhangsan", age: 28))
  persons.insert(Person(name: "zhangsan", age: 28))
  print(persons.count)//1
  ```

  

### 2.2 访问和修改Set

#### 2.2.1 遍历 Set

- 可以使用for-in遍历 Set
- 因为 Set 是无序的，如果要顺序遍历 Set，使用 sorted()方法。

```swift
let course: Set = ["English", "Math", "History"]

for item in course {
    print(item)
}

for item in course.sorted() {
    print(item)
}
```

#### 2.2.2 访问 Set

- 使用 count 获取 Set 里元素个数
- 使用 isEmpty 判断 Set 是否为空

```swift
let set: Set = ["A", "B", "C"]
print(set.count)
print(set.isEmpty)
```

#### 2.2.3 添加元素

- insert(_:) 添加一个元素到 Set
- update(with:) 如果已经有相等的元素，替换为新元素。如果 Set 中没有，则插入。

```swift
struct Person {
    var name: String
    var age: Int
}

extension Person: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) ->Bool {
        return lhs.name == rhs.name
    }
}

var persons = Set<Person>()
persons.insert(Person(name: "zhangsan", age: 28))
persons.insert(Person(name: "lisi", age: 29))
persons.update(with: Person(name: "zhangsan", age: 39))

print(persons.count)//2
```

#### 2.2.4 移除元素

- filter(_:) 返回一个新的 Set，新 Set 的元素是原始 Set 符合条件的元素。

  ```swift
  struct Person {
      var name: String
      var age: Int
  }
  
  extension Person: Hashable {
      func hash(into hasher: inout Hasher) {
          hasher.combine(name)
      }
  }
  extension Person: Equatable {
      static func == (lhs: Person, rhs: Person) ->Bool {
          return lhs.name == rhs.name
      }
  }
  
  var persons = Set<Person>()
  persons.insert(Person(name: "zhangsan", age: 28))
  persons.insert(Person(name: "lisi", age: 29))
  persons.update(with: Person(name: "zhangsan", age: 39))
  persons.update(with: Person(name: "wangwu", age: 50))
  print(persons.filter({$0.age > 30}))
  //[__lldb_expr_95.Person(name: "wangwu", age: 50), __lldb_expr_95.Person(name: "zhangsan", age: 39)]
  ```

- remove(_:) 从 Set 当中移除一个元素，如果元素是 Set 的成员就移除它，并且返回移除的 值，如果合集没有这个成员就返回 nil 。

- removeAll() 移除所有元素

- ```swift
  struct Person {
      var name: String
      var age: Int
  }
  
  extension Person: Hashable {
      func hash(into hasher: inout Hasher) {
          hasher.combine(name)
      }
  }
  extension Person: Equatable {
      static func == (lhs: Person, rhs: Person) ->Bool {
          return lhs.name == rhs.name
      }
  }
  
  var persons = Set<Person>()
  persons.update(with: Person(name: "zhangsan", age: 39))
  persons.update(with: Person(name: "wangwu", age: 50))
  print(persons.remove(Person(name: "zhangsan", age: 20)))
  print(persons.removeAll())
  ```

- removeFirst() 移除 Set 的第一个元素，因为 Set 是无序的，所以第一个元素并不是放入的 第一个元素。

- ```swift
  var set: Set = ["A", "B", "C"]
  set.update(with: "D")
  set.update(with: "E")
  print(set.removeFirst())//E
  ```

  

### 2.3 执行Set计算和判断

### ![基本Set操作](/Users/Brooks/blog/blogs/swift/set.png)

#### 2.3.1 基本 Set 操作的定义

- intersection(_:) 交集，由属于A且属于B的相同元素组成的集合，记作A∩B(或B∩A)。_
- _ union(_:) 并集，由所有属于集合A或属于集合B的元素所组成的集合，记作A∪B(或B∪A)。_
- _symmetricDifference(_:) 对称差集，集合A与集合B的对称差集定义为集合A与集合B中所有不属 于A∩B的元素的集合。
- subtracting(_:) 相对补集，由属于A而不属于B的元素组成的集合，称为B关于A的相对补集，记 作A-B或A\B。

```swift
var set: Set = ["A", "B", "C"]
var set2: Set = ["B", "E", "F", "G"]
print(set.intersection(set2))//["B"]
print(set.union(set2))//["A", "B", "F", "G", "C", "E"]
print(set.symmetricDifference(set2))//["A", "F", "G", "C", "E"]
print(set.subtracting(set2))//["C", "A"]	
```

#### 2.3.2 Set 判断方法

- isSubset(of:) 判断是否是另一个 Set 或者 Sequence 的子集 
- isSuperset(of:) 判断是否是另一个 Set 或者 Sequence 的超集
- isStrictSubset(of:) 和 isStrictSuperset(of:) 判断是否是另一个 Set 的子集或者超集，但是 又不等于另一个 Set 。
- isDisjoint(with:) 判断两个 Set 是否有公共元素，如果没有返回 true，如果有返回 false

```swift
var set: Set = ["A", "B", "C"]
var set2: Set = ["A", "B", "C", "D"]
print(set.isSubset(of:set2))//true
print(set2.isSuperset(of:set))//true
print(set.isStrictSubset(of: set2))//true
print(set2.isStrictSuperset(of: set))//true
print(set.isDisjoint(with: set2))//false
```



### 2.4 Set 算法

#### 2.4.1 给定一个集合，返回这个集合所有的子集

- 思路1 - 位

  - 思路:解这道题的思想本质上就是元素选与不选的问题，于是我们就可以想到用二进制来代 表选与不选的情况。“1”代表这个元素已经选择，而“0”代表这个元素没有选择。假如三 个元素 A B C ，那么 101 就代表 B 没有选择，所以 101 代表的子集为 AC 。

  - ```swift
    func getSubjectsOfSet<T>(set: Set<T>) -> Array<Set<T>> {
        let count = 1 << set.count//这里有位数的限制
        let elements = Array(set)
        var subSets = Array<Set<T>>()
        for i in 0..<count {
            var subSet = Set<T>()
            for j in 0...elements.count {
                if ((i >> j) & 1) == 1{
                    subSet.insert(elements[j])
                }
            }
            subSets.append(subSet)
        }
        return subSets
    }
    
    print(getSubjectsOfSet(set: Set(["A", "B", "C"])))
    ```

- 思路2 - 递归

  - 思路:如果只有一个元素，那么它的子集有两个，分别是本身和空集，然后在已经有一个元素的 子集的基础上，第二个元素有两种选法，那就是加入到前面的子集里面或者不加入到前面的子集 里面，也就是选与不选的问题。而前面的子集一共有两个，对每一个子集都有来自于下一个元素 的加入和不加入两种选法。那么就可以得出两个元素的子集一共有四个。依次类推，就可以得出 n 的元素所有子集(这里 n 个元素的子集一共有 2n 个，非空子集一共有 2n-1 个)。

  - ```swift
    func getSubjectsOfSet<T>(set: Set<T>) -> Array<Set<T>> {
        let elements = Array(set)
        return getSubjectsOfSet(elements: elements, index: elements.count - 1, count: elements.count)
    }
    
    func getSubjectsOfSet<T>(elements: Array<T>, index: Int, count: Int) -> Array<Set<T>> {
        var subSets = Array<Set<T>>()
        if index == 0 {
            subSets.append(Set<T>())
            var subSet = Set<T>()
            subSet.insert(elements[0])
            subSets.append(subSet)
            return subSets
        }
        subSets = getSubjectsOfSet(elements: elements, index: index - 1, count: count)
        for subSet in subSets {
            var subSetWithCurrent = subSet
            subSetWithCurrent.insert(elements[index])
            subSets.append(subSetWithCurrent)
        }
        
        return subSets
    }
    
    print(getSubjectsOfSet(set: Set(["A", "B", "C"])))
    ```



### 2.5 Set的底层实现探究

留个坑~

## 3.字典 Dictionary

- 字典储存无序的互相关联的同一类型的键和同一类型的值的集合
- 字典类型的全写方式 Dictionary<Key, Value>，简写方式 [Key: Value]，建议使用简写方式
- 字典的 key 必须是可哈希的

### 3.1 在Swift中创建Dictionary的N种方式

- 初始化器方式

- ```swift
  var dic = Dictionary<String, Int>()
  ```

  

- 简写方式

- ```swift
  var dic = [String: Int]()
  ```

  

- 字面量方式

- ```swift
  var dic:Dictionary<String, Int> = [:]
  var dic2 = ["A":1, "B":2, "C":3]
  ```

### 3.2 count 和 isEmpty

- 可以使用 count 只读属性来找出 Dictionary 拥有多少元素
- 使用布尔量 isEmpty 属性检查字典是否为空

```swift
var dic = ["A":1, "B":2, "C":3]
print(dic.count)//3
print(dic.isEmpty)//false
```

### 3.3 遍历字典

- For-In 循环

- ```swift
  var dic = ["A":1, "B":2, "C":3]
  for (key, value) in dic {
      print("\(key):\(value)")
  }
  ```

  

- 可以通过访问字典的 keys 和 values 属性来取回可遍历的字典的键或值的集合

- ```swift
  var dic = ["A":1, "B":2, "C":3]
  
  for value in dic.values {
      print(value)
  }
  
  for key in dic.keys {
      print(key)
  }
  ```

  

- Swift 的 Dictionary 类型是无序的。要以特定的顺序遍历字典的键或值，使用键或值的 sorted() 方法

- ```swift
  var dic = ["A":1, "B":2, "C":3]
  
  for value in dic.values.sorted() {
      print(value)
  }
  ```

### 3.4 添加或更新元素

- 使用下标添加或更新元素
- 使用 updateValue(_:forKey:) 方法添加或更新元素，返回一个字典值类型的可选项值

```swift
var dic = ["A":1, "B":2, "C":3]
dic["A"] = 101
dic.updateValue(303, forKey: "C")	
```

### 3.5 移除元素

- 使用下标脚本语法给一个键赋值 nil 来从字典当中移除一个键值对
- 使用 removeValue(forKey:)来从字典里移除键值对。这个方法移除键值对如果他们存在的 话，并且返回移除的值，如果值不存在则返回 nil 。

```swift
var dic = ["A":1, "B":2, "C":3]
dic["A"] = nil
dic.removeValue(forKey: "C")
```

### 3.6 合并两个字典

- merge(_:uniquingKeysWith:)

- ```swift
  var dic = ["A":1, "C":3]
  var dic2 = ["C":100, "D":101]
  dic.merge(dic2) { (current, _) in current }
  print(dic)//["D": 101, "C": 3, "A": 1]
  dic.merge(dic2) { (_, new) in new }
  print(dic)//["D": 101, "C": 100, "A": 1]
  ```

### 3.7 保持顺序的kv对 可以使用 KeyValuePairs

```swift
var dic = ["A":1, "B":3, "C":4]
print(dic)//["B": 3, "A": 1, "C": 4]
var dic2: KeyValuePairs = ["A":1, "B":3, "C":4]
print(dic2)//["A": 1, "B": 3, "C": 4]
```



### 3.8 Dictionary的底层实现探究

留个坑先~


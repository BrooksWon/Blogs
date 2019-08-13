# Swift学习笔记1一Swift简介

## Swift发展史

- 从 2014 年至今，已经有 15 个版本发布，其中 5 个大版本，10 个小版本 .

  

  2014.8—1.0版本

  2015.9—2.0版本

  2015 年 12 月 Swift 正式开源，目前 Swift 可以应用到多个领域，甚至连 TensorFlow 也有 Swift 语言版本 

  2016.9—3.0版本

  2017.9—4.0版本

  2019.3—5.0版本

  

- 与之对比的是 Objective-C 从80年代至今，只有两个版本 



### 截止swift 5.0, swift语言主要有以下特性

- Error handling 增强
- guard 语法
- 协议支持扩展
- 新的 GCD 和  Core Graphics
- NS 前缀从老的 Foundation 类型的中移除
- 内联序列函数 sequence
- 新增 fileprivate 和 open两个权限
- 移除了诸多启用的特性, 比如 `++`、 `—`运算符等
- 类型和协议的组合类型
- Associated Type 可以追加 where 约束语句
- 新的 Key Paths 语法
- 下标支持泛型
- 字符串增强
- ABI稳定(5.0版本稳定下来)
- Raw strings
- 标准库新增 Result
- 定义了与 Python 或 Ruby 等脚本语言互操作的动态可调用类型
- 



## Swift和ObjC的主要区别

### 编程范式

- Swift 可以面向协议编程、函数式编程、面向对象编程
- ObjC 以面向对象编程为主，当然也可以引入类似ReactiveCocoa的类库来进行函数式编程

### 类型安全

- Swift 是一门类型安全的语言。程序会在编译期间做类型检查，并将不匹配的类型当做错误标记出来，方便开发人员尽早发现和修正错误
- 而ObjC的程序则不会在编译期报错，而是作为警告提示程序员

### 值类型增强

- 在 Swift 中, 典型的有struct、enum、以及tuple都是值类型. Int、Double、Float、String、Array、Dictionary、Set也都是值类型, 且都是用结构体实现的
- ObjC中, 像NSNumber、NSString以及集合类对象都是 指针类型

### 枚举增强

- Swift 中的枚举可以使用：整型、浮点型、字符串等，还能拥有属性和方法，甚至支持泛型、协议、扩展等等
- ObjC中的枚举则鸡肋很多

### 泛型方面

- Swift 中支持泛型，也支持泛型的类型约束等特性
- ObjC的泛型约束仅仅停留在编译器警告阶段

### 协议和扩展

- Swift对协议的支持更加丰富，配合扩展(extension)、泛型、关林类型等可以实现面向协议编程，从而大大提高代码的灵活性。同时，swift 中的 Protocol 还可以用于值类型，比如：结构体和枚举。
- ObjC 的协议缺乏强约束， 提供的optional特性也造成了很多为题，而如果放弃optional又会让实现代价过大。

### 函数和闭包

- Swift 中函数式一等公民，可以直接定义函数类型变量，可以作为其他函数参数传递，可以作为函数返回值返回。
- ObjC 中函数仍然是次等公民， 需要 `selector` 封装或者使用 block 才能模拟 Swift 中类似的效果



## Swift命令行编译

### 编译过程

![](/Users/Brooks/blog/blogs/swift/编译过程.png)

### Swift语言程序编译过程

![](/Users/Brooks/blog/blogs/swift/Swift语言编译过程.png)



### 使用命令行工具 swiftc 编译 main.swift 文件

- swiftc -o main.out main.swift // 生成可执行文件
-  Swift Abstract Syntax Tree (AST) swiftc main.swift -dump-ast //生成抽象语法树
- Swift Intermediate Language (SIL) swiftc main.swift -emit-sil //生成中间语言
-  LLVM Intermediate Representation (LLVM IR) swiftc main.swift -emit-ir Assembly Language //生成中间层表示语言
- swiftc main.swift -emit-assembly 

## Swift的交互式解释器:REPL

- Xcode 6.1引入了另外一种以交互式的方式来体验 Swift 的方法。
- Read Eval PrintLoop，简称 REPL

在命令行中输入 `Swift` 即可进入REPL模式, 进行Swift代码的编写、运行。

退出REPL模式，输入  `:quit` ，显示帮助、输入`:help`



## Playground

- Swift Playground 首次公布于WWDC2016 
- 最开始是为了让人人都能愉快的学习 Swift 编程 
- 但发展至今, 这个工具越来越强大
-  iPad APP Playgrounds 
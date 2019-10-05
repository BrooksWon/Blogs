# LLVM编译流程

## 1. **LLVM**

### 1.1 什么是LLVM

- 官网: https://llvm.org/，LLVM 创始人 Chris Lattner，亦是Swift之父。
- The LLVM Project is a collection of modular and reusable **compiler** and **toolchain** technologies. （LLVM项目是模块化、可重用的编译器以及工具链技术的集合）。
- 有些文章把LLVM当做Low Level Virtual Machine(低级虚拟机)的缩写简称，官方描述如下 *The name "LLVM" itself is not an acronym; it is the full name of the project.*  `LLVM` 这个名称本身不是首字母缩略词; 它是项目的全名。

## 2. 传统的编译器架构

![compiler](/Users/Brooks/blog/blogs/dev/compiler.png)

- Frontend: 前端
  - 词法分析、语法分析、语义分析、生成中间代码
- Optimizer：优化器
  - 中间代码优化
- Backend：后端
  - 生成机器码

## 3. LLVM 架构

 ![llvm](/Users/Brooks/blog/blogs/dev/llvm.png)

- 不同的前端后端使用统一的中间代码LLVM Intermediate Representation (**LLVM IR**)
- 如果需要支持一种新的编程语言，那么只需要实现一个新的前端
- 如果需要支持一种新的硬件设备，那么只需要实现一个新的后端
- 优化阶段是一个通用的阶段，它针对的是统一的LLVM IR，不论是支持新的编程语言，还是支持新的硬件设备，都不需要对优化阶段做修改
- 相比之下，GCC的前端和后端没分得太开，前端后端耦合在了一起。所以GCC为了支持一门新的语言，或者为了支持一个新的目标平台，就 变得特别困难
- LLVM现在被作为实现各种静态和运行时编译语言的通用基础结构(GCC家族、Java、.NET、Python、Ruby、Scheme、Haskell、D等)

### 3.1 Clang

#### 3.1.1 什么是Clang

- Clang 是 LLVM项目的一个子项目，是基于LLVM架构的C/C++/Objective-C编译器前端。
- 官网: http://clang.llvm.org/
- 相比于GCC，Clang具有如下优点：
  - 编译速度快:在某些平台上，Clang的编译速度显著的快过GCC(Debug模式下编译OC速度比GGC快3倍)
  - 占用内存小:Clang生成的AST所占用的内存是GCC的五分之一左右
  - 模块化设计:Clang采用基于库的模块化设计，易于 IDE 集成及其他用途的重用
  - 诊断信息可读性强:在编译过程中，Clang 创建并保留了大量详细的元数据 (metadata)，有利于调试和错误报告
  - 设计清晰简单，容易理解，易于扩展增强

#### 3.2 Clang与LLVM

![llvm编译流程1](/Users/Brooks/blog/blogs/dev/llvm编译流程1.png) 

- 广义的LLVM：整个LLVM架构
- 狭义的LLVM：LLVM后端(代码优化、目标代码生成等)

## 4. LLVM 编译流程

![llvm编译流程2](/Users/Brooks/blog/blogs/dev/llvm编译流程2.png)

### 4.1 Objective-C 源文件的编译过程

- 命令行查看编译的过程:$ clang -ccc-print-phases main.m

  ![](/Users/Brooks/blog/blogs/dev/page8image14156608-0240693.png) 

- ```
  0: input, "main.m", objective-c//引入源文件
  1: preprocessor, {0}, objective-c-cpp-output//预处理
  2: compiler, {1}, ir//源代码编译成中间代码
  3: backend, {2}, assembler//后端编译器生成汇编代码
  4: assembler, {3}, object//汇编代码生成可执行代码（机器码）
  5: linker, {4}, image//链接可执行文件、代码
  6: bind-arch, "x86_64", {5}, image//将可执行文件和x86_64 CPU的机器绑定
  ```

  

- 查看preprocessor(预处理)的结果:$ clang -E main.m

### 4.2 词法分析

- 词法分析，生成Token: $ clang -fmodules -E -Xclang -dump-tokens main.m

  - 源代码

  - ```objective-c
    void test(int a, int b) {
        int c = a + b - 3;
    }
    ```

  - 执行上述命令后的结果

    ![](/Users/Brooks/blog/blogs/dev/page9image14493856.png) 

    结果显示：**词法分析会把字母、小括号、逗号、大括号、操作符、分号等生成 token，并指出token对应的源代码在源文件中的所在行号和所在行的具体位置**。

### 4.3 语法分析

- 语法分析，生成语法树(AST，Abstract Syntax Tree): $ clang -fmodules -fsyntax-only -Xclang -ast-dump main.m

  - 源代码

  - ```objc
    void test(int a, int b) {
        int c = a + b - 3;
    }
    ```

  - 执行上述命令行后的结果：

    ![](/Users/Brooks/blog/blogs/dev/page10image14168672.png) 

    转换成树状图如下：

    ![AST](/Users/Brooks/blog/blogs/dev/AST.png)

### 4.4 LLVM IR

- LLVM IR有3种表示形式(但本质是等价的，就好比水可以有气体、液体、固体3种形态)：
  - text:便于阅读的文本格式，类似于汇编语言，拓展名.ll， $ clang -S -emit-llvm main.m
  - memory:内存格式
  - bitcode:二进制格式，拓展名.bc， $ clang -c -emit-llvm main.m
- IR官方语法参考：https://llvm.org/docs/LangRef.html
- IR基本语法：
  - 注释以分号` ;` 开头
  - 全局标识符以`@`开头，局部标识符以`%`开头
  - `alloca`，在当前函数栈帧中分配内存
  - `i32`，32bit，4个字节的意思
  - `align`，内存对齐
  - `store`，写入数据
  - `load`，读取数据

#### 4.4.1 解读 IR

- 源代码

- ```objc
  void test(int a, int b) {
      int c = a + b - 3;
  }
  ```

- 将源代码生成 text 格式的 IR， 结果如下：

  ![](/Users/Brooks/blog/blogs/dev/page12image14157648.png) 

  根据 IR 的语法，对生成的 IR 做一下解读：

  ```
  define void @test(i32, i32) #0 {//定义一个全局函数，有2个4个字节的形参
  
    %3 = alloca i32, align 4//声明局部变量3（其实就是源代码中的形参a的接收者）、在当前函数栈帧中分配4个字节的内存，内存对齐方式是4个字节
    
    %4 = alloca i32, align 4//声明局部变量4（其实就是源代码中的形参b的接收者）、在当前函数栈帧中分配4个字节的内存，内存对齐方式是4个字节
    
    %5 = alloca i32, align 4//声明局部变量5（其实就是源代码中的局部变量c）、在当前函数栈帧中分配4个字节的内存，内存对齐方式是4个字节
    
    store i32 %0, i32* %3, align 4//将局部变量0（其实就是源代码中的形参a）的值赋给局部变量3；即：变量3 = a
    
    store i32 %1, i32* %4, align 4//将局部变量0（其实就是源代码中的形参a）的值赋给局部变量3；即：变量4 = b
    
    %6 = load i32, i32* %3, align 4//声明局部变量6，读取局部变量3的值赋给局部变量6，内存对齐方式是4个字节；即变量6 = 变量3
    
    %7 = load i32, i32* %4, align 4//声明局部变量7，读取局部变量4的值赋给局部变量7，内存对齐方式是4个字节；即变量7 = 变量4
    
    %8 = add nsw i32 %6, %7//声明局部变量8，并将变量6和变量7做加法运算的值赋给变量8；即变量8 = 变量6 + 变量7
    
    %9 = sub nsw i32 %8, 3////声明局部变量9，并将变量8和常数3（源代码中的常数3）做减法运算的值赋给变量9；即变量9 = 变量8 - 变量7
    
    store i32 %9, i32* %5, align 4//把局部变量9的值赋给局部变量5（其实就是源代码中的局部变量c），内存对齐方式是4个字节；即：c = 局部变量9
    
    ret void//返回空
  }
  ```

  

## 5. 源码下载

### 5.1 下载LLVM

- git clone https://git.llvm.org/git/llvm.git/

### 5.2 下载clang

1. cd llvm/tools
2. git clone https://git.llvm.org/git/clang.git/

## 6. 源码编译

### 6.1 编译方式 1

1. 安装cmake和ninja(先安装brew，https://brew.sh/)
   1. brew install cmake
   2. brew install ninja
2. ninja如果安装失败，可以直接从github获取release版放入【/usr/local/bin】中
   - https://github.com/ninja-build/ninja/releases
3. 在LLVM源码同级目录下新建一个【llvm_build】目录(最终会在【llvm_build】目录下生成【build.ninja】)
   1. cd llvm_build
   2. cmake -G Ninja ../llvm -DCMAKE_INSTALL_PREFIX=LLVM的安装路径
      - *更多cmake相关选项，可以参考: https://llvm.org/docs/CMake.html*
4. 依次执行编译、安装指令
   1. ninja
      - 编译完毕后， 【llvm_build】目录大概 21.05 G(仅供参考)
   2. ninja install
      - 安装完毕后，安装目录大概 11.92 G(仅供参考)

### 6.2 编译方式 2 （不推荐）

也可以生成Xcode项目再进行编译，但是速度很慢。

1. 在llvm同级目录下新建一个【llvm_xcode】目录
2. cd llvm_xcode
3. cmake -G Xcode ../llvm

然后，

![](/Users/Brooks/blog/blogs/dev/page15image30427104.png) 

![](/Users/Brooks/blog/blogs/dev/page15image30425312.png) 

![](/Users/Brooks/blog/blogs/dev/page15image30436848.png) 



## 7. 应用与实践

### 7.1 libclang、libTooling

- 官方参考:https://clang.llvm.org/docs/Tooling.html
- 应用: **语法树分析**、**语言转换 **等

### 7.2 Clang插件开发

- 官方参考：
  - https://clang.llvm.org/docs/ClangPlugins.html
  -  https://clang.llvm.org/docs/ExternalClangExamples.html
  - https://clang.llvm.org/docs/RAVFrontendAction.html
- 应用:**代码检查(命名规范、代码规范) **等

### 7.3 Pass开发

- 官方参考:https://llvm.org/docs/WritingAnLLVMPass.html
- 应用:**代码优化、代码混淆 **等

### 7.4 开发新的编程语言

- https://llvm-tutorial-cn.readthedocs.io/en/latest/index.html
- https://kaleidoscope-llvm-tutorial-zh-cn.readthedocs.io/zh_CN/latest/
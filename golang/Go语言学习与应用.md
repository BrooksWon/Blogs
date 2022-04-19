[TOC]

#Go语言学习与应用

> Q2给自己定了一个OKR，学习并应用Go语言
>
> O：掌握Go语言，并写一个HTTP应用
>
> ​	KR1：4月份，利用业余时间系统化学习Go语言，达到写个HTTP应用的程度
>
> ​	KR2：5月份，利用业务时间写个HTTP应用，并部署到线上。
>
> ​	KR3：6月份，参与团队内部项目code review，尝试参与编写公司项目。



2022-04-06 开启旅程~



### Go 最常用的几个命令

| 命令    | 作用               | 示例                      |
| ------- | ------------------ | ------------------------- |
| build   | 编译可执行文件     | go build [package_name]   |
| get     | 获取某个包         | go get [package_name]     |
| install | 编译并安装当前项目 | go install [package_name] |
| run     | 执行某个文件       | go run [file_name]        |



### Golang数据类型

Go 语言数据类型包含基础类型和复合类型两大类。

- 基础数据类型包括：布尔型、整型、浮点型、复数型、字符型、字符串型、错误类型。
- 复合数据类型包括：指针、数组、切片、字典、通道、结构体、接口。

**Go 语言在声明变量时会默认给变量赋个当前类型的空值**，声明变量的方式：

| 声明方式                             | 说明                                                |
| ------------------------------------ | --------------------------------------------------- |
| var 变量名 <变量类型>                | 声明单个变量                                        |
| var 变量名1, 变量名2,... <变量类型>  | 声明多个同类型变量                                  |
| 变量名 := 值                         | 声明变量，并赋值；Go 语言会根据所赋值推断变量的类型 |
| 变量名1, 变量名2,... := 值1, 值2,... | 声明多个同类型变量并赋值，几个变量必须赋几个值      |



**布尔类型 (bool)**
值：true 和 false，默认值为 false

```go
package main

import "fmt"

func main() {
    var v1, v2 bool         // 声明变量，默认值为 false
    v1 = true               // 赋值
    v3, v4 := false, true   // 声明并赋值

    fmt.Print("v1:", v1)   // v1 输出 true
    fmt.Print("\nv2:", v2) // v2 没有重新赋值，显示默认值：false
    fmt.Print("\nv3:", v3) // v3 false
    fmt.Print("\nv4:", v4) // v4 true
}
```



**数字类型**
 数字类型比较多，默认值都是 0。定义`int`类型时，默认根据系统类型设置取值范围，32位系统与`int32`的值范围相同，64位系统与`int64`的值范围相同。见下表：

| 类型       | 名称                                     | 存储空间   | 值范围                                                       | 数据级别       |
| ---------- | ---------------------------------------- | ---------- | ------------------------------------------------------------ | -------------- |
| uint8      | 无符号8位整形                            | 8-bit      | 0 ~ 255                                                      | 百             |
| uint16     | 无符号16位整形                           | 16-bit     | 0 ~65535                                                     | 6万多          |
| uint32     | 无符号32位整形                           | 32-bit     | 0 ~ 4294967295                                               | 40多亿         |
| uint64     | 无符号64位整形                           | 64-bit     | 0 ~ 18446744073709551615                                     | 大到没概念     |
| int8       | 8位整形                                  | 8-bit      | -128 ~ 127                                                   | 正负百         |
| int16      | 16位整形                                 | 16-bit     | -32768 ~ 32767                                               | 正负3万多      |
| int32      | 32位整形                                 | 32-bit     | -2147483648 ~ 2147483647                                     | 正负20多亿     |
| int64      | 64位整形                                 | 64-bit     | -9223372036854775808 ~ 9223372036854775807                   | 正负大到没概念 |
| int        | 系统决定                                 | 系统决定   | 32位系统为`int32`的值范围，64位系统为`int64`的值范围         |                |
| -          |                                          |            |                                                              |                |
| float32    | 32位浮点数                               | 32-bit     | IEEE-754 1.401298464324817070923729583289916131280e-45 ~ 3.402823466385288598117041834516925440e+38 | 精度6位小数    |
| float64    | 64位浮点数                               | 64-bit     | IEEE-754 4.940656458412465441765687928682213723651e-324 ~ 1.797693134862315708145274237317043567981e+308 | 精度15位小数   |
| -          |                                          |            |                                                              |                |
| complex64  | 复数，含 float32 位实数和 float32 位虚数 | 64-bit     | 实数、虚数的取值范围对应 float32                             |                |
| complex128 | 复数，含 float64 位实数和 float64 位虚数 | 128-bit    | 实数、虚数的取值范围对应 float64                             |                |
| -          |                                          |            |                                                              |                |
| byte       | 字符型，unit8 别名                       | 8-bit      | 表示 UTF-8 字符串的单个字节的值，对应 ASCII 码的字符值       |                |
| rune       | 字符型，int32 别名                       | 32-bit     | 表示 单个 Unicode 字符                                       |                |
| uintptr    | 无符号整型                               | 由系统决定 | 能存放指针地址即可                                           |                |

```go
package main

import "fmt"

func main() {
    // 无符号整形，默认值都是0
    var u8 uint8
    var u16 uint16
    var u32 uint32
    var u64 uint64
    fmt.Printf("u8: %d, u16: %d, u32: %d, u64: %d\n", u8, u16, u32, u64) // 默认值都为0
    u8 = 255
    u16 = 65535
    u32 = 4294967295
    u64 = 18446744073709551615
    fmt.Printf("u8: %d, u16: %d, u32: %d, u64: %d\n", u8, u16, u32, u64)

    // 整型
    var i8 int8
    var i16 int16
    var i32 int32
    var i64 int64
    fmt.Printf("i8: %d, i16: %d, i32: %d, i64: %d\n", i8, i16, i32, i64) // 默认值都为0
    i8 = 127
    i16 = 32767
    i32 = 2147483647
    i64 = 9223372036854775807
    fmt.Printf("i8: %d, i16: %d, i32: %d, i64: %d\n", i8, i16, i32, i64)

    // int 型，取值范围32位系统为 int32，64位系统为 int64，取值相同但为不同类型
    var i int
    //i = i32 // 报错，编译不通过，类型不同
    //i = i64 // 报错，编译不通过，类型不同
    i = -9223372036854775808
    fmt.Println("i: ", i)

    // 浮点型，f32精度6位小数，f64位精度15位小数
    var f32 float32
    var f64 float64
    fmt.Printf("f32: %f, f64: %f\n", f32, f64) // 默认值都为 0.000000
    f32 = 1.12345678
    f64 = 1.12345678901234567
    fmt.Printf("f32: %v, f64: %v\n", f32, f64) // 末位四舍五入，输出：f32: 1.1234568, f64: 1.1234567890123457

    // 复数型
    var c64 complex64
    var c128 complex128
    fmt.Printf("c64: %v, c128: %v\n", c64, c128) // 实数、虚数的默认值都为0
    c64 = 1.12345678 + 1.12345678i
    c128 = 2.1234567890123456 + 2.1234567890123456i
    fmt.Printf("c64: %v, c128: %v\n", c64, c128) // 输出：c64: (1.1234568+1.1234568i), c128: (2.1234567890123457+2.1234567890123457i)

    // 字符型
    var b byte                                       // uint8 别名
    var r1, r2 rune                                  // uint16 别名
    fmt.Printf("b: %v, r1: %v, r2: %v\n", b, r1, r2) // 默认值为0
    b = 'a'
    r1 = 'b'
    r2 = '字'
    fmt.Printf("b: %v, r1: %v, r2: %v\n", b, r1, r2) // 输出：b: 97(ASCII表示的数), r1: 98(utf-8表示的数), r2: 23383 (utf-8表示的数)

    b = u8
    r1 = i32
    fmt.Printf("b: %v, r1: %v\n", b, r1) // 输出：b: 255, r1: 2147483647

    // 指针地址
    var p uintptr
    fmt.Printf("p: %v\n", p) // 默认值为0
    p = 18446744073709551615 // 64位系统最大值
    //p = 18446744073709551616 // 报错：超出最大值
    fmt.Printf("p: %v\n", p)

}
```



**字符串 (string)**
Go 语言默认编码都是 UTF-8，默认值为空字符串 ""

```go
package main

import "fmt"

func main() {
    var str1 string // 默认值为空字符串 ""
    str1 = `hello world`
    str2 := "你好世界"

    str := str1 + " " + str2 // 字符串连接
    fmt.Println(str1)
    fmt.Println(str2)
    fmt.Println(str) // 输出：hello world 你好世界

    // 遍历字符串
    l := len(str)
    for i := 0; i < l; i++ {
        chr := str[i]
        fmt.Println(i, chr) // 输出字符对应的编码数字
    }
}
```



**指针（pointer）**
 指针其实就是指向一个对象（任何一种类型数据、包括指针本身）的地址值，对指针的操作都会映射到指针所指的对象上。默认值为空：nil

```go
package main

import (
    "fmt"
)

func main() {
    var p *int // 定义指向int型的指针，默认值为空：nil

    // nil指针不指向任何有效存储地址，操作系统默认不能访问
    //fmt.Printf("%x\n", *p) // 编译报错

    var a int = 10
    p = &a        // 取地址
    add := a + *p // 取值

    fmt.Println(a)   // 输出：10
    fmt.Println(p)   // 输出：0xc0420080b8
    fmt.Println(add) // 输出：20
}
```



**数组（array）**
 数组为一组相同数据类型数据的集合，数组定义后大小固定，不能更改，每个元素称为`element`，声明的数组元素默认值都是对应类型的0值。而且数组在Go语言中是一个值类型（value type），**所有值类型变量在赋值和作为参数传递时都会产生一次复制动作**，即对原值的拷贝。

```go
package main

import "fmt"

func main() {
    // 1.声明后赋值
    // var <数组名称> [<数组长度>]<数组元素>
    var arr [2]int   // 数组元素的默认值都是 0
    fmt.Println(arr) // 输出：[0 0]
    arr[0] = 1
    arr[1] = 2
    fmt.Println(arr) // 输出：[1 2]

    // 2.声明并赋值
    // var <数组名称> = [<数组长度>]<数组元素>{元素1,元素2,...}
    var intArr = [2]int{1, 2}
    strArr := [3]string{`aa`, `bb`, `cc`}
    fmt.Println(intArr) // 输出：[1 2]
    fmt.Println(strArr) // 输出：[aa bb cc]

    // 3.声明时不设定大小，赋值后语言本身会计算数组大小
    // var <数组名称> [<数组长度>]<数组元素> = [...]<元素类型>{元素1,元素2,...}
    var arr1 = [...]int{1, 2}
    arr2 := [...]int{1, 2, 3}
    fmt.Println(arr1) // 输出：[1 2]
    fmt.Println(arr2) // 输出：[1 2 3]
    //arr1[2] = 3 // 编译报错，数组大小已设定为2

    // 4.声明时不设定大小，赋值时指定索引
    // var <数组名称> [<数组长度>]<数组元素> = [...]<元素类型>{索引1:元素1,索引2:元素2,...}
    var arr3 = [...]int{1: 22, 0: 11, 2: 33}
    arr4 := [...]string{2: "cc", 1: "bb", 0: "aa"}
    fmt.Println(arr3) // 输出：[11 22 33]
    fmt.Println(arr4) // 输出：[aa bb cc]

    // 遍历数组
    for i := 0; i < len(arr4); i++ {
        v := arr4[i]
        fmt.Printf("i:%d, value:%s\n", i, v)
    }
}
```



**切片（slice）**
 因为数组的长度定义后不可修改，所以需要切片来处理可变长数组数据。切片可以看作是一个可变长的数组，是一个引用类型。它包含三个数据：1.指向原生数组的指针，2.切片中的元素个数，3.切片已分配的存储空间大小
 **声明一个切片，或从数组中取一段作为切片数据：**

```go
package main

import "fmt"

func main() {
    var sl []int             // 声明一个切片
    sl = append(sl, 1, 2, 3) // 往切片中追加值
    fmt.Println(sl)          // 输出：[1 2 3]

    var arr = [5]int{1, 2, 3, 4, 5} // 初始化一个数组
    var sl1 = arr[0:2]              // 冒号:左边为起始位（包含起始位数据），右边为结束位（不包含结束位数据）；不填则默认为头或尾
    var sl2 = arr[3:]
    var sl3 = arr[:5]

    fmt.Println(sl1) // 输出：[1 2]
    fmt.Println(sl2) // 输出：[4 5]
    fmt.Println(sl3) // 输出：[1 2 3 4 5]

    sl1 = append(sl1, 11, 22) // 追加元素
    fmt.Println(sl1)          // 输出：[1 2 11 22]
}
```

**使用`make`直接创建切片，语法：make([]类型,  大小，预留空间大小)**，make() 函数用于声明`slice`切片、`map`字典、`channel`通道。

```go
package main

import "fmt"

func main() {
    var sl1 = make([]int, 5)          // 定义元素个数为5的切片
    sl2 := make([]int, 5, 10)         // 定义元素个数5的切片，并预留10个元素的存储空间（预留空间不知道有什么用？）
    sl3 := []string{`aa`, `bb`, `cc`} // 直接创建并初始化包含3个元素的数组切片

    fmt.Println(sl1, len(sl1)) // 输出：[0 0 0 0 0] 5
    fmt.Println(sl2, len(sl2)) // 输出：[0 0 0 0 0] 5
    fmt.Println(sl3, len(sl3)) // [aa bb cc] 3

    sl1[1] = 1 // 声明或初始化大小中的数据，可以指定赋值
    sl1[4] = 4
    //sl1[5] = 5 // 编译报错，超出定义大小
    sl1 = append(sl1, 5)       // 可以追加元素
    fmt.Println(sl1, len(sl1)) // 输出：[0 1 0 0 4 5] 6

    sl2[1] = 1
    sl2 = append(sl2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
    fmt.Println(sl2, len(sl2)) // 输出：[0 1 0 0 0 1 2 3 4 5 6 7 8 9 10 11] 16

    // 遍历切片
    for i := 0; i < len(sl2); i++ {
        v := sl2[i]
        fmt.Printf("i: %d, value:%d \n", i, v)
    }
}
```





**字典/映射（map）**
 map 是一种键值对的无序集合，与 slice 类似也是一个引用类型。map 本身其实是个指针，指向内存中的某个空间。
 声明方式与数组类似，声明方式：**var 变量名 map[key类型]值类型** 或直接使用 make 函数初始化：**make(map[key类型]值类型, 初始空间大小)**
 其中`key`值可以是任何可以用`==`判断的值类型，对应的值类型没有要求。

```go
package main

import (
    "fmt"
    "unsafe"
)

func main() {
    // 声明后赋值
    var m map[int]string
    fmt.Println(m) // 输出空的map：map[]
    //m[1] = `aa`    // 向未初始化的map中赋值报错：panic: assignment to entry in nil map

    // 声明并初始化，初始化使用{} 或 make 函数（创建类型并分配空间）
    var m1 = map[string]int{}
    var m2 = make(map[string]int)
    m1[`a`] = 11
    m2[`b`] = 22
    fmt.Println(m1) // 输出：map[a:11]
    fmt.Println(m2) // 输出：map[b:22]

    // 初始化多个值
    var m3 = map[string]string{"a": "aaa", "b": "bbb"}
    m3["c"] = "ccc"
    fmt.Println(m3) // 输出：map[a:aaa b:bbb c:ccc]

    // 删除 map 中的值
    delete(m3, "a") // 删除键 a 对应的值
    fmt.Println(m3) // 输出：map[b:bbb c:ccc]

    // 查找 map 中的元素
    v, ok := m3["b"]
    if ok {
        fmt.Println(ok)
        fmt.Println("m3中b的值为：", v) // 输出：m3中b的值为： bbb
    }
    // 或者
    if v, ok := m3["b"]; ok { // 流程处理后面讲
        fmt.Println("m3中b的值为：", v) // 输出：m3中b的值为： bbb
    }

    fmt.Println(m3["c"]) // 直接取值，输出：ccc

    // map 中的值可以是任意类型
    m4 := make(map[string][5]int)
    m4["a"] = [5]int{1, 2, 3, 4, 5}
    m4["b"] = [5]int{11, 22, 33}
    fmt.Println(m4)                // 输出：map[a:[1 2 3 4 5] b:[11 22 33 0 0]]
    fmt.Println(unsafe.Sizeof(m4)) // 输出：8，为8个字节，map其实是个指针，指向某个内存空间
}
```



**通道（channel）**
 说到通道 channel，则必须先了解下 Go 语言的 goroutine 协程（轻量级线程）。channel 就是为 goroutine 间通信提供通道。goroutine 是 Go 语言提供的语言级的协程，是对 CPU 线程和调度器的一套封装。
 channel 也是类型相关的，一个 channel 只能传递一种类型的值。
 声明：**var 通道名 chan 通道传递值类型** 或 make 函数初始化：**make(chan 值类型, 初始存储空间大小)**

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    var ch1 chan int            // 声明一个通道
    ch1 = make(chan int)        // 未初始化的通道不能存储数据，初始化一个通道
    ch2 := make(chan string, 2) // 声明并初始化一个带缓冲空间的通道

    // 通过匿名函数向通道中写入数据，通过 <- 方式写入
    go func() { ch1 <- 1 }()
    go func() { ch2 <- `a` }()

    v1 := <-ch1 // 从通道中读取数据
    v2 := <-ch2
    fmt.Println(v1) // 输出：1
    fmt.Println(v2) // 输出：a

    // 写入，读取通道数据
    ch3 := make(chan int, 1) // 初始化一个带缓冲空间的通道
    go readFromChannel(ch3)
    go writeToChannel(ch3)

    // 主线程休眠1秒，让出执行权限给子 Go 程，即通过 go 开启的 goroutine，不然主程序会直接结束
    time.Sleep(1 * time.Second)
}

func writeToChannel(ch chan int) {
    for i := 1; i < 10; i++ {
        fmt.Println("写入：", i)
        ch <- i
    }
}

func readFromChannel(ch chan int) {
    for i := 1; i < 10; i++ {
        v := <-ch
        fmt.Println("读取：", v)
    }
}

// ------  输出：--------
1
a
写入： 1
写入： 2
写入： 3
读取： 1
读取： 2
读取： 3
写入： 4
写入： 5
写入： 6
读取： 4
读取： 5
读取： 6
写入： 7
写入： 8
写入： 9
读取： 7
读取： 8
读取： 9
```





**结构体（struct）**
 结构体是一种聚合的数据类型，是由零个或多个任意类型的值聚合成的实体。每个值称为结构体的成员。

```go
package main

import "fmt"

// 定义一个结构体 person
type person struct {
    name string
    age  int
}

func main() {
    var p person   // 声明一个 person 类型变量 p
    p.name = "max" // 赋值
    p.age = 12
    fmt.Println(p) // 输出：{max 12}

    p1 := person{name: "mike", age: 10} // 直接初始化一个 person
    fmt.Println(p1.name)                // 输出：mike

    p2 := new(person) // new函数分配一个指针，指向 person 类型数据
    p2.name = `张三`
    p2.age = 15
    fmt.Println(*p2) // 输出：{张三 15}
}
```

**十、接口（interface）**
 接口用来定义行为。Go 语言不同于面向对象语言，没有类的概念，也没有传统意义上的继承。Go 语言中的接口，用来定义一个或一组行为，某些对象实现了接口定义的行为，则称这些对象实现了（implement）该接口，类型即为该接口类型。
 定义接口也是使用 type 关键字，格式为：

```tsx
// 定义一个接口
type InterfaceName interface {
    FuncName1(paramList) returnType
    FuncName2(paramList) returnType
    ...
}
```

实例：

```go
package main

import (
    "fmt"
    "strconv"
)

// 定义一个 Person 接口
type Person interface {
    Say(s string) string
    Walk(s string) string
}

// 定义一个 Man 结构体
type Man struct {
    Name string
    Age  int
}

// Man 实现 Say 方法
func (m Man) Say(s string) string {
    return s + ", my name is " + m.Name
}

// Man 实现 Walk 方法，strconv.Itoa() 数字转字符串
func (m Man) Walk(s string) string {
    return "Age: " + strconv.Itoa(m.Age) + " and " + s
}

func main() {
    var m Man       // 声明一个类型为 Man 的变量
    m.Name = "Mike" // 赋值
    m.Age = 30
    fmt.Println(m.Say("hello"))    // 输出：hello, my name is Mike
    fmt.Println(m.Walk("go work")) // 输出：Age: 30 and go work

    jack := Man{Name: "jack", Age: 25} // 初始化一个 Man 类型数据
    fmt.Println(jack.Age)
    fmt.Println(jack.Say("hi")) // 输出：hi, my name is jack
}
```



**错误（error）**
 `error` 类型本身是 Go 语言内部定义好的一个接口，接口里定义了一个 Error() 打印错误信息的方法，源码如下：

```tsx
type error interface {
    Error() string
}
```

自定义错误信息：

```go
package main

import (
    "errors"
    "fmt"
)

func main() {
    // 使用 errors 定制错误信息
    var e error
    e = errors.New("This is a test error")
    fmt.Println(e.Error()) // 输出：This is a test error

    // 使用 fmt.Errorf() 定制错误信息
    err := fmt.Errorf("This is another error")
    fmt.Println(err) // 输出：This is another test error
}
```



### Golang流程控制

**程序结构**
 说到流程控制，必须先看下 Go 语言的程序结构：



```go
package main  // 当前包名

import "fmt"  // 导入程序中使用到的包

// 初始化函数
func init() {
    // 初始化数据
}

// 程序入口主函数，且一个 package 只能有一个 main 函数
func main() { 
    fmt.Print("hello world") // 处理逻辑
}
```

程序的初始化和执行都起始于 main package 包，并且 main() 函数只能在 man 包中，一个项目里也只能有一个 main package。一个 go 程序文件中可以有一个 init()，一个项目中可以有 n 个 init() 函数。
 程序包引入执行步骤：

![img](https:////upload-images.jianshu.io/upload_images/3005871-a3b157a903e65bc1.png?imageMogr2/auto-orient/strip|imageView2/2/w/948/format/webp)

程序文件执行步骤


 Go 语言有统一的格式化方案，虽然限制了书写上的自由但统一了格式。Go 语言用换行作为语句的结束符，除非多条语句写在同一行，则用`;`作为语句分割。



#### 流程控制

 **1. if 条件语句**
 格式：



```cpp
// if 语句格式
// else if 和 else 都是可选的，且 else if 可以有多个
// optionalStatement1 声明语句如（v := xx）中定义的变量其作用域只在 if ... else if ... else 范围内有效
if optionalStatement1; booleanExpression1 { // optionalStatement1：可选的声明语句，booleanExpression1：真假表达式，为真执行 block1 后跳出
    block1
} else if optionalStatement2; booleanExpression2 { // optionalStatement1：可选的声明语句，booleanExpression1：真假表达式，为真且上面的条件都为假则执行 block2 后跳出
    block2
} else { // 上面的条件都为假则执行 block3 后跳出
    block3
}
```

示例：



```go
package main

import "fmt"

func main() {
    // 单个 if
    if true {
        fmt.Println("if 语句")
    }

    // if ... else ...
    if false {
        fmt.Println("不会输出")
    } else {
        fmt.Println("输出")
    }

    // if ... else if ... else ...
    if 1 > 5 {
        fmt.Println("条件假，不输出")
    } else if 1 > 0 {
        fmt.Println("条件真，输出")
    } else {
        fmt.Println("不会输出")
    }

    // if else if 更多
    if v := 1; v > 5 {
        fmt.Println("v==1 假，不输出")
    } else if v++; v > 4 { // v == 2
        fmt.Println("v==2 假，不输出2")
    } else if v += 1; v == 3 { // v == 3
        fmt.Println("v==3 真，输出3")
    } else {
        fmt.Println("上面语句有真不输出")
    }

    //fmt.Println(v) // 编译报错：undefined: v，v 的作用域只在 if ... else if ... else 范围内
}
```

**2.switch 条件语句**
 格式：



```cpp
// switch 语句格式
// 如果有 optionalStatement 则后面的 ‘;’ 是必须的，不论 optionalValue 是否存在
// case 下的 block 语句执行完后不会再往下个 case 走所以不用末尾加 break，如果要往下走则使用 fallthrough 语句
// 同 if 语句一样，optionalStatement 中声明的变量如（v := xx）其作用域也只在 switch 的范围内有效
switch optionalStatement; optionalValue { // optionalStatement：可选的声明语句，optionalValue ：可选得待比较值，如果未填写则默认为 true
case expression1: // 表达式 expression1 为真执行 block1
    block1
...

case expressionN:
    blockN
default: // default 可选的，上面都未匹配则执行 default 下的 blockD
    blockD
}
```

示例：



```go
package main

import "fmt"

func main() {
    // switch 缺省表达式
    switch {
    case 1 < 0:
        fmt.Println("不输出")
    case 1 > 0:
        fmt.Println("输出 1>0")
    }

    // switch 带声明语句
    switch v := 1; { // 声明语句后必须跟';'
    case v == 1:
        fmt.Println("输出 v==1")
    case v == 2:
        fmt.Println("不输出")
    default:
        fmt.Println("不输出D")
    }

    //fmt.Println(v) // 编译报错：undefined: v，v 的作用域只在 switch 范围内

    // switch with fallthrough
    switch v := 1; v {
    case 1:
        fmt.Println("输出 v==1")
        v++
        fallthrough
    case 2:
        fmt.Println("输出 v==2")
        fallthrough
    case 3:
        fmt.Println("不输出3")
    default:
        fmt.Println("不输出d")
    }
}
```

**3.select 条件语句**
 select 是用于通道 cahnnel 通信的选择语句，格式：



```csharp
// select 语句，用于通道通信选择
select {
case sendOrReceive1: // 发送或接受通道信息
    block
...

case sendOrReceiveN:
default:
    blockD
}
```

示例：



```go
package main

import "fmt"

func main() {
    ch1 := make(chan int)
    ch2 := make(chan int, 1)
    ch3 := make(chan int, 2)

    ch2 <- 2 // 往通道 ch2 中写入一个数据

    select {
    case i1 := <-ch1:
        fmt.Println("读取 ch1 数据：", i1)
    case i2 := <-ch2:
        fmt.Println("读取 ch2 数据：", i2) // 输出：读取 ch2 数据： 2
    case ch3 <- 3:
        fmt.Println("写入 ch3 数据：3")
    default:
        fmt.Println("nothing")
    }
}
```

**4.for 循环语句**
 for 循环在 Go 语言中有多种格式选择：



```go
// 无限循环
for {
    block
}

// while 循环，Go 语言中没有单独的 while 循环，使用 for 循环代替
// booleanExpress 真假判断表达式
for booleanExpress {
    block
}

// optionalPreStatement 可选的声明，存在时后面的 ';' 号必须，声明的变量作用域为 for 语句范围内
// booleanExpress 真假判断表达式
for optionalPreStatement; booleanExpress; optionalPostStatement {
    block
}

// 使用 range 遍历数据
// 挨个字符遍历 aString 字符串
for index, char := range aString {
    block
}

// 挨个字符遍历 aString 字符串
// 对于 UTF-8 的字符串，index 可能的值将是 0， 3， 5，...
for index := range aString {
    block // char, size := utf8.DecodeRuneInString(aString[index:])
}

// 遍历数组或切片
for index, item := range anArrayOrSlice {
    block
}

// 遍历数组或切片
for index := range anArrayOrSlice {
    block // item := anArrayOrSlice[index]
}

// 遍历字典/映射
for key, value := range aMap {
    block
}

// 遍历字典
for key := range aMap {
    block // value := aMap[key]
}

// 遍历通道
for item := range aChannel {
    block
}
```

示例：



```go
package main

import (
    "fmt"
    "reflect"
)

func main() {
    // 循环输出 1 到 10
    // 类似 while 的循环输出
    i := 1
    for i <= 10 {
        fmt.Println(i)
        i++
    }

    // for 循环的不同表现
    for i := 1; i <= 10; i++ {
        fmt.Println(i)
    }
    var j int = 1
    for j <= 10 { // 仅有一个真假表达式
        fmt.Println(j)
        j++
    }
    for j = 1; j <= 10; { // 有声明语句
        fmt.Println(j)
        j++
    }
    for ; j <= 10; j++ { // 没有声明语句
        fmt.Println(j)
    }

    // 遍历字符串
    str := "hello 世界"
    // utf-8 遍历
    for i := 0; i < len(str); i++ {
        chr := str[i]
        ctype := reflect.TypeOf(chr)
        fmt.Printf("%s", ctype) // 输出：uint8
    }
    // unicode 遍历
    for index, char := range str {
        fmt.Println(index, char) // 输出字符起始位，及 Unicode 编码，如：6 19990
        fmt.Printf("%q\n", char) // 格式化输出单个字符字面值，如：h
    }

    // 遍历数组、切片
    arr := [5]int{1, 2, 3, 4, 5}
    for i, v := range arr {
        fmt.Printf("i: %d, v: %d\n", i, v)
    }
    sl := arr[2:]
    for _, v := range sl { // 赋值给 '_' 的值会被忽略掉
        fmt.Println(v)
    }

    // 遍历字典
    var m = map[string]int{"a": 1, "b": 2}
    for key, value := range m {
        fmt.Printf("key: %s, value: %d\n", key, value)
    }
    for key := range m {
        fmt.Println(key, m[key])
    }

    // 遍历通道
    ch := make(chan int, 2)
    ch <- 1
    ch <- 2
    fmt.Println(<-ch)
    for v := range ch {
        fmt.Println(v)
    }

}
```

**5.goto 跳转**
 顾名思义让程序跳到某个指定行重新执行。使用 goto 语句必须在当前函数内定义跳转标签，标签区分大小写。程序中一般不建议使用 goto 语句，过多的 goto 语句会打乱程序逻辑难以控制。
 语法：



```go
func funcName() {

    ... // 

    GotoTag: // goto 跳转标签
    
    ...
    
    goto GotoTag // 跳转到 GotoTag 行重新执行
    
    ...
}
```

实例：



```go
package main

import "fmt"

func main() {
    i := 0

LOOPTAG:
    for i < 10 {
        i++
        if i == 5 { // i = 5 时跳出 for 循环，不会打印 5
            goto LOOPTAG
        }
        fmt.Println(i)
    }

    // 递减输出 i 到 0
TAG:
    fmt.Println(i)
    i--
    if i > 0 {
        goto TAG
    }

    fmt.Println("end")
}
```



### Golang数字操作

Go 语言具有严格的静态类型限制，运算符操作的数字类型必须是相同类型数据。且数字操作不能超出该类型的取值范围，不然计算溢出得到的结果就是错的。

**一、加减乘除、取模**



```go
package main

import "fmt"

func main() {
    // 加 +
    var ui1, ui2 uint8
    ui1 = 1
    ui2 = 2
    ui := ui1 + ui2
    fmt.Println(ui) // 输出：3

    ui += 255
    fmt.Println(ui) // 溢出后计算的值就是错的，输出：2

    // 减 -
    var i, j int32
    i = 10
    j = 5
    fmt.Println(i - j) // 输出：5

    // 乘 *
    var f1, f2 float32
    f1 = 1.2
    f2 = 0.2
    // 浮点型的数字计算有精度问题，float32 精度6位小数，float64 精度15位小数，
    fmt.Println(f1 * f2) // 输出：0.24000001

    // 除 /
    n1 := 10
    n2 := 3
    fmt.Println(n1 / n2) // 输出：3，小数被丢弃

    // 求模、取余 %
    fmt.Println(n1 % n2) // 输出余数：1
}
```

**二、位运算**
 位运算是直接对数字在内存中存储的二进制数进行操作，所以性能上来讲是最快的运算方式。位运算一般常见于需要性能优化或复杂的算法中。位运算只作用于整数类型上。
 Go 语言中的位运算符：

| 运算符 | 释义                                 | 运算规则                                                     |
| ------ | ------------------------------------ | ------------------------------------------------------------ |
| &      | 按位与，两个数对应的二进制位相与     | **同时为1，则为1，否则为0**                                  |
| \|     | 按位或，两个数对应的二进制位相或     | **有一个为1，则为1，否则为0**                                |
| ^      | 按位异或，两个数对应的二进制位相异或 | **二进制位不同，则为1，否则为0**                             |
| &^     | 按位清空                             | x&^y 如果ybit位上的数是0则取x上对应位置的值，如果ybit位上为1则结果位上取0 |
| <<     | 左移                                 | 所有二进制位左移运算符右边指定的位数，高位丢弃，低位补0。左移n位就是乘以2的n次方 |
| >>     | 右移                                 | 所有二进制位右移运算符右边指定的位数，高位补0，低位丢弃。右移n位就是除以2的n次方 |



```go
package main

import "fmt"

func main() {
    var i1, i2, n uint8 // 1个字节

    // 按位与 &
    i1 = 2         // 二进制：0000 0010
    i2 = 3         // 二进制：0000 0011
    n = i1 & i2    // 按位与：0000 0010
    fmt.Println(n) // 输出：2

    // 按位或 |
    i1 = 10        // 二进制：0000 1010
    i2 = 20        // 二进制：0001 0100
    n = i1 | i2    // 按位或：0001 1110
    fmt.Println(n) // 输出：30

    // 按位异或 ^
    i1 = 3         // 二进制：0000 0011
    i2 = 4         // 二进制：0000 0100
    n = i1 ^ i2    // 按位异或：0000 0111
    fmt.Println(n) // 输出：7

    // 按位清空 &^
    i1 = 10        // 二进制：0000 1010
    i2 = 20        // 二进制：0001 0100
    n = i1 &^ i2   // 按位清空：0000 1010
    fmt.Println(n) // 输出：10

    // 左移 <<
    i1 = 5         // 二进制 0000 0101
    n = i1 << 2    // 左移2位：0001 0100
    fmt.Println(n) // 输出：20

    // 右移 >>
    i2 = 15        // 二进制：0000 1111
    n = i2 >> 2    // 右移2位：0000 0011
    fmt.Println(n) // 输出：3
}
```

**三、比较大小**
 大小比较得到的类型时布尔型。运算符：`>`大于、`>=`大于等于、`<`小于、`<=`小于等于、`==`等于。



```go
package main

import "fmt"

func main() {
    fmt.Println(2 > 1)  // 输出：true
    fmt.Println(1 == 2) // 输出：false
}
```

**四、数字类型转换**
 整型从高位类型转低位类型会有精度丢失，浮点型转整型会丢失小数点后的值，复数型转非复数整型时符号丢失。数据类型转换格式：**目标类型(转换类型)**



```go
package main

import "fmt"

func main() {
    // 整型转浮点型
    var i int = 1
    fmt.Printf("%f\n", float32(i)) // 输出：1.000000

    // 浮点型转整型
    var f float32 = 3.1415926
    fmt.Printf("%d\n", int(f)) // 输出：3，小数后丢失

    // float32 转 float64
    fmt.Printf("%v\n", float64(f)) // 输出：3.141592502593994，6位后的小数精度是错误的

    // float64 转 float32
    var f2 float64 = 3.141592653589793
    fmt.Println("%v\n", float32(f2)) // 输出：3.1415927，6位后的小数精度是错误的
}
```

**五、数字转字符串**
 使用 strconv 包中定义的函数做数字和字符串转换。



```go
package main

import (
    "fmt"
    "strconv"
)

func main() {
    // int 转 string
    var i int = 111
    var s string
    s = strconv.Itoa(i) // 数字转字符串
    fmt.Println(s)

    // string 转 int
    i2, err := strconv.ParseInt(s, 10, 64) // 把 s 转为10进制64位数
    if err == nil {
        fmt.Println(i2) // 输出：111
    }

    // float 转 string
    var f float64 = 3.1415926535
    s1 := strconv.FormatFloat(f, 'f', -1, 64)
    fmt.Println(s1) // 输出：3.1415926535
    // 第二个参数选项，含义如下：
    // 'b' (-ddddp±ddd，二进制指数)
    // 'e' (-d.dddde±dd，十进制指数)
    // 'E' (-d.ddddE±dd，十进制指数)
    // 'f' (-ddd.dddd，没有指数)
    // 'g' ('e':大指数，'f':其它情况)
    // 'G' ('E':大指数，'f':其它情况)

    // string 转 float
    str := `3.1415926535`
    v1, err := strconv.ParseFloat(str, 32) // ParseFloat 函数默认返回float64类型数据，转成folat32可能会有精度丢失
    if err == nil {
        fmt.Printf("%v\n", v1) // 输出：3.1415927410125732
    }
    v2, err := strconv.ParseFloat(str, 64)
    if err == nil {
        fmt.Printf("%v\n", v2) // 输出：3.1415926535
    }
}
```



### Golang字符串操作

Go 语言对字符串的操作主要集中在 `strings` 包中。常见的字符串操作有：

| 函数                                                   | 作用                                                         |
| ------------------------------------------------------ | ------------------------------------------------------------ |
| **strconv 包：**                                       |                                                              |
| Atoi(s string) (int, error)                            | 字符串转整型                                                 |
| **strings 包：**                                       |                                                              |
| Count(s, substr string) int                            | 计算子串`substr`在字符串`s`中出现的次数                      |
| Compare(a, b string) int                               | 比较字符串大小                                               |
| Contains(s, substr string) bool                        | 判断字符串`s`中是否包含子串`substr`                          |
| ContainsAny(s, chars string) bool                      | 判断字符串`s`中是否包含`chars`中的某个Unicode字符            |
| ContainsRune(s string, r rune) bool                    | 判断字符串`s`中是否包含rune型值为`r`的字符                   |
| Index(s, substr string) int                            | 查找子串`substr`在字符串`s`中第一次出现的位置，如果找不到则返回 -1，如果`substr`为空，则返回 0 |
| LastIndex(s, substr string) int                        | 查找子串`substr`在字符串`s`中最后出现的位置                  |
| IndexRune(s string, r rune) int                        | 查找rune型值为`r`的字符在字符串`s`中出现的起始位置           |
| IndexAny(s, chars string) int                          | 查找字符串`chars`中字符，在字符串`s`中出现的起始位置         |
| LastIndexAny(s, chars string) int                      | 查找字符串`s`中出现`chars`中字符的最后位置                   |
| LastIndexByte(s string, c byte) int                    | 查找byte型字符`c`在字符串`s`中的位置                         |
| SplitN(s, sep string, n int) []string                  | 以字符串`sep`为分隔符，将字符串`s`切分成`n`个子串，结果中**不包含**`sep`本身。如果`sep`为空则将`s`切分为 Unicode 字符列表，如果`s`中没有`sep`子串则整个`s`作为切片 []string 中的第一个元素返回。参数`n`表示最多切出几个子串，`s`超出切分大小时，超出部分不再切分。`n`超出切分子串个数时，返回实际切分子串数。如果`n`为 0，则返回 nil；如果`n`小于 0，则不限制切分个数，全部切分 |
| SplitAfterN(s, sep string, n int) []string             | 以字符串`sep`为分隔符，将字符串`s`切分成`n`个子串，结果中**包含**`sep`本身。如果`sep`为空则将`s`切分为 Unicode 字符列表，如果`s`中没有`sep`子串则整个`s`作为切片 []string 中的第一个元素返回。参数`n`表示最多切出几个子串，`s`超出切分大小时，超出部分不再切分。`n`超出切分子串个数时，返回实际切分子串数。如果`n`为 0，则返回 nil；如果`n`小于 0，则不限制切分个数，全部切分 |
| Split(s, sep string) []string                          | 以字符串`sep`为分隔符，将`s`切分成多个子串，结果中**不包含**`sep`本身。如果`sep`为空，则将`s`切分成 Unicode 字符列表，如果`s`中没有`sep`子串，则将整个`s`作为 []string 的第一个元素返回 |
| SplitAfter(s, sep string) []string                     | 以字符串`sep`为分隔符，将`s`切分成多个子串，结果中**包含**`sep`本身。如果`sep`为空则将`s`切分为 Unicode 字符列表，如果`s`中没有`sep`子串则整个`s`作为切片 []string 中的第一个元素返回。 |
| Fields(s string) []string                              | 以连续的空白字符为分隔符，将`s`切分成多个子串，结果中不包含空白字符本身。空白字符有：\t, \n, \v, \f, \r, '', U+0085 (NEL), U+00A0 (NBSP) 。如果`s`中只包含空白字符，则返回一个空切片 |
| FieldsFunc(s string, f func(rune) bool) []string       | 以一个或多个满足函数`f(rune)`的字符为分隔符，将`s`切分成多个子串，结果中不包含分隔符本身。如果`s`中没有满足`f(rune)`的字符，则返回一个空切片 |
| Join(a []string, sep string) string                    | 以`sep`为拼接符，拼接切片`a`中的字符串                       |
| HasPrefix(s, prefix string) bool                       | 判断字符串`s`是否以`prefix`字符串开头，是返回 true，否则返回 false |
| HasSuffix(s, suffix string) bool                       | 判断字符串`s`是否以`suffix`字符串结尾，是返回 true，否则返回 false |
| Map(f func(rune) rune, s string) string                | 将字符串`s`中满足函数`f(rune)`的字符替换为`f(rune)`的返回值。如果`f(rune)`返回负数，则相应的字符将被删除 |
| Repeat(s string, count int) string                     | 返回字符串`s`重复`count`次数后的结果                         |
| ToUpper(s string) string                               | 将字符串`s`中的小写字符转为大写                              |
| ToLower(s string) string                               | 将字符串`s`中的大写字符转为小写                              |
| ToTitle(s string) string                               | 将字符串`s`中的首个单词转为`Title`形式，大部分字符的`Title`格式就是`Upper`格式 |
| ToUpperSpecial(c unicode.SpecialCase, s string) string | 将字符串`s`中的所有字符修改为其大写格式，优先使用`c`中的规则进行转换 |
| ToLowerSpecial(c unicode.SpecialCase, s string) string | 将字符串`s`中的所有字符修改为其小写格式，优先使用`c`中的规则进行转换 |
| ToTitleSpecial(c unicode.SpecialCase, s string) string | 将字符串`s`中的所有字符修改为其`Title`格式，优先使用`c`中的规则进行转换 |
| Title(s string) string                                 | 将字符串`s`中的所有单词的首字母修改为其`Title`格式（BUG: Title 规则不能正确处理 Unicode 标点符号） |
| TrimLeftFunc(s string, f func(rune) bool) string       | 删除字符串`s`左边连续满足`f(rune)`的字符                     |
| TrimRightFunc(s string, f func(rune) bool) string      | 删除字符串`s`右边连续满足`f(rune)`的字符                     |
| TrimFunc(s string, f func(rune) bool) string           | 删除字符串`s`左右两边连续满足`f(rune)`的字符                 |
| IndexFunc(s string, f func(rune) bool) int             | 查找字符串`s`中第一个满足`f(rune)`的字符的字节位置，没有返回 -1 |
| LastIndexFunc(s string, f func(rune) bool) int         | 查找字符串`s`中最后一个满足`f(rune)`的字符的字节位置，没有返回 -1 |
| Trim(s string, cutset string) string                   | 删除字符串`s`左右两边连续包含`cutset`的字符                  |
| TrimLeft(s string, cutset string) string               | 删除字符串`s`左边连续包含`cutset`的字符                      |
| TrimRight(s string, cutset string) string              | 删除字符串`s`右边连续包含`cutset`的字符                      |
| TrimSpace(s string) string                             | 删除字符串`s`左右两边连续的空白字符                          |
| TrimPrefix(s, prefix string) string                    | 删除字符串`s` 头部的`prefix`字符串                           |
| TrimSuffix(s, suffix string) string                    | 删除字符串`s` 尾部的`suffix`字符串                           |
| Replace(s, old, new string, n int) string              | 替换字符串`s`中的`old`为`new`，如果`old`为空则在`s`中的每个字符间插入`new`包括首尾，`n`为替换次数， -1 时替换所有 |
| EqualFold(s, t string) bool                            | 忽略大小写比较字符串`s`和`t`，相同返回 true，反之返回 false  |

**1. 字符串转数字**
 strconv.Atoi：



```go
package main

import (
    "fmt"
    "strconv"
)

func main() {
    var str = "111"
    i, _ := strconv.Atoi(str)
    fmt.Printf("%d\n", i) // 输出：111
}
```

**2. 大小写规则转换**
 strings.ToUpperSpecial：将字符串`s`中的所有字符修改为其大写格式，优先使用`c`中的规则进行转换
 strings.ToLowerSpecial：将字符串`s`中的所有字符修改为其小写格式，优先使用`c`中的规则进行转换
 strings.ToTitleSpecial：将字符串`s`中的所有字符修改为其`Title`格式，优先使用`c`中的规则进行转换
 `c`规则说明，以下列语句为例：
 unicode.CaseRange{'A', 'Z', [unicode.MaxCase]rune{3, -3, 0}}

- 其中 'A', 'Z' 表示此规则只影响 'A' 到 'Z' 之间的字符。
- 其中`[unicode.MaxCase]rune`数组表示：
- 当使用 ToUpperSpecial 转换时，将字符的 Unicode 编码与第一个元素值（3）相加
- 当使用 ToLowerSpecial 转换时，将字符的 Unicode 编码与第二个元素值（-3）相加
- 当使用 ToTitleSpecial 转换时，将字符的 Unicode 编码与第三个元素值（0）相加



```go
package main

import (
    "fmt"
    "strings"
    "unicode"
)

func main() {
    // 定义转换规则
    var _MyCase = unicode.SpecialCase{
        // 将半角逗号替换为全角逗号，ToTitle 不处理
        unicode.CaseRange{',', ',',
            [unicode.MaxCase]rune{'，' - ',', '，' - ',', 0}},
        // 将半角句号替换为全角句号，ToTitle 不处理
        unicode.CaseRange{'.', '.',
            [unicode.MaxCase]rune{'。' - '.', '。' - '.', 0}},
        // 将 ABC 分别替换为全角的 ＡＢＣ、ａｂｃ，ToTitle 不处理
        unicode.CaseRange{'A', 'C',
            [unicode.MaxCase]rune{'Ａ' - 'A', 'ａ' - 'A', 0}},
    }

    s := "ABCDEF,abcdef."
    us := strings.ToUpperSpecial(_MyCase, s)
    fmt.Printf("%q\n", us) // 输出："ＡＢＣDEF，ABCDEF。"
    ls := strings.ToLowerSpecial(_MyCase, s)
    fmt.Printf("%q\n", ls) // 输出："ａｂｃdef，abcdef。"
    ts := strings.ToTitleSpecial(_MyCase, s)
    fmt.Printf("%q\n", ts) // 输出："ABCDEF,ABCDEF."
}
```



### Golang数组array、切片slice、字典map 数据操作

**一、数组 array**
 声明数组时，必须声明数组大小，声明后大小不可变，未赋值的空间默认值为数组存储类型的 0 值。

1. 数组是值类型数据，相同空间大小的数组可以用 `==` 来比较是否相同。



```go
package main

import "fmt"

func main() {
    var a1 = [2]int{1, 2}
    var a2 = [2]int{1, 2}
    fmt.Println(a1 == a2) // 输出：true
}
```

2.数组遍历



```go
package main

import "fmt"

func main() {
    // range 推荐
    arr := [3]string{"aa", "bb", "cc"}
    for index, v := range arr {
        fmt.Printf("index:%d, value:%s\n", index, v)
    }

    // for
    for i := 0; i < len(arr); i++ {
        v := arr[i]
        fmt.Printf("index:%d, value:%s\n", i, v)
    }

}
```

3.数组追加元素
 数组大小固定，所以只能指定元素操作。



```go
package main

import (
    "fmt"
)

func main() {
    var arr = [5]int{1, 2}
    arr[2] = 3
    arr[3] = 4
    fmt.Println(arr) // 输出：[1 4 3 4 0]
}
```

4.数组指针



```go
package main

import (
    "fmt"
)

func main() {
    // 数组指针之间的赋值不会拷贝底层数组的值
    var a1 = &[3]int{1, 2, 3} // 取数组地址
    var a2 *[3]int            // 定义一个数组指针
    a2 = a1                   // 使 a2 指向 a1 地址
    a1[2] = 9
    fmt.Println(*a1) // 输出:[1 2 9]
    fmt.Println(*a2) // 输出:[1 2 9]
}
```

**二、切片 slice**
 切片可以看作是一个可变长的数组，是一个引用类型。它包含三个数据：1.指向数组的指针，2.切片中的元素，3.切片的大小。

1.切片遍历



```go
package main

import "fmt"

func main() {
    sl := []int{1, 2, 3}

    // range
    for i, v := range sl {
        fmt.Printf("index:%d, value:%d\n", i, v)
    }

    for i := 0; i < len(sl); i++ {
        v := sl[i]
        fmt.Printf("index:%d, value:%d\n", i, v)
    }
}
```

2.插入、删除元素
 只要内存足够，切片可以追加任意个元素。



```go
package main

import "fmt"

func main() {
    // 切片末尾追加元素
    sl := make([]int, 0)
    sl = append(sl, 1)
    sl = append(sl, 2, 3)
    fmt.Println(sl) // 输出：[1 2 3]

    // 在索引位置 i 插入元素 x：s = append(s[:i], append([]T{x}, s[i:]...)...)
    // 在索引位置 1 插入元素 4：
    sl = append(sl[:1], append([]int{4}, sl[1:]...)...)
    fmt.Println(sl) // 输出：[1 4 2 3]

    // 在索引位置 i 插入长度为 j 的切片：s = append(s[:i], append(make([]T, j), s[i:]...)...)
    // 在索引位置 2 插入长度为 3 的切片：
    var sl1 = []int{11, 22, 33}
    sl = append(sl[:2], append(sl1, sl[2:]...)...)
    fmt.Println(sl) // 输出：[1 4 11 22 33 2 3]

    // 删除索引位置 i 上元素：s = append(s[:i], s[i+1:]...)
    // 删除索引位置 1 上的元素：
    sl = append(sl[:1], sl[1+1:]...)
    fmt.Println(sl) // 输出：[1 11 22 33 2 3]

    // 删除索引位置 i 到 j 上的元素，杀出元素不包括索引 j 上的元素：s = append(s[:i],s[j:]...)
    // 删除索引位置 2 到 4 上的元素：
    sl = append(sl[:2], sl[4:]...)
    fmt.Println(sl) // 输出：[1 11 2 3]

    // 复制切片，将 a 切片上的元素拷贝到 b 切片上：copy(b, a)
    // 如果切片长度不等，a 长度大于 b 则拷贝len(b) 长度个 a 切片中的元素给 b
    // 如果 a 长度小于 b 则拷贝 a 中元素到 b 中，b 中超出的元素部分保持原值不变
    var a, b []int
    a = []int{1, 2, 3, 4}
    b = []int{11, 22}
    copy(b, a)
    fmt.Println(b) // 输出：[1,2]

    c := make([]int, 5)
    c = []int{11, 22, 33, 44, 55}
    copy(c, a)
    fmt.Println(c) // 输出：[1 2 3 4 55]
}
```

3.排序
 Go 语言 sort 包提供了 sort.Ints() 、sort.Float64s() 和 sort.Strings() 函数，都是从小到大排序：



```swift
package main

import (
    "fmt"
    "sort"
)

func main() {
    intList := []int{5, 3, 2, 1, 4}
    float64List := []float64{5.1, 1.2, 2.34, 4.22, 3.12}
    stringList := []string{`a`, `e`, `d`, `c`, `b`}

    // 正序，从小到大排序
    sort.Ints(intList)
    sort.Float64s(float64List)
    sort.Strings(stringList)
    fmt.Println(intList)     // 输出：[1 2 3 4 5]
    fmt.Println(float64List) // 输出：[1.2 2.34 3.12 4.22 5.1]
    fmt.Println(stringList)  // 输出：[a b c d e]

    // 倒叙，从大到小排序
    sort.Sort(sort.Reverse(sort.IntSlice(intList)))
    sort.Sort(sort.Reverse(sort.Float64Slice(float64List)))
    sort.Sort(sort.Reverse(sort.StringSlice(stringList)))
    fmt.Println(intList)     // 输出：[5 4 3 2 1]
    fmt.Println(float64List) // 输出：[5.1 4.22 3.12 2.34 1.2]
    fmt.Println(stringList)  // 输出：[e d c b a]
}
```

**三、字典 map**
 字典操作：



```go
package main

import "fmt"

func main() {
    m := make(map[string]int, 2)

    // 插入元素
    m["a"] = 11
    m["b"] = 22

    // 遍历 map
    for index, v := range m {
        fmt.Printf("index:%s v%d:\n", index, v)
    }

    // 删除 map 中数据
    delete(m, "a")
    fmt.Println(m) // 输出：map[b:22]
}
```
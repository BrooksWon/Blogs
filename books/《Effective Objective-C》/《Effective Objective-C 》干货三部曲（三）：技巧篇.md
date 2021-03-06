## 《Effective Objective-C 》干货三部曲（三）：技巧篇                       

继上一篇《Effective Objective-C 》超级干货三部曲（二）：规范篇之后，本篇即是三部曲的第三篇：技巧篇。本篇作为三部曲的最终篇，归纳讲解的是本书中关于Objective-C开发的技巧性知识。

三部曲是由笔者将《Effective Objective-C 》这本书的52个知识点分为三大类进行了归类整理而成：

- 概念类：讲解了一些概念性知识。

- 规范类：讲解了一些为了避免一些问题或者为后续开发提供便利所需要遵循的规范性知识。

- 技巧类：讲解了一些为了解决某些特定问题而需要用到的技巧性知识。

  

# 第9条 以“类族模式“隐藏实现细节

在iOS开发中，我们也会使用“类族”(class cluster)这一设计模式，通过“抽象基类”来实例化不同的实体子类。

举个🌰 ：

```
+ (UIButton *)buttonWithType:(UIButtonType)type;
```

> 在这里，我们只需要输入不同的按钮类型(UIButtonType)就可以得到不同的UIButton的子类。在OC框架中普遍使用这一设计模式。

## 为什么要这么做呢?

笔者认为这么做的原因是为了“弱化”子类的具体类型，让开发者无需关心创建出来的子类具体属于哪个类。（这里觉得还有点什么，但是还没有想到，欢迎补充！）

我们可以看一个具体的例子：
对于“员工”这个类，可以有各种不同的“子类型”：开发员工，设计员工和财政员工。这些“实体类”可以由“员工”这个抽象基类来获得：

## 1. 抽象基类

```
//EOCEmployee.h

typedef NS_ENUM(NSUInteger, EOCEmployeeType) {
    EOCEmployeeTypeDeveloper,
    EOCEmployeeTypeDesigner,
    EOCEmployeeTypeFinance,
};

@interface EOCEmployee : NSObject

@property (copy) NSString *name;
@property NSUInteger salary;


// Helper for creating Employee objects
+ (EOCEmployee*)employeeWithType:(EOCEmployeeType)type;

// Make Employees do their respective day's work
- (void)doADaysWork;

@end
//EOCEmployee.m

@implementation EOCEmployee

+ (EOCEmployee*)employeeWithType:(EOCEmployeeType)type {
     switch (type) {
         case EOCEmployeeTypeDeveloper:
            return [EOCEmployeeDeveloper new];
         break; 

        case EOCEmployeeTypeDesigner:
             return [EOCEmployeeDesigner new];
         break;

        case EOCEmployeeTypeFinance:
             return [EOCEmployeeFinance new];
         break;
    }
}

- (void)doADaysWork {
 // 需要子类来实现
}



@end
```

> 我们可以看到，将EOCEmployee作为抽象基类，这个抽象基类有一个初始化方法，通过这个方法，我们可以得到多种基于这个抽象基类的实体子类:

## 2. 实体子类（concrete subclass）:

```
@interface EOCEmployeeDeveloper : EOCEmployee
@end

@implementation EOCEmployeeDeveloper

- (void)doADaysWork {
    [self writeCode];
}

@end
```

> **注意：**
> 如果对象所属的类位于某个类族中，那么在查询类型信息时就要小心。因为类族中的实体子类并不与其基类属于同一个类。

# 第10条：在既有类中使用关联对象存放自定义数据

我们可以通“关联对象”机制来把两个对象连接起来。这样我们就可以从某个对象中获取相应的关联对象的值。

先看一下关联对象的语法：

## 1. 为某个对象设置关联对象的值：

```
void objc_setAssociatedObject(id object, void *key, id value, objc_AssociationPolicy policy)
```

> 这里，第一个参数是主对象，第二个参数是键，第三个参数是关联的对象，第四个参数是存储策略:是枚举，定义了内存管理语义。

## 2. 根据给定的键从某对象中获取相应的关联对象值：

```
id objc_getAssociatedObject(id object, void *key)
```

## 3. 移除指定对象的关联对象：

```
void objc_removeAssociatedObjects(id object)
```

举个例子：

```
#import <objc/runtime.h>

static void *EOCMyAlertViewKey = "EOCMyAlertViewKey";


- (void)askUserAQuestion {

         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Question"
                                                         message:@"What do you want to do?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Continue", nil];

         void (^block)(NSInteger) = ^(NSInteger buttonIndex){

                     if (buttonIndex == 0) {
                            [self doCancel];
                     } else {
                            [self doContinue];
                    }
         };

         //将alert和block关联在了一起
         objc_setAssociatedObject(alert,EOCMyAlertViewKey,block, OBJC_ASSOCIATION_COPY);
         [alert show];
}

// UIAlertViewDelegate protocol method
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     //alert取出关联的block
      void (^block)(NSInteger) = objc_getAssociatedObject(alertView, EOCMyAlertViewKey)
     //给block传入index值
      block(buttonIndex);
}
```

# 第13条：用“方法调配技术”调试“黑盒方法”

与选择子名称相对应的方法是可以在运行期被改变的，所以，我们可以不用通过继承类并覆写方法就能改变这个类本身的功能。

那么如何在运行期改变选择子对应的方法呢？
答：通过操纵类的方法列表的IMP指针

什么是类方法表？什么是IMP指针呢？

> 类的方法列表会把**选择子**的名称映射到相关的方法实现上，使得“动态消息派发系统”能够据此找到应该调用的方法。这些方法均以函数指针的形式来表示，这些指针叫做IMP。例如NSString类的选择子列表：

![类方法表的映射](https://mmbiz.qpic.cn/mmbiz_png/5Q64GJWEUKUTicB3uBU7QQPjcwbF7AicEzkWMga7g8huZK9FP53LAUxDmI1zxcFFzJqQYethuFmDvDxGvMBhXMBQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)类方法表的映射

有了这张表，OC的运行期系统提供的几个方法就能操纵它。开发者可以向其中增加选择子，也可以改变某选择子对应的方法实现，也可以交换两个选择子所映射到的指针以达到交换方法实现的目的。

举个 ：交换`lowercaseString`和`uppercaseString`方法的实现：

```
Method originalMethod = class_getInstanceMethod([NSString class], @selector(lowercaseString));
Method swappedMethod = class_getInstanceMethod([NSString class],@selector(uppercaseString));

method_exchangeImplementations(originalMethod, swappedMethod);
```

> 这样一来，类方法表的映射关系就变成了下图：

![交换两个方法](https://mmbiz.qpic.cn/mmbiz_png/5Q64GJWEUKUTicB3uBU7QQPjcwbF7AicEz50k4zoT47dTdrHEJ18AtsEICCe5AXic71CAMUeGmyuefeR1M4PIfSZQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)交换两个方法

> 这时，如果我们调用lowercaseString方法就会实际调用uppercaseString的方法，反之亦然。

**然而！**
在实际应用中，只交换已经存在的两个方法是没有太大意义的。我们应该利用这个特性来给既有的方法添加新功能（听上去吊吊的）：

它的实现原理是：先通过分类增加一个新方法，然后将这个新方法和要增加功能的旧方法替换（旧方法名 对应新方法的实现），这样一来，如果我们调用了旧方法，就会实现新方法了。

不知道这么说是否抽象。还是举个 ：

**需求：**我们要在原有的lowercaseString方法中添加一条输出语句。

## 步骤一：我们先将新方法写在NSString的分类里：

```
@interface NSString (EOCMyAdditions)
- (NSString*)eoc_myLowercaseString;
@end


@implementation NSString (EOCMyAdditions)

- (NSString*)eoc_myLowercaseString {
     NSString *lowercase = [self eoc_myLowercaseString];//eoc_myLowercaseString方法会在将来方法调换后执行lowercaseString的方法
     NSLog(@"%@ => %@", self, lowercase);//输出语句，便于调试
     return lowercase;
}
@end
```

## 步骤二：交换两个方法的实现（操纵调换IMP指针）

```
Method originalMethod =
 class_getInstanceMethod([NSString class],
 @selector(lowercaseString));
Method swappedMethod =
 class_getInstanceMethod([NSString class],
 @selector(eoc_myLowercaseString));

method_exchangeImplementations(originalMethod, swappedMethod);
```

这样一来，我们如果交换了`lowercaseString`和`eoc_myLowercaseString`的方法实现，那么在调用原来的`lowercaseString`方法后就可以输出新增的语句了。

```
“NSString *string = @"ThIs iS tHe StRiNg";
NSString *lowercaseString = [string lowercaseString];
// Output: ThIs iS tHe StRiNg => this is the string”
```

# 第16条：提供"全能初始化方法"

有时，由于要实现各种设计需求，一个类可以有多个创建实例的初始化方法。我们应该**选定其中一个**作为**全能初始化方法**，令其他初始化方法都来调用它。

> **注意**：
>
> - 只有在这个全能初始化方法里面才能存储内部数据。这样一来，当底层数据存储机制改变时，只需修改此方法的代码就好，无需改动其他初始化方法。
> - 全能初始化方法是所有初始化方法里参数最多的一个，因为它使用了尽可能多的初始化所需要的参数，以便其他的方法来调用自己。
> - 在我们拥有了一个全能初始化方法后，最好还是要覆写init方法来设置默认值。

```
//全能初始化方法
- (id)initWithWidth:(float)width andHeight:(float)height
{
     if ((self = [super init])) {
        _width = width;
        _height = height;
    }
    return self;
}

//init方法也调用了全能初始化方法
- (id)init {
     return [self initWithWidth:5.0f andHeight:10.0f];
}
```

现在，我们要创造一个squre类继承这上面这个ractangle类,它有自己的全能初始化方法：

```
- (id)initWithDimension: (float)dimension{
    return [super initWithWidth:dimension andHeight:dimension];
}
```

## 这里有问题！

然而，因为square类是rectangle类的子类，那么它也可以使用`initWithWidth: andHeight:`方法，更可以使用`init`方法。那么这两种情况下，显然是无法确保初始化的图形是正方形。

因此，我们需要在这里覆写square的父类rectangle的全能初始化方法：

```
- (id)initWithWidth:(float)width andHeight:(float)height
{
    float dimension = MAX(width, height);
    return [self initWithDimension:dimension];
}
```

这样一来，当square用`initWithWidth: andHeight:`方法初始化时，就会得到一个正方形。

并且，如果用`init`方法来初始化square的话，我们也可以得到一个默认的正方形。因为在rectangle类里覆写了init方法，而这个init方法又调用了`initWithWidth: andHeight:`方法，并且square类又覆写了`initWithWidth: andHeight:`方法，所以我们仍然可以得到一个正方形。

而且，为了让square的init方法得到一个默认的正方形，我们也可以覆写它自己的初始化方法：

```
- (id)init{
    return [self initWithDimension:5.0f];
}
```

我们做个总结：

因为子类的全能初始化方法（initWithDimension:）和其父类的初始化方法并不同，所以我们需要在子类里覆写`initWithWidth: andHeight:`方法。

## 还差一点：initWithCoder:的初始化

有时，需要定义两种全能初始化方法，因为对象有可能有两种完全不同的创建方式，例如`initWithCoder:`方法。

我们仍然需要调用超类的初始化方法：

在rectangle类：

```
// Initializer from NSCoding
- (id)initWithCoder:(NSCoder*)decoder {

     // Call through to super's designated initializer
         if ((self = [super init])) {
            _width = [decoder decodeFloatForKey:@"width"];
            _height = [decoder decodeFloatForKey:@"height"];
        }
     return self;
}
```

在square类：

```
// Initializer from NSCoding
- (id)initWithCoder:(NSCoder*)decoder {

 // Call through to super's designated initializer
      if ((self = [super initWithCoder:decoder])) {
     // EOCSquare's specific initializer
    }
     return self;
}
```

每个子类的全能初始化方法都应该调用其超类的对应方法，并逐层向上。在调用了超类的初始化方法后，再执行与本类相关的方法。

# 第17条：实现description方法

在打印我们自己定义的类的实例对象时，在控制台输出的结果往往是这样的：

```
object = <EOCPerson: 0x7fd9a1600600>
```

> 这里只包含了类名和内存地址，它的信息显然是不具体的,远达不到调试的要求。

**但是！**如果在我们自己定义的类覆写description方法，我们就可以在打印这个类的实例时输出我们想要的信息。

例如：

```
- (NSString*)description {
     return [NSString stringWithFormat:@"<%@: %p, %@ %@>", [self class], self, firstName, lastName];
}
```

在这里，显示了内存地址，还有该类的所有属性。

而且，如果我们将这些属性值放在字典里打印，则更具有可读性：

```
- (NSString*)description {

     return [NSString stringWithFormat:@"<%@: %p, %@>",[self class],self,

    @{    @"title":_title,
       @"latitude":@(_latitude),
      @"longitude":@(_longitude)}
    ];
}
```

输出结果：

```
location = <EOCLocation: 0x7f98f2e01d20, {

    latitude = "51.506";
   longitude = 0;
       title = London;
}>
```

> 我们可以看到，通过重写`description`方法可以让我们更加了解对象的情况，便于后期的调试，节省开发时间。

# 第28条:通过协议提供匿名对象

匿名对象（Annonymous object），可以理解为“没有名字的对象”。有时我们用协议来提供匿名对象，目的在于说明它仅仅表示“遵从某个协议的对象”，而不是“属于某个类的对象”。

它的表示方法为：`id<protocol>`。
通过协议提供匿名对象的主要使用场景有两个：

- 作为属性
- 作为方法参数

## 1. 匿名对象作为属性

在设定某个类为自己的代理属性时，可以不声明代理的类，而是用id，因为**成为**代理的终点并不是**某个类的实例**，而是**遵循了某个协议**。

举个 ：

```
@property (nonatomic, weak) id <EOCDelegate> delegate;
```

在这里使用匿名对象的原因有两个：

1. 将来可能会有很多不同类的实例对象作为该类的代理。
2. 我们不想指明具体要使用哪个类来作为这个类的代理。

也就是说，能作为该类的代理的条件只有一个：它遵从了协议。

## 2. 匿名对象作为方法参数

有时，我们不会在意方法里某个参数的具体类型，而是遵循了某种协议，这个时候就可以使用匿名对象来作为方法参数。

举个 ：

```
- (void)setObject:(id)object forKey:(id<NSCopying>)key;
```

这个方法是NSDictionary的设值方法，它的参数只要遵从了协议，就可以作为参数传进去,作为NSDictionary的键。

# 第32条：编写“异常安全代码”时留意内存管理问题

在发生异常时的内存管理需要仔细考虑内存管理的问题：

> 在try块中，如果先保留了某个对象，然后在释放它之前又抛出了异常，那么除非在catch块中能处理此问题，否则对象所占内存就将泄漏。

## 在MRC环境下：

```
@try {
     EOCSomeClass *object = [[EOCSomeClass alloc] init];
      [object doSomethingThatMayThrow];
      [object release];

}


@catch (...) {
         NSLog(@"Whoops, there was an error. Oh well...");
}
```

这里，我们用release方法释放了try中的对象，但是这样做仍然有问题：如果在`doSomthingThatMayThrow`方法中抛出了异常了呢？

这样就无法执行`release`方法了。

解决办法是使用@finnaly块，无论是否抛出异常，其中的代码都能运行：

```
EOCSomeClass *object;
@try {
    object = [[EOCSomeClass alloc] init];
    [object doSomethingThatMayThrow];
}



@catch (...) {
     NSLog(@"Whoops, there was an error. Oh well...");
}

@finally {
    [object release];
}
```

## 在ARC环境下呢？

```
@try {
     EOCSomeClass *object = [[EOCSomeClass alloc] init];
     [object doSomethingThatMayThrow];
}



@catch (...) {
 NSLog(@"Whoops, there was an error. Oh well...");
}
```

这时，我们无法手动使用`release`方法了，解决办法是使用：-fobjc-arc-exceptions 标志来加入清理代码，不过会导致应用程序变大，而且会降低运行效率。

# 第33条：以弱引用避免保留环

对象之间都用强指针引用对方的话会造成保留环。

## 两个对象的保留环：

两个对象都有一个对方的实例来作为自己的属性：

```
@interface EOCClassA : NSObject
@property (nonatomic, strong) EOCClassB *other;
@end


@interface EOCClassB : NSObject
@property (nonatomic, strong) EOCClassA *other;
@end
```

![两个对象的保留环](https://mmbiz.qpic.cn/mmbiz_png/5Q64GJWEUKUTicB3uBU7QQPjcwbF7AicEzhVul1Ub2IFrP4ia5iaTU1jJiabBr4K3gSWqmYgBw990nRXWjTq6YWPPug/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)两个对象的保留环

两个对象都有指向对方的强指针，这样会导致这两个属性里的对象无法被释放掉。

## 多个对象的保留环：

如果保留环连接了多个对象，而这里其中一个对象被外界引用，那么当这个引用被移除后，整个保留环就泄漏了。

![多个对象的保留环：孤岛](https://mmbiz.qpic.cn/mmbiz_png/5Q64GJWEUKUTicB3uBU7QQPjcwbF7AicEzRp8f6OkiavQfpNhF4Z6mlWdF1OIibYmLcYtheT4y8VZlp7Skd9079szQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)多个对象的保留环：孤岛

解决方案是使用弱引用：

```
//EOCClassB.m
//第一种弱引用：unsafe_unretained
@property (nonatomic, unsafe_unretained) EOCClassA *other;


//第二种弱引用：weak
@property (nonatomic, weak) EOCClassA *other;
```

这两种弱引用有什么区别呢？

unsafe_unretained:当指向EOCClassA实例的引用移除后，unsafe_unretained属性仍然指向那个已经回收的实例，

而weak指向nil：

![unsafe_unretained 和 weak的区别](https://mmbiz.qpic.cn/mmbiz_png/5Q64GJWEUKUTicB3uBU7QQPjcwbF7AicEzu2spTx9ias2uDJT8L04HHDeIZWaz15DTytTwRh0zne3jMxTm8IXZqXQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)unsafe_unretained 和 weak的区别

显然，用weak字段应该是更安全的，因为不再使用的对象按理说应该设置为nil,而不应该产生依赖。

# 第34条：以“自动释放池快”降低内存峰值

------

释放对象的两种方式：

- 调用release:保留计数递减
- 调用autorelease将其加入自动释放池中。在将来清空自动释放池时，系统会向其中的对象发送release消息。

内存峰值（high-memory waterline）是指应用程序在某个限定时段内的最大内存用量（highest memory footprint）。新增的自动释放池块可以减少这个峰值：

不用自动释放池减少峰值：

```
for (int i = 0; i < 100000; i++) {

      [self doSomethingWithInt:i];

}
```

在这里，`doSomethingWithInt:`方法可能会创建临时对象。随着循环次数的增加，临时对象的数量也会飙升，而只有在整个for循环结束后，这些临时对象才会得意释放。

这种情况是不理想的，尤其在我们无法控制循环长度的情况下，我们会不断占用内存并突然释放掉它们。

因此，我们需要用自动释放池来降低这种突兀的变化：

```
NSArray *databaseRecords = /* ... */;
NSMutableArray *people = [NSMutableArray new];
for (NSDictionary *record in databaseRecords) {
     @autoreleasepool {
             EOCPerson *person = [[EOCPerson alloc] initWithRecord:record];
            [people addObject:person];
      }
}
```

> 这样一来，每次循环结束，我们都会将临时对象放在这个池里面，而不是线程的主池里面。

# 第35条：用“僵尸对象”调试内存管理问题

某个对象被回收后，再向它发送消息是不安全的，这并不一定会引起程序崩溃。

如果程序没有崩溃，可能是因为：

- 该内存的部分原数据没有被覆写。
- 该内存恰好被另一个对象占据，而这个对象可以应答这个方法。

如果被回收的对象占用的原内存被新的对象占据，那么收到消息的对象就不会是我们预想的那个对象。在这样的情况下，如果这个对象无法响应那个方法的话，程序依旧会崩溃。

因此，我们希望可以通过一种方法捕捉到**对象被释放后收到消息的情况**。

这种方法就是**利用僵尸对象！**

Cocoa提供了“僵尸对象”的功能。如果开启了这个功能，运行期系统会把所有已经回收的实例转化成特殊的“僵尸对象”（通过修改isa指针，令其指向特殊的僵尸类），而不会真正回收它们，而且它们所占据的核心内存将无法被重用，这样也就避免了覆写的情况。

在僵尸对象收到消息后，会抛出异常，它会说明发送过来的消息，也会描述回收之前的那个对象。

# 第38条：为常用的块类型创建typedef

如果我们需要重复创建某种块（相同参数，返回值）的变量，我们就可以通过typedef来给某一种块定义属于它自己的新类型

例如：

```
int (^variableName)(BOOL flag, int value) =^(BOOL flag, int value){
     // Implementation
     return someInt;
}
```

这个块有一个bool参数和一个int参数，并返回int类型。我们可以给它定义类型：

```
typedef int(^EOCSomeBlock)(BOOL flag, int value);
```

再次定义的时候，就可以通过简单的赋值来实现：

```
EOCSomeBlock block = ^(BOOL flag, int value){
     // Implementation
};
```

定义作为参数的块：

```
- (void)startWithCompletionHandler: (void(^)(NSData *data, NSError *error))completion;
```

这里的块有一个NSData参数，一个NSError参数并没有返回值

```
typedef void(^EOCCompletionHandler)(NSData *data, NSError *error);
- (void)startWithCompletionHandler:(EOCCompletionHandler)completion;”
```

通过typedef定义块签名的好处是:如果要某种块增加参数，那么只修改定义签名的那行代码即可。

# 第39条：用handler块降低代码分散程度

下载网络数据时，如果使用代理方法，会使得代码分布不紧凑，而且如果有多个下载任务的话，还要在回调的代理中判断当前请求的类型。但是如果使用block的话，就可以让网络下载的代码和回调处理的代码写在一起，这样就可以同时解决上面的两个问题：

## 用代理下载：

```
- (void)fetchFooData {

     NSURL *url = [[NSURL alloc] initWithString:@"http://www.example.com/foo.dat"];
    _fooFetcher = [[EOCNetworkFetcher alloc] initWithURL:url];
    _fooFetcher.delegate = self;
    [_fooFetcher start];

}

- (void)fetchBarData {

     NSURL *url = [[NSURL alloc] initWithString: @"http://www.example.com/bar.dat"];
    _barFetcher = [[EOCNetworkFetcher alloc] initWithURL:url];
    _barFetcher.delegate = self;
    [_barFetcher start];

}

- (void)networkFetcher:(EOCNetworkFetcher*)networkFetcher didFinishWithData:(NSData*)data
{   //判断下载器类型
     if (networkFetcher == _fooFetcher) {
        _fetchedFooData = data;
        _fooFetcher = nil;

    } else if (networkFetcher == _barFetcher) {
        _fetchedBarData = data;
        _barFetcher = nil;
    }
}
```

## 用block下载：

```
- (void)fetchFooData {

     NSURL *url = [[NSURL alloc] initWithString:@"http://www.example.com/foo.dat"];
     EOCNetworkFetcher *fetcher =
     [[EOCNetworkFetcher alloc] initWithURL:url];
     [fetcher startWithCompletionHandler:^(NSData *data){
            _fetchedFooData = data;
   }];

}



- (void)fetchBarData {

     NSURL *url = [[NSURL alloc] initWithString: @"http://www.example.com/bar.dat"];
     EOCNetworkFetcher *fetcher =[[EOCNetworkFetcher alloc] initWithURL:url];
    [fetcher startWithCompletionHandler:^(NSData *data){
            _fetchedBarData = data;
    }];

}
```

还可以将处理成功的代码放在一个块里，处理失败的代码放在另一个块中：

```
“#import <Foundation/Foundation.h>

@class EOCNetworkFetcher;
typedef void(^EOCNetworkFetcherCompletionHandler)(NSData *data);
typedef void(^EOCNetworkFetcherErrorHandler)(NSError *error);


@interface EOCNetworkFetcher : NSObject

- (id)initWithURL:(NSURL*)url;
- (void)startWithCompletionHandler: (EOCNetworkFetcherCompletionHandler)completion failureHandler: (EOCNetworkFetcherErrorHandler)failure;

@end



EOCNetworkFetcher *fetcher =[[EOCNetworkFetcher alloc] initWithURL:url];
[fetcher startWithCompletionHander:^(NSData *data){
     // Handle success
}

 failureHandler:^(NSError *error){
 // Handle failure
}];
```

> 这样写的好处是，我们可以将处理成功和失败的代码分开来写，看上去更加清晰。

我们还可以将 成功和失败的代码都放在同一个块里：

```
“#import <Foundation/Foundation.h>


@class EOCNetworkFetcher;
typedef void(^EOCNetworkFetcherCompletionHandler)(NSData *data, NSError *error);

@interface EOCNetworkFetcher : NSObject

- (id)initWithURL:(NSURL*)url;
- (void)startWithCompletionHandler:

(EOCNetworkFetcherCompletionHandler)completion;

@end



EOCNetworkFetcher *fetcher =[[EOCNetworkFetcher alloc] initWithURL:url];

[fetcher startWithCompletionHander:

^(NSData *data, NSError *error){

if (error) {

     // Handle failure

} else {

     // Handle success

}
}];
```

> 这样做的好处是，如果及时下载失败或中断了，我们仍然可以取到当前所下载的data。而且，如果在需求上指出：下载成功后得到的数据很少，也视为失败，那么单一块的写法就很适用，因为它可以取得数据后（成功）再判断其是否是下载成功的。

# 第40条：用块引用其所属对象时不要出现保留环

如果块捕获的对象直接或间接地保留了块本身，那么就需要小心保留环问题:

```
@implementation EOCClass {

     EOCNetworkFetcher *_networkFetcher;
     NSData *_fetchedData;

}


- (void)downloadData {

     NSURL *url = [[NSURL alloc] initWithString:@"http://www.example.com/something.dat"];
    _networkFetcher =[[EOCNetworkFetcher alloc] initWithURL:url];

    [_networkFetcher startWithCompletionHandler:^(NSData *data){

             NSLog(@"Request URL %@ finished", _networkFetcher.url);
            _fetchedData = data;

    }];

}
```

在这里出现了保留环：块要设置_fetchedData变量，就需要捕获self变量。而self（EOCClass实例）通过实例变量保留了获取器_networkFetcher，而_networkFetcher又保留了块。

解决方案是：在块中取得了data后，将_networkFetcher设为nil。

```
- (void)downloadData {

     NSURL *url = [[NSURL alloc] initWithString:@"http://www.example.com/something.dat"];
    _networkFetcher =[[EOCNetworkFetcher alloc] initWithURL:url];
    [_networkFetcher startWithCompletionHandler:^(NSData *data){

             NSLog(@"Request URL %@ finished", _networkFetcher.url);
            _fetchedData = data;
            _networkFetcher = nil;

    }];

}
```

# 第41条：多用派发队列，少用同步锁

多个线程执行同一份代码时，很可能会造成数据不同步。作者建议使用GCD来为代码加锁的方式解决这个问题。

## 方案一：使用串行同步队列来将读写操作都安排到同一个队列里：

```
_syncQueue = dispatch_queue_create("com.effectiveobjectivec.syncQueue", NULL);

//读取字符串
- (NSString*)someString {

         __block NSString *localSomeString;
         dispatch_sync(_syncQueue, ^{
            localSomeString = _someString;
        });
         return localSomeString;

}

//设置字符串
- (void)setSomeString:(NSString*)someString {

     dispatch_sync(_syncQueue, ^{
        _someString = someString;
    });
}
```

这样一来，读写操作都在串行队列进行，就不容易出错。

> getter方法中，用一个临时变量来保存值，是因为在block中return的话，只是return到block中了，没有真正返回到对应的getter方法中，而__block是为了可以在block中改变改临时变量而用。
>
> 虽然问题解决了，但是我们还可以进一步优化。设置方法不一定非得是同步的。设置实例变量所用的块，并不需要向设置方法返回什么值。那代码可以改成：
>
> ```
> - (void)setSomeString:(NSString *)someString {
>     dispatch_async(_syncQueue, ^{
>         _someString = someString;
>     });
> }
> ```
>
> 这次把同步改成了异步，也许看来，这样改动，性能是会有提升的，但是你测一下程序的性能，可能会发现这种写法比原来慢。因为执行异步派发时，是需要拷贝块。若拷贝块所用的时间明显超过执行块所需的时间，则这种做法将比原来的更慢。
>  *注：本例子代码比较简单，若是要执行的块代码逻辑比较复杂的话，那么该写法可能还是比原来的块些*

但是，还有一种方法可以让性能更高：

## 方案二：将**写操作**放入栅栏快中，让他们单独执行；将**读取操作**并发执行。

对于属性的读写，我们希望多个获取方法可以并发执行，而获取方法与设置方法之间不能并发执行，利用这个特点，还能写出更快一些的代码来。此时正可体现出GCD的好处。而用同步锁或锁对象，是无法轻易实现下面这种方案的。这次我们使用并发队列：

```
@property (nonatomic,strong) dispatch_queue_t syncQueue;

_syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

- (NSString *)someString {
    __block NSString *localSomeString;
    dispatch_sync(_syncQueue, ^{
        localSomeString = _someString;
    });
    return localSomeString;
}

- (void)setSomeString:(NSString *)someString {
    dispatch_async(_syncQueue, ^{
        _someString = someString;
    });
}
```

以上代码，还无法正确实现同步。因为所有读写操作都会在同一个队列上执行，而该队列是并发队列，所有读取和写入操作都可以随时执行，没有达到同步效果。此问题我们可以通过一个简单的GCD功能解决--栅栏（barrier）。下列函数可以向队列中派发块，将其作为栅栏使用：

```
void dispatch_barrier_async(dispatch_queue_t queue, dispatch_block_t block);
void dispatch_barrier_sync(dispatch_queue_t queue, dispatch_block_t block);
```

*注：dispatch_barrier_async如果传入自己创建的并行队列时，会阻塞当前队列执行，而不阻塞当前线程。 dispatch_barrier_sync如果传入自己创建的并行队列时，阻塞当前队列的同时也会阻塞当前线程，请注意*

并发队列如果发现接下来要处理的块是个栅栏块，那么就一直要等当前所有并发块都执行完毕，才会单独执行这个栅栏块。这待栅栏块执行完毕，在按正常方式继续向下处理。这样就解决了并发队列的同步问题。

###### GCD并发队列中加入栅栏

本例中，可以用栅栏块来实现属性的设置方法。在设置方法中使用了栅栏块之后，对属性的读取操作依然可以并发执行，但写入操作却必须单独执行了。在下图中演示的这个队列中，有多个读取操作，而且还有一个写入操作。



![img](https:////upload-images.jianshu.io/upload_images/809937-fcbe13f93e3110a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/225)

在这个并发队列中，读取操作是用普通的块来实现的，而写入操作则是用栅栏块来实现的 读取操作可以并行，但写入操作必须单独执行，因为它是栅栏块

实现代码很简单：

```
@property (nonatomic,strong) dispatch_queue_t syncQueue;

//_syncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
/* 这里应该使用自己创建的并发队列，因为苹果文档中指出，如果使用的是全局队列或者创建的不是并发队列，
则dispatch_barrier_async实际上就相当于dispatch_async，就达不到我们想要的效果了 */
_syncQueue = dispatch_queue_create("com.effetiveobjectivec.syncQueue", DISPATCH_QUEUE_CONCURRENT);

- (NSString *)someString {
    __block NSString *localSomeString;
    dispatch_sync(_syncQueue, ^{
        localSomeString = _someString;
    });
    return localSomeString;
}

- (void)setSomeString:(NSString *)someString {
    dispatch_barrier_async(_syncQueue, ^{
        _someString = someString;
    });
}
```

测试一下性能，你就会发现，这种做法肯定比使用串行队列要快。其中，设置函数也可以改用同步栅栏块来实现，那样做可能会更高效，其原因之前已经解释过了——*这里就要权衡拷贝块的时间和块执行时间了*

> 显然，数据的正确性主要取决于写入操作，那么只要保证写入时，线程是安全的，那么即便读取操作是并发的，也可以保证数据是同步的。
>
> 这里的`dispatch_barrier_async`方法使得操作放在了同步队列里“有序进行”，保证了写入操作的任务是在串行队列里。

# 第42条：多用GCD，少用performSelector系列方法

在iOS开发中，有时会使用performSelector来执行某个方法，但是performSelector系列的方法能处理的选择子很局限：

- 它无法处理带有多个参数的选择子。
- 返回值只能是void或者对象类型。

但是如果将方法放在块中，通过GCD来操作就能很好地解决这些问题。尤其是我们如果想要让一个任务在另一个线程上执行，最好应该将任务放到块里，交给GCD来实现，而不是通过performSelector方法。

举几个 来比较这两种方案：

## 1. 延后执行某个任务的方法：

```
// 使用 performSelector:withObject:afterDelay:
[self performSelector:@selector(doSomething) withObject:nil afterDelay:5.0];


// 使用 dispatch_after
dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
dispatch_after(time, dispatch_get_main_queue(), ^(void){
    [self doSomething];
});
```

## 2. 将任务放在主线程执行：

```
// 使用 performSelectorOnMainThread:withObject:waitUntilDone:
[self performSelectorOnMainThread:@selector(doSomething) withObject:nil waitUntilDone:NO];


// 使用 dispatch_async
// (or if waitUntilDone is YES, then dispatch_sync)
dispatch_async(dispatch_get_main_queue(), ^{
        [self doSomething];
});
```

> 注意：
> 如果waitUntilDone的参数是Yes，那么就对应GCD的dispatch_sync方法。
> 我们可以看到，使用GCD的方式可以将线程操作代码和方法调用代码写在同一处，一目了然；而且完全不受调用方法的选择子和方法参数个数的限制。

# 第43条：掌握GCD及操作队列的使用时机

除了GCD，操作队列（NSOperationQueue）也是解决多线程任务管理问题的一个方案。对于不同的环境，我们要采取不同的策略来解决问题：有时候使用GCD好些，有时则是使用操作队列更加合理。

使用NSOperation和NSOperationQueue的优点：

1. 可以取消操作：在运行任务前，可以在NSOperation对象调用cancel方法，标明此任务不需要执行。但是GCD队列是无法取消的，因为它遵循“安排好之后就不管了（fire and forget）”的原则。
2. 可以指定操作间的依赖关系：例如从服务器下载并处理文件的动作可以用操作来表示。而在处理其他文件之前必须先下载“清单文件”。而后续的下载工作，都要依赖于先下载的清单文件这一操作。
3. 监控NSOperation对象的属性：可以通过KVO来监听NSOperation的属性：可以通过isCancelled属性来判断任务是否已取消；通过isFinished属性来判断任务是否已经完成。
4. 可以指定操作的优先级：操作的优先级表示此操作与队列中其他操作之间的优先关系，我们可以指定它。

# 第44条：通过Dispath Group机制，根据系统资源状况来执行任务

有时需要**等待**多个并行任务结束的那一刻执行某个任务，这个时候就可以使用dispath group函数来实现这个需求：

通过dispath group函数，可以把并发执行的多个任务合为一组，于是调用者就可以知道这些任务何时才能全部执行完毕。

```
//一个优先级低的并发队列
dispatch_queue_t lowPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);

//一个优先级高的并发队列
dispatch_queue_t highPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);

//创建dispatch_group
dispatch_group_t dispatchGroup = dispatch_group_create();

//将优先级低的队列放入dispatch_group
for (id object in lowPriorityObjects) {
 dispatch_group_async(dispatchGroup,lowPriorityQueue,^{ [object performTask]; });
}

//将优先级高的队列放入dispatch_group
for (id object in highPriorityObjects) {
 dispatch_group_async(dispatchGroup,highPriorityQueue,^{ [object performTask]; });
}

//dispatch_group里的任务都结束后调用块中的代码
dispatch_queue_t notifyQueue = dispatch_get_main_queue();
dispatch_group_notify(dispatchGroup,notifyQueue,^{
     // Continue processing after completing tasks
});
```

# 第45条：使用dispatch_once来执行只需运行一次的线程安全代码

有时我们可能只需要将某段代码执行一次，这时可以通过dispatch_once函数来解决。

dispatch_once函数比较重要的使用例子是单例模式：
我们在创建单例模式的实例时，可以使用dispatch_once函数来令初始化代码只执行一次，并且内部是线程安全的。

而且，对于执行一次的block来说，每次调用函数时传入的标记都必须完全相同，通常标记变量声明在static或global作用域里。

```
+ (id)sharedInstance {

     static EOCClass *sharedInstance = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
﻿            sharedInstance = [[self alloc] init];
    });
     return sharedInstance;
}
```

> 我们可以这么理解：在dispatch_once块中的代码在程序启动到终止的过程里，只要运行了一次后，就给自己加上了注释符号，不再存在了。

# 第49条：对自定义其内存管理语义的collection使用无缝桥接

通过无缝桥接技术，可以再Foundation框架中的OC对象和CoreFoundation框架中的C语言数据结构之间来回转换。

创建CoreFoundation中的collection时，可以指定如何处理其中的元素。然后利用无缝桥接技术，可以将其转换为OCcollection。

简单的无缝桥接演示：

```
NSArray *anNSArray = @[@1, @2, @3, @4, @5];
CFArrayRef aCFArray = (__bridge CFArrayRef)anNSArray;
NSLog(@"Size of array = %li", CFArrayGetCount(aCFArray));
```

这里，`__bridge`表示ARC仍然具备这个OC对象的所有权。`CFArrayGetCount`用来获取数组的长高度。

为什么要使用无缝桥接技术呢？因为有些OC对象的特性是其对应的CF数据结构不具备的，反之亦然。因此我们需要通过无缝桥接技术来让这两者进行功能上的“互补”。



版权来源：https://mp.weixin.qq.com/s/3adIOoyK5liG_meDm5yatA
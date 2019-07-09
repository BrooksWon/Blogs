# 需求点


```
实现下面这样的需求：

用代码模拟一个实际项目开发的场景：前端和后端开发人员开发同一个项目。
```

## 思考一下，这样的设计有什么问题？

#### 问题一：
假如后台的开发语言改成了GO语言，那么上述代码需要改动两个地方：

BackEndDeveloper:需要向外提供一个writeGolangCode方法。
Project类的startDeveloping方法里面需要将BackEndDeveloper类的writeJavaCode改成writeGolangCode。

#### 问题二：
假如后期老板要求做移动端的APP（需要iOS和安卓的开发者），那么上述代码仍然需要改动两个地方：

还需要给Project类的构造器方法里面传入IOSDeveloper和AndroidDeveloper两个类。而且按照现有的设计，还要分别向外部提供writeSwiftCode和writeKotlinCode。
Project类的startDeveloping方法里面需要再多两个elseif判断，专门判断IOSDeveloper和AndroidDeveloper这两个类。

很显然，在这两种假设的场景下，高层模块（Project）都依赖了低层模块（BackEndDeveloper）的改动，因此上述设计不符合依赖倒置原则。
那么该如何设计才可以符合依赖倒置原则呢？
答案是将开发者写代码的方法抽象出来，让Project类不再依赖所有低层的开发者类的具体实现，而是依赖抽象。而且从下至上，所有底层的开发者类也都依赖这个抽象，通过实现这个抽象来做自己的任务。
这个抽象可以用接口，也可以用抽象类的方式来做，在这里用使用接口的方式进行讲解：
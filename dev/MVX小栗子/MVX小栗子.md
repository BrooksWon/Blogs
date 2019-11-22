# MVX小栗子

**01-MVC-Apple经典版**

Model-View-Controller

![Snip20191121_139](/Users/Brooks/blog/blogs/dev/MVX小栗子/Snip20191121_139.png)

优点：View、Model可以重复利用，可以独立使用。

缺点：Controller的代码过于臃肿。Controller里很多胶水代码将Model的数据和View的属性粘起来。



**02-MVC-变种**

Model-View-Controller  

![Snip20191122_142](/Users/Brooks/blog/blogs/dev/MVX小栗子/Snip20191122_142.png)

优点：对Controller进行瘦身，将View内部的细节封装起来了，外界不知道View内部的具体实现。

缺点：View依赖于Model。



**03-MVP**

Model-View-Presenter

![Snip20191122_143](/Users/Brooks/blog/blogs/dev/MVX小栗子/Snip20191122_143.png)

优点：对Controller进行瘦身：将**MVC-Apple经典版**中Controller做的事情交给Presenter去处理，在Presenter中粘合View和Model。

缺点：增加了代码的复杂度，Presenter中除了应用逻辑以外，还有大量的View-Model,Model-View的手动同步逻辑，会导致Presenter臃肿，维护困难。



**04-MVVM**

Model-View-ViewModel

![Snip20191122_144](/Users/Brooks/blog/blogs/dev/MVX小栗子/Snip20191122_144.png)

优点：对Controller进行瘦身：将**MVC-Apple经典版**中Controller做的事情交给ViewModel去处理，把ViewModel绑定到View上，View监听自己ViewModel的变化。

缺点：。。。



demo地址：
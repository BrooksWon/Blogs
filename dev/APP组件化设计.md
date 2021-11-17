# iOS组件化设计

> 在APP组件化开发中，当下流行话方案有如下3种：Router、Mediator、Protocol；本文选型了router方案实施。




## 1.整体设计

* 将每一个核心页面设计为一个独立模块。
* 模块粒度是一个用户可见的页面（如列表页、详情页），或者一个独立的可复用的元素（如引导页、分享弹框）。
* 利用 iOS 系统 URL Scheme 特性，基于 DeepLinkKit 库，给每一个模块设计 一个内部路由 和 一个或多个外部路由，支持内部路由跳转和外部来源跳转（如 Push 方式 或是 Safari 跳转，未来将支持 Universal Deep Link 方式直接跳转），内、外部跳转均交由路由管理器统一处理分发。
* 模块定义和路由配置均采用配置文件方式管理。

## 2.模块设计

一个模块与之相对应的包含以下参数：

* id, 模块ID
* name, 模块名称
* handler, 模块路由处理器
* routes, 外部路由列表（内部路由直接设为 模块ID）
模块参数配置均在 modules.json 文件定义。 另外，在 constModule.h 文件里定义里相关宏，用于模块指定跳转。
modules.json 文件解析采用 JSONModel 解析，对应的 Model 是 BTModulesConfiguration 和 BTModule。

## 3.模块注册

BTModuleManager 用于管理模块配置文件读取和解析，同时，根据解析之后 Model 注册内、外部路由。并且，提供模块跳转接口，-(BOOL)navigateToModule:withParameters:，用于内部跳转。
每次系统启动时，执行模块配置文件读取、解析、模块路由注册等一系列步骤。

## 4.模块跳转

支持模块跳转功能，需要在模块路由注册时，提供模块对应的路由、路由处理器和模块实体类三个参数。
路由和路由处理器均在配置文件指定。

* 路由 (Route) 仅指定路由地址,如 bt://user; 路由参数 (queryParameter)无需再配置表中指定。（注意的是，区分 Route 和 URL 概念，上述路由对应的其中一个合法的 URL 是bt://user?userId=101）
* 路由处理器类必须继承 DPLRouteHandler 基类，目前设计了 UniversalRouteHandler 和 AuthenticationRouteHandler 两个继承 DPLRouteHandler 的路由处理器基类，各模块对应的路由处理器必须继承以上两个基类中的其中一个。其中，AuthenticationRouteHandler 路由处理器用于需要用户登录之后采用访问的模块路由处理器，如果用户未登录，将先跳转到登录模块，登录成功之后在动跳转到指定模块。
* 路由处理器必须重写的方法是 -(void)targetViewController，其他方法如 - (BOOL)shouldHandleDeepLink:，用于处理特殊的路由判断。
* 模块实体类，一般是 UIViewController 子类，必须实现 DPLTargetViewController接口，只有一个接口方法需要实现，- (void)configureWithDeepLink:，用于在跳转之前传入 deeplink 对象，对传入数据进行预处理或保存。
* 路由注册和跳转由 BTURLRouter 真正管理，主要处理两类 URL，一类是 HTTP 协议的 URL，另一类是 BT 自定义协议的 URL，HTTP 协议的 URL 转交给 WebView 模块处理，BT 自定义协议的 URL，交由对于注册路由的路由处理器处理。

## 5.模块图示



![](https://github.com/BrooksWon/Blogs/blob/master/dev/iOS%E7%BB%84%E4%BB%B6%E5%8C%96%E8%AE%BE%E8%AE%A1%E5%9B%BE%E4%BE%8B.png)



## 6.Module的配置文件示例

```
{
 
  "version": "1.0",
 
  "modules": [
 
    {
 
      "id": "OrderDetailModule",
 
      "name": "订单详情",
 
      "handler": "OrderDetailRouteHandler",
 
      "routes": [
 
        "bt://order/detail?orderId=:String"
 
      ]
 
    },
    
    {
 
      "id": "AccountDetailModule",
 
      "name": "账户详情",
 
      "handler": "AccountDetailRouteHandler",
 
      "routes": [
 
        "bt://account/detail?accountId=:String"
 
      ]
 
    },
 
    {
 
      "id": "WebModule",
 
      "name": "网页",
 
      "handler": "WebviewRouteHandler",
 
      "routes": [
 
        "bt://web?urlStr=:String"
 
      ]
 
    },
     
  ]
 
}

```

## 7.APP对外Api规范



![](https://github.com/BrooksWon/Blogs/blob/master/dev/url%E8%A7%84%E5%88%99.png)



栗子:

【接口】预约订单详情 

【地址】`bt://order/detail?orderId=:String` 

【参数】 

| 字段    | 类型   | 是否必须 | 描述   |
| ------- | ------ | -------- | ------ |
| orderId | String | 是       | 订单id |

>  app端只需要给调度方暴露上述api即可, 调度方按照api规则即可调度相应服务.


## 8.其他
0->1.耦合的一堆代码->解耦: 组件化源码形式      

> 能提升编译速度: 原来是耦合的一堆代码，改动头文件, 容易引起很多源码重新编译.     解偶、组件化源码形式后能缓解这个问题.  

1->2.解耦: 组件化二进制形式  

> 也能提升编译速度: 因为用的是编译好的、 跳过了源码编译的过程.

0-1:是一个拆分的过程,比较花精力、并可拆解的粒度且也和业务有关.业务本来就耦合低的拆分起来较简单, 比如美团、淘宝。如果业务适合组件化架构,实在不知道做、就先暴力强拆, 拆完再重构, 拆一个组件 重构一个，然后在弄下一个。最终达到充分解耦,优雅合理的组件化。

1-2:相对较简单.根据实际情况, 不一定非要到. 0-1和1-2不是绝对的哪个更好的问题, 是哪个更适合的问题.

## 9.[代码示例](https://github.com/BrooksWon/BTRoute)

## 10.组建化的其它方案

* [https://github.com/BrooksWon/BTMediator](https://github.com/BrooksWon/BTMediator)
* [https://github.com/alibaba/BeeHive](https://github.com/alibaba/BeeHive)

## 11.更新
[iOS组件化开发中的路由，服务解耦方案- dmeo](https://github.com/BrooksWon/FerryMan)


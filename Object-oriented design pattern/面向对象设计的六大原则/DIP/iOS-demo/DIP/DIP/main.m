//
//  main.m
//  DIP
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Project.h"
#import "FrondEndDeveloper.h"
#import "BackEndDeveloper.h"
#import "IOSDeveloper.h"
#import "AndroidDeveloper.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        FrondEndDeveloper *fe = FrondEndDeveloper.new;
        BackEndDeveloper *be = BackEndDeveloper.new;
        IOSDeveloper *ios = IOSDeveloper.new;
        AndroidDeveloper *android = AndroidDeveloper.new;
        
        Project *p = [[Project alloc] initWithDevelopers:@[fe,be,ios,android]];
        [p startDeveloping];
    }
    return 0;
}

/**
 
 
 假设1：后台的开发语言改成了GO语言
 在这种情况下，只需更改BackEndDeveloper类里面对于DeveloperProtocol接口的writeCode方法的实现即可：
 
 //================== BackEndDeveloper.m ==================
 @implementation BackEndDeveloper
 
 - (void)writeCode{
 
 //Old：
 //NSLog(@"Write Java code");
 
 //New:
 NSLog(@"Write Golang code");
 }
 
 @end
 
在Project里面不需要修改任何代码，因为Project类只依赖了接口方法WriteCode，没有依赖其具体的实现。
 
 我们接着看一下第二个假设：
 假设2：后期老板要求做移动端的APP（需要iOS和安卓的开发者）
 
 在这个新场景下，我们只需要将新创建的两个开发者类：IOSDeveloper和AndroidDeveloper分别实现DeveloperProtocol接口的writeCode方法即可。
 同样，Project的接口和实现代码都不用修改：客户端只需要在Project的构建方法的数组参数里面添加这两个新类的实例即可，不需要在startDeveloping方法里面添加类型判断，原因同上。
 我们可以看到，新设计很好地在高层类（Project）与低层类（各种developer类）中间加了一层抽象，解除了二者在旧设计中的耦合，使得在低层类中的改动没有影响到高层类。
 同样是抽象，新设计同样也可以用抽象类的方式：创建一个Developer的抽象类并提供一个writeCode方法，让不同的开发者类继承与它并按照自己的方式实现writeCode方法。这样一来，在Project类的构造方法就是传入已Developer类型为元素的数组了。有兴趣的小伙伴可以自己实现一下~
 
 
 */

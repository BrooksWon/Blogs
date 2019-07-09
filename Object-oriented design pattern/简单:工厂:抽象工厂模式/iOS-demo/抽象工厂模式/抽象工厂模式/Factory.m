//
//  Factory.m
//  抽象工厂模式
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Factory.h"

@implementation Factory
+ (Phone *)createPhone{
    
    //implemented by subclass
    return nil;
}

+ (Computer *)createComputer{
    
    //implemented by subclass
    return nil;
}
@end

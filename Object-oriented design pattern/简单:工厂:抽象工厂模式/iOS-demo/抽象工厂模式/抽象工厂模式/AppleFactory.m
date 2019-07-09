//
//  AppleFactory.m
//  抽象工厂模式
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "AppleFactory.h"
#import "IPhone.h"
#import "MacBookComputer.h"

@implementation AppleFactory

+ (Phone *)createPhone{
    
    IPhone *iPhone = [[IPhone alloc] init];
    NSLog(@"iPhone has been created");
    return iPhone;
}

+ (Computer *)createComputer{
    
    MacBookComputer *macbook = [[MacBookComputer alloc] init];
    NSLog(@"Macbook has been created");
    return macbook;
}

@end

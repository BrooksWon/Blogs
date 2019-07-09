//
//  HWFactory.m
//  抽象工厂模式
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HWFactory.h"

#import "HWPhone.h"
#import "HWComputer.h"

@implementation HWFactory

+ (Phone *)createPhone{
    
    HWPhone *hwPhone = [[HWPhone alloc] init];
    NSLog(@"HWPhone has been created");
    return hwPhone;
}

+ (Computer *)createComputer{
    
    HWComputer *hwComputer = [[HWComputer alloc] init];
    NSLog(@"HWComputer has been created");
    return hwComputer;
}

@end

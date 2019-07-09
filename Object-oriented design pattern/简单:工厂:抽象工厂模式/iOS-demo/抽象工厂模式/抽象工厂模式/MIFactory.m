//
//  MIFactory.m
//  抽象工厂模式
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "MIFactory.h"

#import "MIPhone.h"
#import "MIComputer.h"

@implementation MIFactory

+ (Phone *)createPhone{
    
    MIPhone *miPhone = [[MIPhone alloc] init];
    NSLog(@"MIPhone has been created");
    return miPhone;
}

+ (Computer *)createComputer{
    
    MIComputer *miComputer = [[MIComputer alloc] init];
    NSLog(@"MIComputer has been created");
    return miComputer;
}

@end

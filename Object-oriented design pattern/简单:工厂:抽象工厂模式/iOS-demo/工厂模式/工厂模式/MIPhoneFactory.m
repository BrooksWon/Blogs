//
//  MIPhoneFactory.m
//  工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "MIPhoneFactory.h"

#import "MIPhone.h"

@implementation MIPhoneFactory

+ (Phone *)createPhone{
    
    MIPhone *miPhone = [[MIPhone alloc] init];
    NSLog(@"MIPhone has been created");
    return miPhone;
}

@end

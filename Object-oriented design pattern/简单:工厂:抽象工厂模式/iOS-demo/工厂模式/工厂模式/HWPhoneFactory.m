//
//  HWPhoneFactory.m
//  工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HWPhoneFactory.h"

#import "HWPhone.h"

@implementation HWPhoneFactory

+ (Phone *)createPhone{
    
    HWPhone *hwPhone = [[HWPhone alloc] init];
    NSLog(@"HWPhone has been created");
    return hwPhone;
}


@end

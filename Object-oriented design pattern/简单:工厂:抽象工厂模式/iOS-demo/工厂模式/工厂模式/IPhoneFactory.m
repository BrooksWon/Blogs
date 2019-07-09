//
//  IPhoneFactory.m
//  工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "IPhoneFactory.h"

#import "IPhone.h"

@implementation IPhoneFactory

+ (Phone *)createPhone{
    
    IPhone *iphone = [[IPhone alloc] init];
    NSLog(@"iPhone has been created");
    return iphone;
}

@end

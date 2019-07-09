//
//  MZPhoneFactory.m
//  工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "MZPhoneFactory.h"

#import "MZPhone.h"

@implementation MZPhoneFactory

+ (Phone *)createPhone{
    
    MZPhone *mzPhone = [[MZPhone alloc] init];
    NSLog(@"MZPhone has been created");
    return mzPhone;
}

@end

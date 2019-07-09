
//
//  SauceDecorator.m
//  装饰者模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "SauceDecorator.h"

@implementation SauceDecorator
- (instancetype)initWithSalad:(Salad *)salad{
    
    self = [super init];
    
    if (self) {
        self.salad = salad;
    }
    return self;
}

@end

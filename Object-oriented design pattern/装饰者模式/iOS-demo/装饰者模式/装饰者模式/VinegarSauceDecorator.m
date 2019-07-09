
//
//  VinegarSauceDecorator.m
//  装饰者模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "VinegarSauceDecorator.h"

@implementation VinegarSauceDecorator

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ + vinegar sauce",[self.salad description]];
}

- (double)price{
    return [self.salad price] + 2.0;
}

@end

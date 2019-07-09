//
//  PeanutButterSauceDecorator.m
//  装饰者模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "PeanutButterSauceDecorator.h"

@implementation PeanutButterSauceDecorator
- (NSString *)description{
    return [NSString stringWithFormat:@"%@ + peanut butter sauce",[self.salad description]];
}

- (double)price{
    return [self.salad price] + 4.0;
}
@end


//
//  BlueBerrySauceDecorator.m
//  装饰者模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "BlueBerrySauceDecorator.h"

@implementation BlueBerrySauceDecorator
- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@ + blueberry sauce",[self.salad description]];
}

- (double)price{
    
    return [self.salad price] + 6.0;
}

@end

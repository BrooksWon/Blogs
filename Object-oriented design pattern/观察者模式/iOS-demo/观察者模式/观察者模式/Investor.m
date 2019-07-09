//
//  Investor.m
//  观察者模式
//
//  Created by Brooks on 2019/6/5.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Investor.h"

@implementation Investor

- (void)update{
    
    float buyingPrice = [_subject getBuyingPrice];
    NSLog(@"investor %p buy stock of price:%.2lf",self,buyingPrice);
}


@end

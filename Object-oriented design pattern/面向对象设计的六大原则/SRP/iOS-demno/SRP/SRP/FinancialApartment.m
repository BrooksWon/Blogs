//
//  FinancialApartment.m
//  SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "FinancialApartment.h"

@implementation FinancialApartment

//计算薪水
- (double)calculateSalary {
    NSLog(@"正在计算您的薪资。。。");
    
    for (int i=0; i<5; i++) {
        NSLog(@"。");
        sleep(1);
    }
    
    return arc4random();
}

@end

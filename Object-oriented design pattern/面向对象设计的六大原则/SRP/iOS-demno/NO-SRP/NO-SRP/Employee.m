//
//  Employee.m
//  NO-SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Employee.h"

@implementation Employee

//计算薪水
- (double)calculateSalary {
    NSLog(@"正在计算您的薪资。。。");
    
    for (int i=0; i<5; i++) {
        NSLog(@"。");
        sleep(1);
    }
    
    return arc4random();
}

//今年是否晋升
- (BOOL)willGetPromotionThisYear {
    NSLog(@"%@ 今年绩效评定为3.75，准许晋升💐", _name);
    
    return YES;
}

@end

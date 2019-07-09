//
//  main.m
//  NO-SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Employee.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Employee *e = Employee.new;
        
        for (int i=0; i<3; i++) {
            NSArray *es = @[@"兴祥",@"刘洋",@"周毅",@"建雨"];
            e.name = [es objectAtIndex:arc4random()%4];
            NSLog(@"%@, 喜提薪资 %@",e.name, @([e calculateSalary]));
            [e willGetPromotionThisYear];
        }

    }
    return 0;
}

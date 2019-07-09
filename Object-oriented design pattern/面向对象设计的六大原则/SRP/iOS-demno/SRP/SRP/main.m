//
//  main.m
//  SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HRApartment.h"
#import "FinancialApartment.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Employee *e = Employee.new;
        
        for (int i=0; i<3; i++) {
            NSArray *es = @[@"兴祥",@"刘洋",@"周毅",@"建雨"];
            e.name = [es objectAtIndex:arc4random()%4];
            
            FinancialApartment *f = FinancialApartment.new;
            NSLog(@"%@, 喜提薪资 %@",e.name, @([f calculateSalary:e]));
            
            HRApartment *hr = HRApartment.new;
            [hr willGetPromotionThisYear:e];
        }
    }
    return 0;
}

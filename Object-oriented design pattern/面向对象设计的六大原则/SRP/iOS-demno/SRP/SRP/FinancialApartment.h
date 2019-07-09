//
//  FinancialApartment.h
//  SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Employee.h"

NS_ASSUME_NONNULL_BEGIN

//会计部门类
@interface FinancialApartment : NSObject

//计算薪水
- (double)calculateSalary:(Employee *)employee;

@end


NS_ASSUME_NONNULL_END

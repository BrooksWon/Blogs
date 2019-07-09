//
//  HRApartment.h
//  SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Employee.h"

NS_ASSUME_NONNULL_BEGIN

//人事部门类
@interface HRApartment : NSObject

//今年是否晋升
- (BOOL)willGetPromotionThisYear:(Employee*)employee;

@end

NS_ASSUME_NONNULL_END

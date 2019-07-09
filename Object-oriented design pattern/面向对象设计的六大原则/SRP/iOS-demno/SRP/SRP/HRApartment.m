//
//  HRApartment.m
//  SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HRApartment.h"

@implementation HRApartment

//今年是否晋升
- (BOOL)willGetPromotionThisYear {
    NSLog(@"%@ 今年绩效评定为3.75，准许晋升💐", _name);
    
    return YES;
}

@end

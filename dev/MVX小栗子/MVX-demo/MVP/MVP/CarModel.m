//
//  CarModel.m
//  MVC-Apple
//
//  Created by Brooks on 2019/11/21.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel

- (instancetype)init
{
    if (self = [super init]) {
        _logoUrl = @"car.png";
        _name = @"Tesla";
    }
    
    return self;
}

@end

//
//  State.m
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "State.h"

@implementation State

- (instancetype)initWithCoder:(Coder *)coder{
    
    self = [super init];
    if (self) {
        _coder = coder;
    }
    return self;
}



@end

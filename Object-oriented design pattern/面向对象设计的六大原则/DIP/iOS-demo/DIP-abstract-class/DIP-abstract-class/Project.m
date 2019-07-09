//
//  Project.m
//  DIP-abstract-class
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Project.h"

@implementation Project
{
    NSArray *_developers;
}

- (instancetype)initWithDevelopers:(NSArray <Developer*> *)developers{
    
    if (self = [super init]) {
        _developers = developers;
    }
    return self;
}



- (void)startDeveloping{
    
    [_developers enumerateObjectsUsingBlock:^(Developer * _Nonnull developer, NSUInteger idx, BOOL * _Nonnull stop) {

            [developer writeCode];

    }];
}

@end

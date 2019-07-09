//
//  Project.m
//  DIP
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Project.h"

@implementation Project
{
    NSArray *_developers;
}

- (instancetype)initWithDevelopers:(NSArray<id<DeveloperProtocol>> *)developers{
    
    if (self = [super init]) {
        _developers = developers;
    }
    return self;
}



- (void)startDeveloping{
    
    [_developers enumerateObjectsUsingBlock:^(id <DeveloperProtocol> _Nonnull developer, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([developer respondsToSelector:@selector(writeCode)]) {
            
            [developer writeCode];
            
        }else{
            //not respondsToSelector
        }
    }];
}

@end

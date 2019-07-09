//
//  Project.m
//  NO-DIP
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Project.h"

#import "FrondEndDeveloper.h"
#import "BackEndDeveloper.h"

@implementation Project
{
    NSArray *_developers;
}


- (instancetype)initWithDevelopers:(NSArray *)developers{
    
    if (self = [super init]) {
        _developers = developers;
    }
    return self;
}



- (void)startDeveloping{
    
    [_developers enumerateObjectsUsingBlock:^(id  _Nonnull developer, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([developer isKindOfClass:[FrondEndDeveloper class]]) {
            
            [developer writeJavaScriptCode];
            
        }else if ([developer isKindOfClass:[BackEndDeveloper class]]){
            
            [developer writeJavaCode];
            
        }else{
            //no such developer
        }
    }];
}

@end

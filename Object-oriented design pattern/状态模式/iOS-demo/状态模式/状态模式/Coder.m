//
//  Coder.m
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Coder.h"
#import "StateAwake.h"
#import "StateCoding.h"
#import "StateEating.h"
#import "StateSleeping.h"

@implementation Coder
{
    State *_currentState;
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _stateAwake = [[StateAwake alloc] initWithCoder:self];
        _stateCoding = [[StateCoding alloc] initWithCoder:self];
        _stateEating = [[StateEating alloc] initWithCoder:self];
        _stateSleeping = [[StateSleeping alloc] initWithCoder:self];
        
        _currentState = _stateAwake;
    }
    return self;
}

- (void)setState:(State *)state{
    
    _currentState = state;
}

- (void)wakeUp{
    
    [_currentState wakeUp];
}

- (void)startCoding{
    
    [_currentState startCoding];
}

- (void)startEating{
    
    [_currentState startEating];
}


- (void)fallAsleep{
    
    [_currentState fallAsleep];
}



@end

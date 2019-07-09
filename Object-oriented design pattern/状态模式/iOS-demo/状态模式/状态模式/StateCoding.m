

//
//  StateCoding.m
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "StateCoding.h"

@implementation StateCoding
- (void)wakeUp{
    
    NSLog(@"Already awake, can not change state to awake again");
}


- (void)startCoding{
    
    NSLog(@"Already coding, can not change state to coding again");
}

- (void)startEating{
    
    NSLog(@"Too hungry, change state from coding to eating");
    [_coder setState:(State *)[_coder stateEating]];
}


- (void)fallAsleep{
    
    NSLog(@"Too tired, change state from coding to sleeping");
    [_coder setState:(State *)[_coder stateSleeping]];
}
@end

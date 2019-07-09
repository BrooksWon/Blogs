
//
//  StateSleeping.m
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "StateSleeping.h"

@implementation StateSleeping
- (void)wakeUp{
    
    NSLog(@"Already awake, can not change state to awake again");
}

- (void)startCoding{
    
    NSLog(@"Change state from awake to coding");
    [_coder setState:(State *)[_coder stateCoding]];
}

- (void)startEating{
    
    NSLog(@"Change state from awake to eating");
    [_coder setState:(State *)[_coder stateEating]];
}


- (void)fallAsleep{
    
    NSLog(@"Change state from awake to sleeping");
    [_coder setState:(State *)[_coder stateSleeping]];
}
@end

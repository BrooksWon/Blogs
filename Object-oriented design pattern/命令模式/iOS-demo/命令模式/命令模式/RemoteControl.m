//
//  RemoteControl.m
//  命令模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "RemoteControl.h"
#import "Command.h"

@implementation RemoteControl
{
    Command *_command;
}


- (void)setCommand:(Command *)command {
    
    _command = command;
}

- (void)pressButton {
    
    [_command excute];
}


@end

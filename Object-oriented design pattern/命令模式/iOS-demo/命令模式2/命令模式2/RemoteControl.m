//
//  RemoteControl.m
//  命令模式2
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "RemoteControl.h"

@implementation RemoteControl

- (void)pressButton {
    
    [_delegate excute];
}


@end

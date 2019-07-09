//
//  RemoteControl.h
//  命令模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Command;

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControl : NSObject

- (void)setCommand:(Command *)command;

- (void)pressButton;

@end

NS_ASSUME_NONNULL_END

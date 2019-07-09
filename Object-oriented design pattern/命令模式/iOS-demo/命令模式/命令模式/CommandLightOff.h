//
//  CommandLightOff.h
//  命令模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Command.h"

@class Light;

NS_ASSUME_NONNULL_BEGIN

@interface CommandLightOff : Command
- (instancetype)initWithLight:(Light *)light NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

//
//  CommandLightOn.h
//  
//
//  Created by Brooks on 2019/6/4.
//

#import "Command.h"

@class Light;

NS_ASSUME_NONNULL_BEGIN

@interface CommandLightOn : Command
- (instancetype)initWithLight:(Light *)light NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

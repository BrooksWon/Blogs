//
//  Coder.h
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActionProtocol.h"

@class State;
@class StateAwake;
@class StateCoding;
@class StateEating;
@class StateSleeping;

NS_ASSUME_NONNULL_BEGIN

@interface Coder : NSObject <ActionProtocol>


@property (nonatomic, strong) StateAwake *stateAwake;
@property (nonatomic, strong) StateCoding *stateCoding;
@property (nonatomic, strong) StateEating *stateEating;
@property (nonatomic, strong) StateSleeping *stateSleeping;

- (void)setState:(State *)state;

@end

NS_ASSUME_NONNULL_END

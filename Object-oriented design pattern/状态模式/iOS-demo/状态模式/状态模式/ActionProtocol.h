
//
//  ActionProtocol.h
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ActionProtocol <NSObject>

@optional;

- (void)wakeUp;

- (void)fallAsleep;

- (void)startCoding;

- (void)startEating;

@end

NS_ASSUME_NONNULL_END

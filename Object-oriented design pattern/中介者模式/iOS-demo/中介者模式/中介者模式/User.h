//
//  User.h
//  中介者模式
//
//  Created by Brooks on 2019/6/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatMediator;

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

- (instancetype)initWithName:(NSString *)name mediator:(ChatMediator *)mediator NS_DESIGNATED_INITIALIZER;

- (void)sendMessage:(NSString *)message;

- (void)receivedMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END

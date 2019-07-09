//
//  ChatMediator.h
//  中介者模式
//
//  Created by Brooks on 2019/6/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface ChatMediator : NSObject

- (void)addUser:(User *)user;

- (void)sendMessage:(NSString *)message fromUser:(User *)user;

@end

NS_ASSUME_NONNULL_END

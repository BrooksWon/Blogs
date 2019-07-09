
//
//  ChatMediator.m
//  中介者模式
//
//  Created by Brooks on 2019/6/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ChatMediator.h"
#import "User.h"

@implementation ChatMediator
{
    NSMutableArray <User *>*_userList;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        _userList = [NSMutableArray array];
    }
    return self;
}

- (void)addUser:(User *)user{
    
    [_userList addObject:user];
}

- (void)sendMessage:(NSString *)message fromUser:(User *)user{
    
    [_userList enumerateObjectsUsingBlock:^(User * _Nonnull iterUser, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (iterUser != user) {
            [iterUser receivedMessage:message];
        }
    }];
}

@end

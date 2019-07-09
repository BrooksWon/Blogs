//
//  User.m
//  中介者模式
//
//  Created by Brooks on 2019/6/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "User.h"
#import "ChatMediator.h"

@implementation User
{
    NSString *_name;
    ChatMediator *_chatMediator;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"初始化方法错误" reason:@"未使用 `initWithName:mediator:` 方法初始化" userInfo:@{NSStringFromClass(self.class):self}];
    return [self initWithName:nil mediator:nil];
}

- (instancetype)initWithName:(NSString *)name mediator:(ChatMediator *)mediator{
    
    self = [super init];
    if (self) {
        _name = name;
        _chatMediator = mediator;
    }
    return self;
}

- (void)sendMessage:(NSString *)message{
    
    NSLog(@"================");
    NSLog(@"%@ sent message:%@",_name,message);
    [_chatMediator sendMessage:message fromUser:self];
    
}

- (void)receivedMessage:(NSString *)message{
    
    NSLog(@"%@ has received message:%@",_name,message);
}

@end

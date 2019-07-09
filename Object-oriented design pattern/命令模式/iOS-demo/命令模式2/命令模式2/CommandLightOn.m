//
//  CommandLightOn.m
//  命令模式2
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CommandLightOn.h"

@implementation CommandLightOn

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"初始化方法错误" reason:@"未使用 `initWithLightCommondsObj` 初始化" userInfo:@{NSStringFromClass(self.class):self}];
    
    return [self initWithLightCommondsObj:nil];
}

- (instancetype)initWithLightCommondsObj:(id <LightCommondsProtocol>)obj{
    
    self = [super init];
    if (self) {
        _delegate = obj;
    }
    return self;
}

- (void)excute{
    
    [_delegate lightOn];
}

@end

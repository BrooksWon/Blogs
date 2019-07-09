
//
//  CommandLightOff.m
//  命令模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CommandLightOff.h"
#import "Light.h"

@implementation CommandLightOff
{
    Light *_light;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"初始化方法错误" reason:@"未使用 `initWithLight` 初始化" userInfo:@{NSStringFromClass(self.class):self}];
    
    return [self initWithLight:nil];
}

- (instancetype)initWithLight:(Light *)light{
    
    self = [super init];
    if (self) {
        _light = light;
    }
    return self;
}

- (void)excute{
    
    [_light lightOff];
}

@end

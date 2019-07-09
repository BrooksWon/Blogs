


//
//  HomeDevice.m
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HomeDevice.h"

@implementation HomeDevice
//连接电源
- (void)on{
    NSLog(@"%@ is on",[self class]);
}

//关闭电源
- (void)off{
    NSLog(@"%@ is off",[self class]);
}
@end

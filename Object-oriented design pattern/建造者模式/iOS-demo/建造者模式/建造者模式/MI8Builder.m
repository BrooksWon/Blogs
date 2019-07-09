//
//  MI8Builder.m
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "MI8Builder.h"

@implementation MI8Builder

- (void)createPhone{
    
    _phone = [[Phone alloc] init];
}


- (void)buildCPU{
    
    [_phone setCpu:@"Snapdragon 845"];
}

- (void)buildCapacity{
    
    [_phone setCapacity:@"128"];
}


- (void)buildDisplay{
    
    [_phone setDisplay:@"7.21"];
}

- (void)buildCamera{
    
    [_phone setCamera:@"13MP"];
}

- (Phone *)obtainPhone{
    return _phone;
}


@end

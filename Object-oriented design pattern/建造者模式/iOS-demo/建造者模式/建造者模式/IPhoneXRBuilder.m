//
//  IPhoneXRBuilder.m
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "IPhoneXRBuilder.h"

@implementation IPhoneXRBuilder

- (void)createPhone{
    
    _phone = [[Phone alloc] init];
}


- (void)buildCPU{
    
    [_phone setCpu:@"A12"];
}

- (void)buildCapacity{
    
    [_phone setCapacity:@"256"];
}


- (void)buildDisplay{
    
    [_phone setDisplay:@"6.1"];
}

- (void)buildCamera{
    
    [_phone setCamera:@"12MP"];
}

- (Phone *)obtainPhone{
    return _phone;
}

@end


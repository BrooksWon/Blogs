//
//  Director.m
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Director.h"

@implementation Director
{
    Builder *_builder;
}


- (void)construct:(Builder *)builder{
    
    _builder = builder;
    
    [_builder createPhone];
    
    [_builder buildCPU];
    [_builder buildCapacity];
    [_builder buildDisplay];
    [_builder buildCamera];
    
}

@end

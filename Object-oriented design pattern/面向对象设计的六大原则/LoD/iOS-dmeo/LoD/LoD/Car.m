//
//  Car.m
//  LoD
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Car.h"
#import "GasEngine.h"

@implementation Car
{
    GasEngine *_engine;
}

- (instancetype)initWithEngine:(GasEngine *)engine{
    
    self = [super init];
    
    if (self) {
        _engine = engine;
    }
    return self;
}


- (instancetype)init {
    
    return [self initWithEngine:GasEngine.new];
}

- (NSString *)usingEngineBrandName{
    return _engine.brandName;
}

@end

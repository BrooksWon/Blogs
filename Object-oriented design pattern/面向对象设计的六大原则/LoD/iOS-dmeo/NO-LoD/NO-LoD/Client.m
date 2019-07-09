//
//  Client.m
//  NO-LoD
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Client.h"

#import "GasEngine.h"
#import "Car.h"

@implementation Client

- (NSString *)findCarEngineBrandName:(Car *)car{
    
    GasEngine *engine = [car usingEngine];
    NSString *engineBrandName = engine.brandName;//获取到了引擎的品牌名称
    return engineBrandName;
}

@end

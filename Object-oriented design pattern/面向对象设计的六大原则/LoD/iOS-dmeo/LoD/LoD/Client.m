//
//  Client.m
//  NO-LoD
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Client.h"

#import "Car.h"

@implementation Client

- (NSString *)findCarEngineBrandName:(Car *)car{
    
    NSString *engineBrandName = [car usingEngineBrandName];//获取到了引擎的品牌名称
    return engineBrandName;
}

@end

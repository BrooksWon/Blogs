//
//  Car.h
//  NO-LoD
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GasEngine;

NS_ASSUME_NONNULL_BEGIN

@interface Car : NSObject

//构造方法
- (instancetype)initWithEngine:(GasEngine *)engine __attribute__((objc_designated_initializer));

//返回私有成员变量：引擎的实例
- (GasEngine *)usingEngine;

@end

NS_ASSUME_NONNULL_END

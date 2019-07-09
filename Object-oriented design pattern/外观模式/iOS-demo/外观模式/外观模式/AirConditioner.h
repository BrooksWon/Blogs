//
//  AirConditioner.h
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HomeDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface AirConditioner : HomeDevice

//高温模式
- (void)startHighTemperatureMode;

//常温模式
- (void)startMiddleTemperatureMode;

//低温模式
- (void)startLowTemperatureMode;

@end

NS_ASSUME_NONNULL_END

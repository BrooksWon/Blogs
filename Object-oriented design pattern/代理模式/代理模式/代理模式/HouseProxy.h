//
//  HouseProxy.h
//  代理模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface HouseProxy : NSObject <PaymentInterface>

@end

NS_ASSUME_NONNULL_END

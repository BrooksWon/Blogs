//
//  OnlineClient.h
//  ISP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "RestaurantPlaceOrderProtocol.h"
#import "RestaurantPaymentProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OnlineClient : NSObject <RestaurantPlaceOrderProtocol, RestaurantPaymentProtocol>

@end

NS_ASSUME_NONNULL_END

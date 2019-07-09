//
//  RestaurantProtocol.h
//  NO-ISP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RestaurantProtocol <NSObject>

@optional

- (void)placeOnlineOrder;         //下订单：online
- (void)placeTelephoneOrder;      //下订单：通过电话
- (void)placeWalkInCustomerOrder; //下订单：在店里

- (void)payOnline;                //支付订单：online
- (void)payInPerson;              //支付订单：在店里支付

@end

NS_ASSUME_NONNULL_END

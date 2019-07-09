
//
//  PaymentInterface.h
//  代理模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PaymentInterface <NSObject>

- (void)getPayment:(double)money;

@end

NS_ASSUME_NONNULL_END

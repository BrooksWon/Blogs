//
//  ATMDispenseChain.h
//  责任链模式2
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DispenseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATMDispenseChain : NSObject <DispenseProtocol>

- (instancetype)initWithDispenseNodeValues:(NSArray *)nodeValues NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

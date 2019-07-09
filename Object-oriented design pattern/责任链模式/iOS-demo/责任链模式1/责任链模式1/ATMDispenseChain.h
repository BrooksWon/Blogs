//
//  ATMDispenseChain.h
//  责任链模式1
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispenseProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface ATMDispenseChain : NSObject <DispenseProtocol>

@end

NS_ASSUME_NONNULL_END

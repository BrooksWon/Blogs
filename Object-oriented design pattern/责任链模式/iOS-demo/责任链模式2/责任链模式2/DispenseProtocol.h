
//
//  DispenseProtocol.h
//  责任链模式2
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DispenseProtocol <NSObject>

- (void)dispense:(int)amount;

@end

NS_ASSUME_NONNULL_END

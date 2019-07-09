//
//  DispenseChainNode.h
//  责任链模式2
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispenseProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DispenseChainNode : NSObject <DispenseProtocol>
{
    @protected DispenseChainNode *_nextChainNode;
    @protected int _dispenseValue;
}

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithDispenseValue:(int)dispenseValue NS_DESIGNATED_INITIALIZER;

- (void)setNextChainNode:(DispenseChainNode *)chainNode;

@end

NS_ASSUME_NONNULL_END

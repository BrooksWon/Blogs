//
//  Context.h
//  策略模式
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TwoIntOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface Context : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithOperation: (TwoIntOperation *)operation NS_DESIGNATED_INITIALIZER;

- (void)setOperation:(TwoIntOperation *)operation;

- (int)excuteOperationOfInt1:(int)int1 int2:(int)int2;
@end

NS_ASSUME_NONNULL_END

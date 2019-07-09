//
//  Adaptor.h
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OldCacheProtocol.h"

@class NewCache;

NS_ASSUME_NONNULL_BEGIN

@interface Adaptor : NSObject <OldCacheProtocol>

- (instancetype)initWithNewCache:(NewCache *)newCache;


@end

NS_ASSUME_NONNULL_END

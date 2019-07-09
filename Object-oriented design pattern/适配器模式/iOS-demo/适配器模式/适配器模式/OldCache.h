//
//  OldCache.h
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OldCacheProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface OldCache : NSObject <OldCacheProtocol>

@end

NS_ASSUME_NONNULL_END

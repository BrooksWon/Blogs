    //
//  NewCacheProtocol.h
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewCacheProtocol <NSObject>

- (void)new_saveCacheObject:(id)obj forKey:(NSString *)key;

- (id)new_getCacheObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

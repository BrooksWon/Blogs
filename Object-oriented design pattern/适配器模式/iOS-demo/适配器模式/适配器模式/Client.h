//
//  Client.h
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OldCacheProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface Client : NSObject

@property (nonatomic, strong) id<OldCacheProtocol>cache;

//实例化旧缓存并保存在``cache``属性里
- (void)useOldCache;

//使用cache对象
- (void)saveObject:(id)object forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

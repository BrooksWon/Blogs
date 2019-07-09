//
//  NewCache.m
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "NewCache.h"

@implementation NewCache

- (void)new_saveCacheObject:(id)obj forKey:(NSString *)key{
    
    NSLog(@"saved cache by new cache object");
}

- (id)new_getCacheObjectForKey:(NSString *)key{
    
    NSString *obj = @"saved cache by new cache object";
    NSLog(@"%@",obj);
    return obj;
}

@end

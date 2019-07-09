//
//  OldCache.m
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "OldCache.h"

@implementation OldCache

- (void)old_saveCacheObject:(id)obj forKey:(NSString *)key{
    
    NSLog(@"saved cache by old cache object");
    
}

- (id)old_getCacheObjectForKey:(NSString *)key{
    
    NSString *obj = @"get cache by old cache object";
    NSLog(@"%@",obj);
    return obj;
}

@end

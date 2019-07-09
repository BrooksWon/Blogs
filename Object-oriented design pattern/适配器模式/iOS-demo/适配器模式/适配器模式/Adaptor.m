

//
//  Adaptor.m
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Adaptor.h"
#import "NewCache.h"

/**
 
 首先，适配器类也实现了旧缓存组件的接口；目的是让它也可以接收到客户端操作旧缓存组件的方法。
 
 然后，适配器的构造方法里面需要传入新组件类的实例；目的是在收到客户端操作旧缓存组件的命令后，将该命令转发给新缓存组件类，并调用其对应的方法。
 
 最后我们看一下适配器类是如何实现两个旧缓存组件的接口的：在old_saveCacheObject:forKey:方法中，让新缓存组件对象调用对应的new_saveCacheObject:forKey:方法；同样地，在old_getCacheObjectForKey方法中，让新缓存组件对象调用对应的new_getCacheObjectForKey:方法。
 
 */

@implementation Adaptor
{
    NewCache *_newCache;
}

- (instancetype)initWithNewCache:(id)newCache {
    self = [super init];

    if (self) {
        _newCache = newCache;
    }
    
    return self;
}

- (void)old_saveCacheObject:(id)obj forKey:(NSString *)key{
    
    //transfer responsibility to new cache object
    [_newCache new_saveCacheObject:obj forKey:key];
    
}

- (id)old_getCacheObjectForKey:(NSString *)key{
    //transfer responsibility to new cache object
    return [_newCache new_getCacheObjectForKey:key];
}

@end

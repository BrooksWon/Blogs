//
//  Client.m
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Client.h"

#import "OldCache.h"

#import "Adaptor.h"

#import "NewCache.h"

@implementation Client

//实例化旧缓存并保存在``cache``属性里
- (void)useOldCache{
    
//    self.cache = [[OldCache alloc] init];
    
    // 新需求
    self.cache = [[Adaptor alloc] initWithNewCache:NewCache.new];
    
    /**
     
     我们可以看到，使用适配器模式，客户端调用旧缓存组件接口的方法都不需要改变；只需稍作处理，就可以在新旧缓存组件中来回切换，也不需要原来客户端对缓存的操作。
     
     而之所以可以做到这么灵活，其实也是因为在一开始客户端只是依赖了旧缓存组件类所实现的接口，而不是旧缓存组件类的类型。上面Client的属性是@property (nonatomic, strong) id<OldCacheProtocol>cache;。正因为如此，我们新建的适配器实例才能直接用在这里，因为适配器类也是实现了<OldCacheProtocol>接口。相反，如果我们的cache属性是这么写的：@property (nonatomic, strong) OldCache *cache;，即客户端依赖了旧缓存组件的类型，那么我们的适配器类就无法这么容易地放在这里了。因此为了我们的程序在将来可以更好地修改和扩展，依赖接口是一个前提。
     
     */
}

//使用cache对象
- (void)saveObject:(id)object forKey:(NSString *)key{
    
    [self.cache old_saveCacheObject:object forKey:key];
}

@end

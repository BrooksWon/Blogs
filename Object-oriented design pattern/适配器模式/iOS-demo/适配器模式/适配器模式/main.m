//
//  main.m
//  适配器模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//


#import "Client.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
       
        Client *c = Client.new;
        
        //使用旧缓存
        [c useOldCache];
        
        //使用缓存组件操作
        [c saveObject:@"cache" forKey:@"key"];
    }
    return 0;
}

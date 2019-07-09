//
//  main.m
//  单例模式
//
//  Created by Brooks on 2019/5/15.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "LogManager.h"

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //alloc&init
        LogManager *manager0 = [[LogManager alloc] init];
        
        //sharedInstance
        LogManager *manager1 = [LogManager sharedInstance];
        
        //copy
        LogManager *manager2 = [manager0 copy];
        
        //mutableCopy
        LogManager *manager3 = [manager1 mutableCopy];
        
        NSLog(@"\nalloc&init:     %p\nsharedInstance: %p\ncopy:           %p\nmutableCopy:    %p",manager0,manager1,manager2,manager3);
    }
    return 0;
}

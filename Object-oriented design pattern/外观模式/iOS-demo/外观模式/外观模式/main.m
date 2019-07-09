//
//  main.m
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HomeDeviceManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        HomeDeviceManager *manager = [[HomeDeviceManager alloc] init];
        
        //吹凉风
        [manager coolWind];
        
        //听音乐
        [manager playMusic];
        
        //关掉音乐
        [manager offMusic];
        
        //看电影
        [manager playMovie];
        
        //出门，关闭所有家用电器
        [manager allDeviceOff];
    }
    return 0;
}

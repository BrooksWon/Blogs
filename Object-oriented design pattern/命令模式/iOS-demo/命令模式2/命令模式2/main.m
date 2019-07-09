//
//  main.m
//  命令模式2
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
//方式1
#import "Light.h"
#import "CommandLightOn.h"
#import "CommandLightOff.h"
#import "RemoteControl.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //init Light and Command instance
        //inject light instance into command instance
        Light *light = [[Light alloc] init];
        CommandLightOn *co = [[CommandLightOn alloc] initWithLightCommondsObj:light];
        
        //set command on instance into remote control instance
        RemoteControl *rm = [[RemoteControl alloc] init];
        rm.delegate = co;
        
        //excute command（light  on command）
        [rm pressButton];
        
        
        //inject light instance into command off instance
        CommandLightOff *cf = [[CommandLightOff alloc] initWithLightCommondsObj:light];
        
        //change to off command
        rm.delegate = cf;
        
        //excute command（light  close command）
        [rm pressButton];
    }
    return 0;
}

//
//  main.m
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Coder.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Coder *coder = [[Coder alloc] init];
        
        //change to awake.. failed
        [coder wakeUp];//Already awake, can not change state to awake again
        
        //change to coding
        [coder startCoding];//Change state from awake to coding
        
        //change to sleep
        [coder fallAsleep];//Too tired, change state from coding to sleeping
        
        //change to eat...failed
        [coder startEating];//Already sleeping, can change state to eating
        
        //change to wake up
        [coder wakeUp];//Change state from sleeping to awake
        
        //change wake up...failed
        [coder wakeUp];//Already awake, can not change state to awake again
        
        //change to eating
        [coder startEating];//Change state from awake to eating
        
        //change to coding
        [coder startCoding];//New idea came out! change state from eating to coding
        
        //change to sleep
        [coder fallAsleep];//Too tired, change state from coding to sleeping
    }
    return 0;
}

//
//  DispenseChainNodeFor20Yuan.m
//  责任链模式1
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "DispenseChainNodeFor20Yuan.h"

@implementation DispenseChainNodeFor20Yuan

- (void)dispense:(int)amount{
    
    int unit = 20;
    
    if (amount >= unit) {
        
        int count = amount/unit;
        int remainder = amount % unit;
        
        NSLog(@"Dispensing %d of %d",count,unit);
        
        if (remainder != 0) {
            [_nextChainNode dispense:remainder];
        }
        
    }else{
        
        [_nextChainNode dispense:amount];
    }
}

@end

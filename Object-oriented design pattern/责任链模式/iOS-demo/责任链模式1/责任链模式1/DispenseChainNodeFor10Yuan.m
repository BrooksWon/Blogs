//
//  DispenseChainNodeFor10Yuan.m
//  责任链模式1
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "DispenseChainNodeFor10Yuan.h"

@implementation DispenseChainNodeFor10Yuan

- (void)dispense:(int)amount{
    
    int unit = 10;
    
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

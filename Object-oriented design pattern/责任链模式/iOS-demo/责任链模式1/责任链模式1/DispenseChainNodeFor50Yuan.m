//
//  DispenseChainNodeFor50Yuan.m
//  责任链模式1
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "DispenseChainNodeFor50Yuan.h"

@implementation DispenseChainNodeFor50Yuan

/**
 
 首先查看当前值是否大于面额
 
     如果大于面额
 
         如果没有余数，则停止，不作处理
 
         如果有余数，则继续将当前值传递给下一个具体处理者（责任链的下一个节点）
 
         将当前值除以当前面额
 
     如果小于面额：将当前值传递给下一个具体处理者（责任链的下一个节点）
 
 */

- (void)dispense:(int)amount{
    
    int unit = 50;
    
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

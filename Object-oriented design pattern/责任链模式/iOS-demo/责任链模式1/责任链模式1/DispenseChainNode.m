//
//  DispenseChainNode.m
//  责任链模式1
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "DispenseChainNode.h"

@implementation DispenseChainNode

- (void)setNextChainNode:(DispenseChainNode *)chainNode{
    
    _nextChainNode = chainNode;
}

- (void)dispense:(int)amount{
    
    return;
}
@end

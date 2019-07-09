//
//  ATMDispenseChain.m
//  责任链模式2
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ATMDispenseChain.h"
#import "DispenseChainNode.h"

@implementation ATMDispenseChain
{
    DispenseChainNode *_firstChainNode;
    DispenseChainNode *_finalChainNode;
    int _minimumValue;
}

- (instancetype)init {
    
    @throw [NSException exceptionWithName:@"初始化方法错误" reason:@"未使用 `initWithDispenseNodeValues` 初始化" userInfo:@{NSStringFromClass(self.class):self.class}];
    
    return [self initWithDispenseNodeValues:nil];
}

- (instancetype)initWithDispenseNodeValues:(NSArray *)nodeValues{
    
    self = [super init];
    
    if(self){
        
        
        __weak typeof(self) _self = self;
        NSUInteger length = [nodeValues count];
        
        [nodeValues enumerateObjectsUsingBlock:^(NSNumber * nodeValue, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __strong typeof(_self) self = _self;
            
            DispenseChainNode *iterNode = [[DispenseChainNode alloc] initWithDispenseValue:[nodeValue intValue]];
            
            if (idx == length - 1 ) {
                self->_minimumValue = [nodeValue intValue];
            }
            
            if (!self->_firstChainNode) {
                
                //because this chain is empty, so the first node and the final node will refer the same node instance
                self->_firstChainNode =  iterNode;
                self->_finalChainNode =  self->_firstChainNode;
                
            }else{
                
                //appending the next node, and setting the new final node
                [self->_finalChainNode setNextChainNode:iterNode];
                self->_finalChainNode = iterNode;
            }
        }];
    }
    
    return self;
}


- (void)dispense:(int)amount{
    
    NSLog(@"==================================");
    NSLog(@"ATM start dispensing of amount:%d",amount);
    
    if (amount % _minimumValue != 0) {
        NSLog(@"Amount should be in multiple of %d",_minimumValue);
        return;
    }
    
    [ _firstChainNode dispense:amount];
    
}

@end

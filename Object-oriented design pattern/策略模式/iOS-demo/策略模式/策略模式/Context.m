//
//  Context.m
//  策略模式
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Context.h"

@implementation Context
{
    TwoIntOperation *_operation;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"初始化错误" reason:@"未使用initWithOperation初始化" userInfo:nil];
    return [self initWithOperation:nil];
}

+ (instancetype)new {
    @throw [NSException exceptionWithName:@"初始化错误" reason:@"未使用initWithOperation初始化" userInfo:nil];
    return [[self alloc] initWithOperation:nil];
}

- (instancetype)initWithOperation: (TwoIntOperation *)operation{
    
    self = [super init];
    if (self) {
        //injection from instane initialization
        _operation = operation;
    }
    return self;
}

- (void)setOperation:(TwoIntOperation *)operation{
    
    //injection from setting method
    _operation = operation;
}

- (int)excuteOperationOfInt1:(int)int1 int2:(int)int2{
    
    //return value by constract strategy instane
    return [_operation operationOfInt1:int1 int2:int2];
}

@end

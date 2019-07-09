
//
//  Store.m
//  简单工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Store.h"

#import "Phone.h"
#import "Computer.h"

@implementation Store

- (void)sellPhone:(Phone *)phone{
    NSLog(@"Store begins to sell phone:%@",[phone class]);
}

- (void)sellComputer:(Computer *)computer{
    NSLog(@"Store begins to sell phone:%@",[computer class]);
}

@end


//
//  Store.m
//  简单工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Store.h"

#import "Phone.h"

@implementation Store

- (void)sellPhone:(Phone *)phone{
    NSLog(@"Store begins to sell phone:%@",[phone class]);
}

@end

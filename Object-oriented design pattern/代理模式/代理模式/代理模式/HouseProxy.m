

//
//  HouseProxy.m
//  代理模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HouseProxy.h"
#import "HouseOwner.h"

const float agentFeeRatio = 0.35;

@interface HouseProxy()

@property (nonatomic, copy) HouseOwner *houseOwner;

@end

@implementation HouseProxy

- (void)getPayment:(double)money{
    
    double agentFee = agentFeeRatio * money;
    NSLog(@"Proxy get payment : %.2lf",agentFee);
    
    [self.houseOwner getPayment:(money - agentFee)];
}

- (HouseOwner *)houseOwner{
    
    if (!_houseOwner) {
        _houseOwner = [[HouseOwner alloc] init];
    }
    return _houseOwner;
}


@end

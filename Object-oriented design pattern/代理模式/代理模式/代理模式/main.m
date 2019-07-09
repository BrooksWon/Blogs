//
//  main.m
//  代理模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HouseProxy.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        HouseProxy *proxy  = HouseProxy.new;
        //向中介支付100块
        [proxy getPayment:100];
        
    }
    return 0;
}

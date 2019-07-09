//
//  main.m
//  NO-ISP
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OnlineClient.h"
#import "TelephoneClient.h"
#import "WalkinClient.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        OnlineClient *c = OnlineClient.new;
        TelephoneClient *t = TelephoneClient.new;
        WalkinClient *w = WalkinClient.new;
        
        NSArray *arr = @[c,t,w];
        [arr makeObjectsPerformSelector:@selector(placeOnlineOrder)];
        [arr makeObjectsPerformSelector:@selector(placeTelephoneOrder)];
        [arr makeObjectsPerformSelector:@selector(placeWalkInCustomerOrder)];
        [arr makeObjectsPerformSelector:@selector(payOnline)];
        [arr makeObjectsPerformSelector:@selector(payInPerson)];
    }
    return 0;
}

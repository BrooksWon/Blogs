//
//  main.m
//  责任链模式2
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATMDispenseChain.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        NSArray *dispenseNodeValues = [@[@(100),@(50),@(20),@(10),@(270)] sortedArrayUsingComparator:^NSComparisonResult(NSNumber*  _Nonnull obj1, NSNumber*  _Nonnull obj2) {
            if (obj1.intValue < obj2.intValue) {
                return NSOrderedDescending;
            }else {
                return NSOrderedAscending;
            }
            }];
        
        
        
        ATMDispenseChain *atm = [[ATMDispenseChain alloc] initWithDispenseNodeValues:dispenseNodeValues];
        
        [atm dispense:230];
        
        [atm dispense:70];
        
        [atm dispense:40];
        
        [atm dispense:10];
        
        [atm dispense:8];
        
        ATMDispenseChain *a = [[ATMDispenseChain alloc] init];

    }
    return 0;
}

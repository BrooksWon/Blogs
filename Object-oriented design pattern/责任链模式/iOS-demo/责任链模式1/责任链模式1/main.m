//
//  main.m
//  责任链模式1
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATMDispenseChain.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        ATMDispenseChain *atm = [[ATMDispenseChain alloc] init];
        
        [atm dispense:230];
        
        [atm dispense:70];
        
        [atm dispense:40];
        
        [atm dispense:10];
        
        [atm dispense:8];
    }
    return 0;
}

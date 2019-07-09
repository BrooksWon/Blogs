//
//  main.m
//  抽象工厂模式
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Store.h"
#import "Phone.h"
#import "Computer.h"
#import "AppleFactory.h"
#import "MIFactory.h"
#import "HWFactory.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Store *store = [[Store alloc] init];
        
        //Store wants to sell MacBook
        Computer *macBook = [AppleFactory createComputer];
        [macBook packaging];
        
        [store sellComputer:macBook];
        
        
        //Store wants to sell MIPhone
        Phone *miPhone = [MIFactory createPhone];
        [miPhone packaging];
        
        [store sellPhone:miPhone];
        
        
        //Store wants to sell MateBook
        Computer *hwComputer = [HWFactory createComputer];
        [hwComputer packaging];
        
        [store sellComputer:hwComputer];
    }
    return 0;
}

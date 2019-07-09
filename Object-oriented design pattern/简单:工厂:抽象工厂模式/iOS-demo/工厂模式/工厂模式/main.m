//
//  main.m
//  工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Store.h"
#import "Phone.h"
#import "IPhoneFactory.h"
#import "MIPhoneFactory.h"
#import "HWPhoneFactory.h"
//#import "MZPhoneFactory.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //A phone store
        Store *phoneStore = [[Store alloc] init];
        
        //phoneStore wants to sell iphone
        Phone *iphone = [IPhoneFactory  createPhone];
        [iphone packaging];
        [phoneStore sellPhone:iphone];
        
        
        //phoneStore wants to sell MIPhone
        Phone *miPhone = [MIPhoneFactory createPhone];
        [miPhone packaging];
        [phoneStore sellPhone:miPhone];
        
        //phoneStore wants to sell HWPhone
        Phone *hwPhone = [HWPhoneFactory createPhone];
        [hwPhone packaging];
        [phoneStore sellPhone:hwPhone];
        
        //新增需求
        //phoneStore wants to sell MZPhone
//        Phone *mzPhone = [MZPhoneFactory createPhone];
//        [mzPhone packaging];
//        [phoneStore sellPhone:mzPhone];
    }
    return 0;
}

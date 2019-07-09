//
//  main.m
//  简单工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Store.h"
#import "PhoneFactory.h"
#import "Phone.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        //1. A phone store  wants to sell iPhone
        Store *phoneStore = [[Store alloc] init];
        
        //2. create phone
        Phone *iPhone = [PhoneFactory  createPhoneWithTag:@"i"];
        
        //3. package phone to store
        [iPhone packaging];
        
        //4. store sells phone after receving it
        [phoneStore sellPhone:iPhone];
        
        //新增需求
//        Phone *mzPhone = [PhoneFactory createPhoneWithTag:@"MZ"];
//        [mzPhone packaging];
//        [phoneStore sellPhone:mzPhone];
    }
    return 0;
}

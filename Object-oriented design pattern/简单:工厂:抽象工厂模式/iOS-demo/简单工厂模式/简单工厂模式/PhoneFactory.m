
//
//  PhoneFactory.m
//  简单工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "PhoneFactory.h"

#import "IPhone.h"
#import "MIPhone.h"
#import "HWPhone.h"
#import "MZPhone.h"

@implementation PhoneFactory

+ (Phone *)createPhoneWithTag:(NSString *)tag{
    
    if ([tag isEqualToString:@"i"]) {
        
        IPhone *iphone = [[IPhone alloc] init];
        return iphone;
        
    }else if ([tag isEqualToString:@"MI"]){
        
        MIPhone *miPhone = [[MIPhone alloc] init];
        return miPhone;
        
    }else if ([tag isEqualToString:@"HW"]){
        
        HWPhone *hwPhone = [[HWPhone alloc] init];
        return hwPhone;
        
    }
    
//    //新增需求
//    else if (([tag isEqualToString:@"MZ"])) {
//        MZPhone *mzPhone = [[MZPhone alloc] init];
//        return mzPhone;
//    }
    
    else{
        
        return nil;
    }
}

@end

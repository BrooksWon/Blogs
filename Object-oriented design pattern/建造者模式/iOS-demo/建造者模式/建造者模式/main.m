//
//  main.m
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Director.h"
#import "IPhoneXRBuilder.h"
#import "MI8Builder.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //Get iPhoneXR
        //1. A director instance
        Director *director = [[Director alloc] init];
        
        //2. A builder instance
        IPhoneXRBuilder *iphoneXRBuilder = [[IPhoneXRBuilder alloc] init];
        
        //3. Construct phone by director
        [director construct:iphoneXRBuilder];
        
        //4. Get phone by builder
        Phone *iPhoneXR = [iphoneXRBuilder obtainPhone];
        NSLog(@"Get new phone iPhoneXR of data: %@",iPhoneXR);
        
        
        //Get MI8
        MI8Builder *mi8Builder = [[MI8Builder alloc] init];
        [director construct:mi8Builder];
        Phone *mi8 = [mi8Builder obtainPhone];
        NSLog(@"Get new phone MI8 of data: %@",mi8);
        
        
        /**
         从上面可以看出客户端获取具体产品的过程：
         
            1.首先需要实例化一个Director的实例。
         
            2.然后根据所需要的产品找出其对应的builder。
         
            3.将builder传入director实例的construct:方法。
         
            4.从builder的obtainPhone获取手机实例。
         
         */
    }
    return 0;
}

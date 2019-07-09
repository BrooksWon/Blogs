//
//  main.m
//  NO-LoD
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Client.h"
#import "GasEngine.h"
#import "Car.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        GasEngine *engine = GasEngine.new;
        engine.brandName = @"奔驰";
        
        Car *c = [[Car alloc]initWithEngine:engine];
       
        Client *client = Client.new;
        NSLog(@"%@", [client findCarEngineBrandName:c]);
    }
    return 0;
}

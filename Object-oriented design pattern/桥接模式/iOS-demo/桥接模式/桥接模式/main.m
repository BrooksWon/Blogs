//
//  main.m
//  桥接模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Rectangle.h"
#import "Square.h"
#import "Circle.h"
#import "RedColor.h"
#import "GreenColor.h"
#import "BlueColor.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //create 3 shape instances
        Rectangle *rect = [[Rectangle alloc] init];
        Circle *circle = [[Circle alloc] init];
        Square *square = [[Square alloc] init];
        
        //create 3 color instances
        RedColor *red = [[RedColor alloc] init];
        GreenColor *green = [[GreenColor alloc] init];
        BlueColor *blue = [[BlueColor alloc] init];
        
        //rect & red color
        [rect renderColor:red];
        [rect show];
        
        //rect & green color
        [rect renderColor:green];
        [rect show];
        
        
        //circle & blue color
        [circle renderColor:blue];
        [circle show];
        
        //circle & green color
        [circle renderColor:green];
        [circle show];
        
        
        
        //square & blue color
        [square renderColor:blue];
        [square show];
        
        //square & red color
        [square renderColor:red];
        [square show];
    }
    return 0;
}

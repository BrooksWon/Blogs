//
//  main.m
//  NO-LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Client.h"
#import "Square.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        Client *c = Client.new;
        
        Rectangle *rect = [[Rectangle alloc] init];
        rect.width = 10;
        rect.height = 20;
        
        double rectArea = [c calculateAreaOfRect:rect];
        NSLog(@"Rectangle :%@", @(rectArea));
        
        Square *square = [[Square alloc] init];
        square.width = 10;
        square.height = 20;
        
        double squareArea = [c calculateAreaOfRect:square];
        NSLog(@"squareArea :%@", @(squareArea));
        
    }
    return 0;
}

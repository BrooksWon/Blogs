//
//  main.m
//  顺序查找
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OrderSearch.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSArray *array = @[@7,@2,@9,@1,@8,@4,@6,@3,@5,@0,@0,@0,@0,@0,@0];
        
        NSLog(@"array = %@",array);
        
        NSLog(@"index of 4 is %@",@([OrderSearch orderSearch:@4 inDatas:array]));
        NSLog(@"index of 5 is %@",@([OrderSearch orderSearch:@5 inDatas:array]));
    }
    return 0;
}

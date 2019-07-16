//
//  main.m
//  希尔排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShellSort.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSArray *unSortArray = @[@7,@2,@9,@1,@8,@4,@6,@3,@5];
        NSArray *sortArray = [ShellSort shellSort:unSortArray];
        
        NSLog(@"sortArray = %@",sortArray);
    }
    return 0;
}

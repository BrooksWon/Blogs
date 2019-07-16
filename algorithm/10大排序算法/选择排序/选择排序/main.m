//
//  main.m
//  选择排序
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SelectionSort.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSArray *unSortArray = @[@7,@2,@9,@1,@8,@4,@6,@3,@5];
        NSArray *sortArray = [SelectionSort selectionSort:unSortArray];
        
        NSLog(@"sortArray = %@",sortArray);
    }
    return 0;
}

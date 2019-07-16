//
//  main.m
//  快速排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QuickSort.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSArray *unSortArray = @[@7,@2,@9,@1,@8,@4,@6,@3,@5,@0,@0,@0];
        NSArray *sortArray = [QuickSort quickSort:unSortArray.mutableCopy leftIndex:0 rightIndex:unSortArray.count-1];
        
        NSLog(@"sortArray = %@",sortArray);
    }
    return 0;
}

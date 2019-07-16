//
//  main.m
//  归并排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MergeSort.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        NSArray *unSortArray = @[@7,@2,@9,@1,@8,@4,@6,@3,@5,@0,@0,@0];
        NSArray *sortArray = [MergeSort mergeSort:unSortArray];
        
        NSLog(@"sortArray = %@",sortArray);
        
    }
    return 0;
}

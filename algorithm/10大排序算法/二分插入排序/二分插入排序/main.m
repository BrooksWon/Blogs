//
//  main.m
//  二分插入排序
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BinarySearchSort.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        
        NSArray *unSortArray = @[@7,@2,@9,@1,@8,@4,@6,@3,@5,@0,@0,@0,@0,@0,@0];
//        NSArray *sortArray = [BinarySearchSort binarySearchSort:unSortArray];
//
//        NSLog(@"sortArray = %@",sortArray);
//
//        NSLog(@"index of 4 is %@",@([BinarySearchSort binarySearch:sortArray start:0 end:sortArray.count-1 keyObjetc:@4]));
//        NSLog(@"index of 5 is %@",@([BinarySearchSort binarySearch:sortArray keyObjetc:@5]));
        
        NSArray *sortArray = [BinarySearchSort InsertSort_Binary:unSortArray];

        NSLog(@"sortArray = %@",sortArray);
    }
    return 0;
}

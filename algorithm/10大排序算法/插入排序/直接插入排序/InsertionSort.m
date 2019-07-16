//
//  InsertionSort.m
//  直接插入排序
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "InsertionSort.h"

@implementation InsertionSort

+ (NSArray *)insertionSort:(NSArray *)unsortDatas {
    NSMutableArray *unSortArray = [unsortDatas mutableCopy];
    int preindx = 0;
    NSNumber *current;
    
    for (int i=1; i<unSortArray.count; i++) {
        preindx = i-1;
        // 必须记录这个元素，不然会被覆盖掉
        current = unSortArray[i];
        
        // 逆序遍历已经排序好的数组
        // 当前元素小于排序好的元素，就移动到下一个位置
        while (preindx >=0 && [current integerValue] < [unSortArray[preindx] integerValue]) {
            // 元素向后移动
            unSortArray[preindx+1] = unSortArray[preindx];
            preindx -= 1;
        }
        
        // 找到合适的位置，把当前的元素插入
        unSortArray[preindx+1] = current;

    }
    
    return [unSortArray copy];
}

@end

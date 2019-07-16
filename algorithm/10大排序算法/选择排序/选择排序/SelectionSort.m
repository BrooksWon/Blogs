//
//  SelectionSort.m
//  选择排序
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "SelectionSort.h"

@implementation SelectionSort

+ (NSArray *)selectionSort:(NSArray *)unsortDatas {
    NSMutableArray *unSortArray = [unsortDatas mutableCopy];
    
    for (int i=0; i<unSortArray.count; i++) {
        
        //表示当前最小元素的下标
        int sortIndex = i;
        
        for (int j=i; j<unSortArray.count; j++) {
            //找出最小的元素，追加在数据的有序部分后面
            if ([unSortArray[j] integerValue] < [unSortArray[sortIndex] integerValue]) {
                sortIndex = j;
            }
        }
        
        NSNumber *temp = unSortArray[i];
        unSortArray[i] = unSortArray[sortIndex];
        unSortArray[sortIndex] = temp;
    }
    
    return [unSortArray copy];
}

@end

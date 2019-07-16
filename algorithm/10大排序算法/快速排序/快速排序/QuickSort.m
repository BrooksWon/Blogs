//
//  QuickSort.m
//  快速排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "QuickSort.h"

@implementation QuickSort


/**
 快速排序 【参考链接 https://mp.weixin.qq.com/s/axQY2hfi4CboZQasq2ny2w 】
 
 @param unSortArray 待排序序列
 @param lindex 待排序序列左边的index
 @param rIndex 待排序序列右边的index
 @return 排序结果
 */
+ (NSArray *)quickSort:(NSMutableArray *)unSortArray leftIndex:(NSInteger)lindex rightIndex:(NSInteger)rIndex {
    NSInteger i = lindex;
    NSInteger j = rIndex;
    
    // 取中间的值作为一个支点
    NSNumber *pivot = unSortArray[(lindex + rIndex) / 2];
    while (i <= j) {
        // 向左移动，直到找打大于支点的元素
        while ([unSortArray[i] integerValue] < [pivot integerValue]) {
            i++;
        }
        // 向右移动，直到找到小于支点的元素
        while ([unSortArray[j] integerValue] > [pivot integerValue]) {
            j--;
        }
        // 交换两个元素，让左边的小于支点，右边的大于支点
        if (i <= j) {
            // 如果 i== j，交换个啥？
            if (i != j) {
                NSNumber *temp = unSortArray[i];
                unSortArray[i] = unSortArray[j];
                unSortArray[j] = temp; }
            i++;
            j--;
        }
    }
    // 递归左边，进行快速排序
    if (lindex < j) {
        [self quickSort:unSortArray leftIndex:lindex rightIndex:j];
    }
    // 递归右边，进行快速排序
    if (i < rIndex) {
        [self quickSort:unSortArray leftIndex:i rightIndex:rIndex];
    }
    return [unSortArray copy];
}

@end

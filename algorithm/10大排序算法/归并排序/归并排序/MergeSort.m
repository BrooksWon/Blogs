//
//  MergeSort.m
//  归并排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "MergeSort.h"

@implementation MergeSort

//参考链接 https://mp.weixin.qq.com/s/KNkRUZaRFbLytnobbtdSGg
+ (NSArray *)mergeSort:(NSArray *)unSortArray {
    NSInteger len = unSortArray.count;
    // 递归终止条件
    if (len <= 1) {
        return unSortArray;
    }
    NSInteger mid = len / 2;
    // 对左半部分进行拆分
    NSArray *lList = [self mergeSort:[unSortArray subarrayWithRange:NSMakeRange(0, mid)]];
    // 对右半部分进行拆分
    NSArray *rList = [self mergeSort:[unSortArray subarrayWithRange:NSMakeRange(mid, len-mid)]];
    // 递归结束后执行下面的语句
    NSInteger lIndex = 0;
    NSInteger rIndex = 0;
    // 进行合并
    NSMutableArray *results = [NSMutableArray array];
    while (lIndex < lList.count && rIndex < rList.count) {
        if ([lList[lIndex] integerValue] < [rList[rIndex] integerValue]) {
            [results addObject:lList[lIndex]];
            lIndex += 1;
        } else {
            [results addObject:rList[rIndex]];
            rIndex += 1;
        }
    }
    // 把左边剩余元素加到排序结果中
    if (lIndex < lList.count) {
        [results addObjectsFromArray:[lList subarrayWithRange:NSMakeRange(lIndex, lList.count-lIndex)]];
    }
    // 把右边剩余元素加到排序结果中
    if (rIndex < rList.count) {
        [results addObjectsFromArray:[rList subarrayWithRange:NSMakeRange(rIndex, rList.count-rIndex)]];
    }
    return results;
}

@end

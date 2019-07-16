//
//  ShellSort.m
//  希尔排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ShellSort.h"

@implementation ShellSort

//参考链接 https://mp.weixin.qq.com/s/XclzRMpv0KcI366BiqLbsA
+ (NSArray *)shellSort:(NSArray *)unsortDatas {
    NSMutableArray *unSortArray = [unsortDatas mutableCopy];
    // len = 9
    int len = (int)unSortArray.count;
    // floor 向下取整，所以 gap的值为：4，2，1
    for (int gap = floor(len / 2); gap > 0; gap = floor(gap/2)) {
        // i=4;i<9;i++ (4,5,6,7,8)
        for (int i = gap; i < len; i++) {
            // j=0,1,2,3,4
            // [0]-[4] [1]-[5] [2]-[6] [3]-[7] [4]-[8]
            for (int j = i - gap; j >= 0 && [unSortArray[j] integerValue] > [unSortArray[j+gap] integerValue]; j-=gap) {
                // 交换位置
                NSNumber *temp = unSortArray[j];
                unSortArray[j] = unSortArray[gap+j];
                unSortArray[gap+j] = temp;
            }
        }
    }
    return [unSortArray copy];
}

@end

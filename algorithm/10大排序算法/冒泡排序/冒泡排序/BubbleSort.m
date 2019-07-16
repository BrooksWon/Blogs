//
//  BubbleSort.m
//  冒泡排序
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "BubbleSort.h"

@implementation BubbleSort

+ (NSArray *)bubbleSort:(NSArray *)unsortDatas {
    NSMutableArray *unSortArray = [unsortDatas mutableCopy];
    
    for (int i=0; i<unSortArray.count-1; i++) {
        
        BOOL isChange = NO;
        
        for (int j=0; j<unSortArray.count-1; j++) {
            // 比较相邻两个元素的大小，前一个大于后一个就交换
            if ([unSortArray[j] integerValue] > [unSortArray[j+1] integerValue]) {
                NSNumber *temp = unSortArray[j];
                unSortArray[j] = unSortArray[j+1];
                unSortArray[j+1] = temp;
                
                isChange = YES;
            }
        }
        
        if (!isChange) {
            // 如果某一趟未发生数据交换，说明数据已排序
            break;
        }
    }
    
    return [unSortArray copy];
}

@end

//
//  BinarySearchSort.m
//  二分插入排序
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "BinarySearchSort.h"

@implementation BinarySearchSort

+ (NSArray*)InsertSort_Binary:(NSArray<NSNumber*>*) array
{
    NSMutableArray<NSNumber*> *unSortArray = [array mutableCopy];

    
    if (array.count<= 0){
        return unSortArray;
    }
    
    for (int i = 1; i < unSortArray.count; ++i)
    {
        
        NSNumber* temp = unSortArray[i];
        
        int left = 0;     // 有序序列的左边界
        int right = i - 1;// 有序序列的右边界
        
        while (left <= right)
        {
            int mid = (left + right) / 2;
            // 注意这里的 等号，为了保证算法的稳定性（相同关键字排序前后位置不会变）
            // 所以也需要向后移动
            if (unSortArray[mid].integerValue <= temp.integerValue)
                left = mid + 1;
            else if (unSortArray[mid].integerValue > temp.integerValue)
                right = mid - 1;
            
        }
        
        // 搬移数据， 上面循环结束后，left的位置就是插入位置
        // 需要将从left 到 当前插入元素的前一个位置都搬移一个位置
        for (int j = i - 1; j >= left; --j)
        {
            unSortArray[j + 1] = unSortArray[j];
        }
        unSortArray[left] = temp;
    }
    
    return unSortArray.copy;
}

/**

//二分查找-尾递归实现,假定参数是升序数组
+ (int)binarySearch:(NSArray *)sortDatas start:(int)start end:(int)end keyObjetc:(NSNumber*)keyNumeber  {
    if (start > end) {
        return -1;// 未搜索到数据返回-1下标
    }
    
    int mid = start + (end-start)/2;
    
    if([keyNumeber integerValue] > [sortDatas[mid] integerValue]) {
        return [self binarySearch:sortDatas start:mid+1 end:end keyObjetc:keyNumeber];
    }else if ([keyNumeber integerValue] < [sortDatas[mid] integerValue]) {
        return [self binarySearch:sortDatas start:start end:mid-1 keyObjetc:keyNumeber];
    }else {
        return mid;
    }
}

//二分查找-while实现,假定参数是升序数组
+ (int)binarySearch:(NSArray *)sortDatas keyObjetc:(NSNumber*)keyNumeber {
    int ret = -1;// 未搜索到数据返回-1下标
    
    int start = 0;
    int end = sortDatas.count-1;
    int mid;
    
    while (start <= end) {
        mid = start + (end-start)/2;//直接平均可能會溢位，所以用此算法
        
        if ([keyNumeber integerValue] > [sortDatas[mid] integerValue]) {
            start = mid+1;
        }else if ([keyNumeber integerValue] < [sortDatas[mid] integerValue]) {
            end = mid-1;
        }else {
            ret = mid;
            break;
        }
    }
    
    return ret;
}

+ (NSArray*)binarySearchSort:(NSArray *)unsortDatas {
    NSMutableArray *unSortArray = [unsortDatas mutableCopy];
    
    int preindx = 0;
    NSNumber *current;
    
    for (int i=1; i<unSortArray.count; i++) {
        preindx = i-1;
        current = unSortArray[i];

        while (preindx >=0 && [current integerValue] < [unSortArray[preindx] integerValue]) {
            unSortArray[preindx+1] = unSortArray[preindx];
            preindx -= 1;
        }
        
        unSortArray[preindx+1] = current;
    }
    
    return unSortArray;
}


*/


@end

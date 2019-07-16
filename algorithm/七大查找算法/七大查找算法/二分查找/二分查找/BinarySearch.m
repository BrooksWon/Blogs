//
//  BinarySearch.m
//  二分查找
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "BinarySearch.h"

@implementation BinarySearch

//二分查找-尾递归实现,假定参数是升序数组
+ (int)binarySearch:(NSArray *)sortDatas start:(int)start end:(int)end keyObjetc:(NSNumber*)searchKey  {
    if (start > end) {
        return -1;// 未搜索到数据返回-1下标
    }
    
    int mid = start + (end-start)/2;
    
    if([searchKey integerValue] > [sortDatas[mid] integerValue]) {
        return [self binarySearch:sortDatas start:mid+1 end:end keyObjetc:searchKey];
    }else if ([searchKey integerValue] < [sortDatas[mid] integerValue]) {
        return [self binarySearch:sortDatas start:start end:mid-1 keyObjetc:searchKey];
    }else {
        return mid;
    }
}

//二分查找-while实现,假定参数是升序数组
+ (int)binarySearch:(NSArray *)sortDatas keyObjetc:(NSNumber*)searchKey {
    int ret = -1;// 未搜索到数据返回-1下标
    
    int start = 0;
    int end = sortDatas.count-1;
    int mid;
    
    while (start <= end) {
        mid = start + (end-start)/2;//直接平均可能會溢位，所以用此算法
        
        if ([searchKey integerValue] > [sortDatas[mid] integerValue]) {
            start = mid+1;
        }else if ([searchKey integerValue] < [sortDatas[mid] integerValue]) {
            end = mid-1;
        }else {
            ret = mid;
            break;
        }
    }
    
    return ret;
}

@end

//
//  BinarySearch.h
//  二分查找
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinarySearch : NSObject


/**
 二分查找-尾递归实现, 假定参数是升序数组

 @param sortDatas 等待查找的数组
 @param start 查找起点
 @param end 查找终点
 @param searchKey 等待查找的元素
 @return 元素在数组中的角标
 */
+ (int)binarySearch:(NSArray *)sortDatas start:(int)start end:(int)end keyObjetc:(NSNumber*)searchKey;


/**
 二分查找-while实现,假定参数是升序数组

 @param sortDatas 等待查找的数组
 @param searchKey 等待查找的元素
 @return 元素在数组中的角标
 */
+ (int)binarySearch:(NSArray *)sortDatas keyObjetc:(NSNumber*)searchKey;

@end

NS_ASSUME_NONNULL_END

//
//  BinarySearchSort.h
//  二分插入排序
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinarySearchSort : NSObject

//+ (NSArray*)binarySearchSort:(NSArray *)unsortDatas;
//
//+ (int)binarySearch:(NSArray *)sortDatas start:(int)start end:(int)end keyObjetc:(NSNumber*)keyNumeber;
//+ (int)binarySearch:(NSArray *)sortDatas keyObjetc:(NSNumber*)keyNumeber;

+ (NSArray*)InsertSort_Binary:(NSArray<NSNumber*>*) array;

@end

NS_ASSUME_NONNULL_END

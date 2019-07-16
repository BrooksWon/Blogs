//
//  QuickSort.h
//  快速排序
//
//  Created by Brooks on 2019/6/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickSort : NSObject

+ (NSArray *)quickSort:(NSMutableArray *)unSortArray leftIndex:(NSInteger)lindex rightIndex:(NSInteger)rIndex;

@end

NS_ASSUME_NONNULL_END

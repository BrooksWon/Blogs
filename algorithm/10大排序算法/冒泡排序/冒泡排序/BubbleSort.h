//
//  BubbleSort.h
//  冒泡排序
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BubbleSort : NSObject


/**
 冒泡排序

 @param unsortDatas 待排序数据
 @return 排好序的数据
 */
+ (NSArray *)bubbleSort:(NSArray *)unsortDatas;

@end

NS_ASSUME_NONNULL_END

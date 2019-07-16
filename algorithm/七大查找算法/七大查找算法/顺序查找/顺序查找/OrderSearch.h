//
//  OrderSearch.h
//  顺序查找
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderSearch : NSObject

/**顺序查找平均时间复杂度 O（n）
 * @param searchKey 要查找的值
 * @param datas 数组（从这个数组中查找）
 * @return  查找结果（数组的下标位置）
 */
+ (int)orderSearch:(NSNumber*)searchKey inDatas:(NSArray *)datas;

@end

NS_ASSUME_NONNULL_END

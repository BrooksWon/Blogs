//
//  OrderSearch.m
//  顺序查找
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "OrderSearch.h"

@implementation OrderSearch

/**顺序查找平均时间复杂度 O（n）
 * @param searchKey 要查找的值
 * @param datas 数组（从这个数组中查找）
 * @return  查找结果（数组的下标位置）
 */
+ (int)orderSearch:(NSNumber*)searchKey inDatas:(NSArray *)datas{
    if(datas == nil || datas.count < 1) {
        return -1;

    }
    
    for(int i = 0; i < datas.count; i++){
        if(datas[i] == searchKey){
            return i;
        }
    }
    
    return -1;
}

@end

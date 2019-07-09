//
//  HotDrink.h
//  模板方法模式
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotDrink : NSObject

//制作热饮
- (void)makingProcess;

//添加主成分
- (void)addMainMaterial;

//添加辅助成分
- (void)addIngredients;

@end

NS_ASSUME_NONNULL_END

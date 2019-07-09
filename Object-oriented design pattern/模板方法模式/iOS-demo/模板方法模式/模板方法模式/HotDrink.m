
//
//  HotDrink.m
//  模板方法模式
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HotDrink.h"

@implementation HotDrink

- (void)makingProcess{
    
    NSLog(@" ===== Begin to making %@ ===== ", NSStringFromClass([self class]));
    
    //准备热水
    [self _prepareHotWater];
    
    //添加主成分
    [self addMainMaterial];
    
    //添加辅助成分
    [self addIngredients];
}


//私有方法
- (void)_prepareHotWater{
    
    NSLog(@"prepare hot water");
}


- (void)addMainMaterial{
    
    NSLog(@"implemetation by subClasses");
}


- (void)addIngredients{
    
    NSLog(@"implemetation by subClasses");
}

@end

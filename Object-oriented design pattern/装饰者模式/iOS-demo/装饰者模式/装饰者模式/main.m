//
//  main.m
//  装饰者模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VegetableSalad.h"
#import "VinegarSauceDecorator.h"
#import "BeefSalad.h"
#import "BlueBerrySauceDecorator.h"
#import "PeanutButterSauceDecorator.h"
#import "ChickenSalad.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        /**
         
         OK，到现在所有的类已经定义好了，为了验证是否实现正确，下面用客户端尝试着搭配几种不同的沙拉吧：
         
            1. 蔬菜加单份醋汁沙拉（7元）
         
            2. 牛肉加双份花生酱沙拉（24元）
         
            3. 鸡肉加单份花生酱再加单份蓝莓酱沙拉（20元）
         
         */
        
        //vegetable salad add vinegar sauce
        Salad *vegetableSalad = [[VegetableSalad alloc] init];
        NSLog(@"%@",vegetableSalad);
        
        vegetableSalad = [[VinegarSauceDecorator alloc] initWithSalad:vegetableSalad];
        NSLog(@"%@",vegetableSalad);
        
        
        //beef salad add two peanut butter sauce:
        Salad *beefSalad = [[BeefSalad alloc] init];
        NSLog(@"%@",beefSalad);
        
        beefSalad = [[PeanutButterSauceDecorator alloc] initWithSalad:beefSalad];
        NSLog(@"%@",beefSalad);
        
        beefSalad = [[PeanutButterSauceDecorator alloc] initWithSalad:beefSalad];
        NSLog(@"%@",beefSalad);
        
        
        //chiken salad add peanut butter sauce and blueberry sauce
        Salad *chikenSalad = [[ChickenSalad alloc] init];
        NSLog(@"%@",chikenSalad);
        
        chikenSalad = [[PeanutButterSauceDecorator alloc] initWithSalad:chikenSalad];
        NSLog(@"%@",chikenSalad);
        
        chikenSalad = [[BlueBerrySauceDecorator alloc] initWithSalad:chikenSalad];
        NSLog(@"%@",chikenSalad);
    }
    return 0;
}

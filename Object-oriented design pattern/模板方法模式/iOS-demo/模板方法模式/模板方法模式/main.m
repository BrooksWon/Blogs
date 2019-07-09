//
//  main.m
//  模板方法模式
//
//  Created by Brooks on 2019/6/3.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotDrinkTea.h"
#import "HotDrinkLatte.h"
#import "HotDrinkAmericano.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        HotDrink *tea = HotDrinkTea.new;
        [tea makingProcess];
        
        HotDrink *latte = HotDrinkLatte.new;
        [latte makingProcess];
        
        HotDrink *americano = HotDrinkAmericano.new;
        [americano makingProcess];

    }
    return 0;
}

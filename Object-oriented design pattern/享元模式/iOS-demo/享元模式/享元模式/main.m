//
//  main.m
//  享元模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowerFactory.h"
#import "FlowerImageView.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
       
        //首先建造一个生产花内部图片对象的工厂
        FlowerFactory *factory = [[FlowerFactory alloc] init];
        
        for (int i = 0; i < 100; ++i)
        {
            //随机传入一个花的类型，让工厂返回该类型对应花类型的花对象
            FlowerType flowerType = arc4random() % kTotalNumberOfFlowerTypes;
            FlowerImageView *flowerImageView = [factory flowerImageWithType:flowerType];
            
        }
    }
    return 0;
}

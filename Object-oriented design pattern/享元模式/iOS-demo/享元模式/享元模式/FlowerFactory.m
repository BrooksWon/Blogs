//
//  FlowerFactory.m
//  享元模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "FlowerFactory.h"


@implementation FlowerFactory
{
    NSMutableDictionary *_flowersPool;
}

- (FlowerImageView *) flowerImageWithType:(FlowerType)type
{
    
    if (_flowersPool == nil){
        
        _flowersPool = [[NSMutableDictionary alloc] initWithCapacity:kTotalNumberOfFlowerTypes];
    }
    
    //尝试获取传入类型对应的花内部图片对象
    NSImage *flowerImage = [_flowersPool objectForKey:[NSNumber numberWithInt:type]];
    
    //如果没有对应类型的图片，则生成一个
    if (flowerImage == nil){
        
        NSLog(@"create new flower image with type:%u",type);
        
        switch (type){
                
            case kAnemone:
                flowerImage = [NSImage imageNamed:@"anemone.png"];
                break;
            case kCosmos:
                flowerImage = [NSImage imageNamed:@"cosmos.png"];
                break;
            case kGerberas:
                flowerImage = [NSImage imageNamed:@"gerberas.png"];
                break;
            case kHollyhock:
                flowerImage = [NSImage imageNamed:@"hollyhock.png"];
                break;
            case kJasmine:
                flowerImage = [NSImage imageNamed:@"jasmine.png"];
                break;
            case kZinnia:
                flowerImage = [NSImage imageNamed:@"zinnia.png"];
                break;
            default:
                flowerImage = nil;
                break;
                
        }
        
    }
    
    
    FlowerImageView *flowerImageView = nil;
    
    if (flowerImage) {
        [_flowersPool setObject:flowerImage forKey:[NSNumber numberWithInt:type]];
        //创建花对象，将上面拿到的花内部图片对象赋值并返回
        flowerImageView = [FlowerImageView imageViewWithImage:flowerImage];
    }
    else{
        //如果有对应类型的图片，则直接使用
        NSLog(@"reuse flower image with type:%u",type);
    }
   
    
    return flowerImageView;
}

@end

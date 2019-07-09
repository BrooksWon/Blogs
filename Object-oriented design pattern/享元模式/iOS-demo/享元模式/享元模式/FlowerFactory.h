//
//  FlowerFactory.h
//  享元模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlowerImageView.h"

typedef enum
{
    kAnemone,
    kCosmos,
    kGerberas,
    kHollyhock,
    kJasmine,
    kZinnia,
    kTotalNumberOfFlowerTypes
    
} FlowerType;

@interface FlowerFactory : NSObject

- (FlowerImageView *) flowerImageWithType:(FlowerType)type;

@end

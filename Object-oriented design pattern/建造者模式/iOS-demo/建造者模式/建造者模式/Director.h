//
//  Director.h
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Builder.h"

NS_ASSUME_NONNULL_BEGIN

@interface Director : NSObject


- (void)construct:(Builder *)builder;

@end

NS_ASSUME_NONNULL_END

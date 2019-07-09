//
//  Shape.h
//  桥接模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Color.h"

NS_ASSUME_NONNULL_BEGIN

@interface Shape : NSObject
{
@protected Color *_color;
}

- (void)renderColor:(Color *)color;

- (void)show;

@end

NS_ASSUME_NONNULL_END

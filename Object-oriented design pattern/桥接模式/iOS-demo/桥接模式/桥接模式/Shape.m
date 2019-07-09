
//
//  Shape.m
//  桥接模式
//
//  Created by Brooks on 2019/5/24.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Shape.h"

@implementation Shape
- (void)renderColor:(Color *)color{
    
    _color = color;
}

- (void)show{
    NSLog(@"Show %@ with %@",[self class],[_color class]);
}

@end

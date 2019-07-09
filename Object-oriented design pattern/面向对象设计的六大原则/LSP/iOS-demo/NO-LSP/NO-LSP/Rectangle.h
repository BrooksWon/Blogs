//
//  Rectangle.h
//  NO-LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Rectangle : NSObject
{
@protected double _width;
@protected double _height;
}

//设置宽高
- (void)setWidth:(double)width;
- (void)setHeight:(double)height;

//获取宽高
- (double)width;
- (double)height;

//获取面积
- (double)getArea;

@end

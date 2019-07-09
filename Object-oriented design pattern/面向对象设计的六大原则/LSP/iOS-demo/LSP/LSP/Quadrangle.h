//
//  Quadrangle.h
//  LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Quadrangle : NSObject
{
@protected double _width;
@protected double _height;
}

/**

 为了方面理解这个原则、👇下面几个方法要理解为抽象方法
 */
- (void)setWidth:(double)width;
- (void)setHeight:(double)height;

- (double)width;
- (double)height;

//获取面积
- (double)getArea;


@end

NS_ASSUME_NONNULL_END

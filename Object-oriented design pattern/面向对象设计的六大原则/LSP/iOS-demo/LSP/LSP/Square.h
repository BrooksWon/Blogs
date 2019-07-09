//
//  Square.h
//  LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Quadrangle.h"

NS_ASSUME_NONNULL_BEGIN

@interface Square : Quadrangle
{
@protected double _sideLength;
}

-(void)setSideLength:(double)sideLength;

-(double)sideLength;

@end

NS_ASSUME_NONNULL_END

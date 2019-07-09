
//
//  Square.m
//  LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Square.h"

@implementation Square

- (void)setSideLength:(double)sideLength {
    _sideLength = sideLength;
}

- (void)setWidth:(double)width {
    _sideLength = width;
}

- (void)setHeight:(double)height {
    _sideLength = height;
}

- (double)sideLength {
    return _sideLength;
}

-(double)width {
    return _sideLength;
}

- (double)height {
    return _sideLength;
}

- (double)getArea {
    return _sideLength*_sideLength;
}

@end

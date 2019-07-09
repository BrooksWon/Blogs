//
//  Client.m
//  LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Client.h"

#import "Quadrangle.h"

@implementation Client

- (double)calculateAreaOfRect:(Quadrangle *)rect{
    return [rect getArea];
}

@end

//
//  Client.m
//  NO-LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Client.h"

#import "Rectangle.h"

@implementation Client

- (double)calculateAreaOfRect:(Rectangle *)rect{
    return [rect getArea];
}

@end

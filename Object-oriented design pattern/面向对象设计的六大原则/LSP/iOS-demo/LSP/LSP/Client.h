//
//  Client.h
//  LSP
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Quadrangle;

NS_ASSUME_NONNULL_BEGIN

@interface Client : NSObject

- (double)calculateAreaOfRect:(Quadrangle *)rect;

@end

NS_ASSUME_NONNULL_END

//
//  Store.h
//  简单工厂模式
//
//  Created by Brooks on 2019/5/13.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Phone;

NS_ASSUME_NONNULL_BEGIN

@interface Store : NSObject

- (void)sellPhone:(Phone *)phone;

@end

NS_ASSUME_NONNULL_END

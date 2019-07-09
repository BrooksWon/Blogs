//
//  Client.h
//  NO-LoD
//
//  Created by Brooks on 2019/5/12.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Car;

NS_ASSUME_NONNULL_BEGIN

@interface Client : NSObject

- (NSString *)findCarEngineBrandName:(Car *)car;

@end

NS_ASSUME_NONNULL_END

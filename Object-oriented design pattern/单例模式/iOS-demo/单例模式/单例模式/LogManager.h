//
//  LogManager.h
//  单例模式
//
//  Created by Brooks on 2019/5/15.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogManager : NSObject

+(instancetype)sharedInstance;

- (void)printLog:(NSString *)logMessage;

- (void)uploadLog:(NSString *)logMessage;

@end

NS_ASSUME_NONNULL_END

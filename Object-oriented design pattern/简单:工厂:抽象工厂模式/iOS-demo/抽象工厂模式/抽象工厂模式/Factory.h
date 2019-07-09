//
//  Factory.h
//  抽象工厂模式
//
//  Created by Brooks on 2019/5/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Phone;
@class Computer;

NS_ASSUME_NONNULL_BEGIN

@interface Factory : NSObject

+ (Phone *)createPhone;

+ (Computer *)createComputer;

@end

NS_ASSUME_NONNULL_END

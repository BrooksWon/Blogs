//
//  Phone.h
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Phone : NSObject

@property (nonatomic, copy) NSString *cpu;
@property (nonatomic, copy) NSString *capacity;
@property (nonatomic, copy) NSString *display;
@property (nonatomic, copy) NSString *camera;

@end

NS_ASSUME_NONNULL_END

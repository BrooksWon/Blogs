//
//  Resume.h
//  原型模式
//
//  Created by Brooks on 2019/5/17.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UniversityInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface Resume :  NSObject<NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *age;

@property (nonatomic, strong) UniversityInfo *universityInfo;


@end

NS_ASSUME_NONNULL_END

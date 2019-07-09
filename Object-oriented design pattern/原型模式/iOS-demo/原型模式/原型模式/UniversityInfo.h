//
//  UniversityInfo.h
//  原型模式
//
//  Created by Brooks on 2019/5/17.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniversityInfo : NSObject<NSCopying>

@property (nonatomic, copy) NSString *universityName;
@property (nonatomic, copy) NSString *startYear;
@property (nonatomic, copy) NSString *endYear;
@property (nonatomic, copy) NSString *major;

- (id)copyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END

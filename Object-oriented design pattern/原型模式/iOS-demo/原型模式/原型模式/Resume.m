
//
//  Resume.m
//  原型模式
//
//  Created by Brooks on 2019/5/17.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Resume.h"

@implementation Resume

- (id)copyWithZone:(nullable NSZone *)zone
{
    Resume *resumeCopy = [[[self class] allocWithZone:zone] init];
    
    [resumeCopy setName:[_name mutableCopy]];
    [resumeCopy setGender:[_gender mutableCopy]];
    [resumeCopy setAge:[_age mutableCopy]];
    [resumeCopy setUniversityInfo:[_universityInfo copy]];
    
    return resumeCopy;
}

/**
 
 同样地，简历对象也需要遵从<NSCopying>协议并实现copyWithZone:方法。

 */

- (NSString *)description{
    
    return [NSString stringWithFormat:@"\nresume object address:%p\nname:%@ | %p\ngender:%@ | %p\nage:%@ | %p\nuniversity name:%@| %p\nuniversity start year:%@ | %p\nuniversity end year:%@ | %p\nuniversity major:%@ | %p",self,_name,_name,_gender,_gender,_age,_age,_universityInfo.universityName,_universityInfo.universityName,_universityInfo.startYear,_universityInfo.startYear,_universityInfo.endYear,_universityInfo.endYear,_universityInfo.major,_universityInfo.major];
}


@end

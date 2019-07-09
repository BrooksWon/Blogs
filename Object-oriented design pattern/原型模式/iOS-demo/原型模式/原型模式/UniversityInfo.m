
//
//  UniversityInfo.m
//  原型模式
//
//  Created by Brooks on 2019/5/17.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "UniversityInfo.h"

@implementation UniversityInfo

- (id)copyWithZone:(NSZone *)zone
{
    UniversityInfo *infoCopy = [[[self class] allocWithZone:zone] init];
    
    [infoCopy setUniversityName:[_universityName mutableCopy]];
    [infoCopy setStartYear:[_startYear mutableCopy]];
    [infoCopy setEndYear:[_endYear mutableCopy]];
    [infoCopy setMajor:[_major mutableCopy]];
    
    return infoCopy;
}


/**
 因为学历对象是支持复制的，因此需要遵从<NSCopying>协议并实现copyWithZone:方法。
 而且支持的是深复制，所以在复制NSString的过程中需要使用mutableCopy来实现。
 
 在这里需要注意的是：
 copy方法是NSObject类提供的复制本对象的接口。NSObject类似于Java中的Object类，在Objective-C中几乎所有的对象都继承与它。而且这个copy方法也类似于Object类的clone()方法。
 
 copyWithZone(NSZone zone)方法是接口NSCopying提供的接口。而因为这个接口存在于实现文件而不是头文件，所以它不是对外公开的；即是说外部无法直接调用copyWithZone(NSZone zone)方法。copyWithZone(NSZone zone)方法是在上面所说的copy方法调用后再调用的，作用是将对象的所有数据都进行复制。因此使用者需要在copyWithZone(NSZone zone)方法里做工作，而不是copy方法，这一点和Java的clone方法不同。
 
 */




@end

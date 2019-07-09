//
//  TextCourse.m
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "TextCourse.h"

@implementation TextCourse
-(NSString *)description{
    return [NSString stringWithFormat:@"%@+\n%@:%@\n",[super description],
            NSStringFromSelector(@selector(content)), _content];
}
@end

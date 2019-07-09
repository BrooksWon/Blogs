//
//  LiveCourse.m
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "LiveCourse.h"

@implementation LiveCourse
-(NSString *)description{
    return [NSString stringWithFormat:@"%@+\n%@:%@\n",[super description],
            NSStringFromSelector(@selector(liveUrl)), _liveUrl];
}
@end

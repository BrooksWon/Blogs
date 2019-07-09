//
//  VideoCourse.m
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "VideoCourse.h"

@implementation VideoCourse
-(NSString *)description{
    return [NSString stringWithFormat:@"%@+\n%@:%@\n",[super description],
            NSStringFromSelector(@selector(videoUrl)), _videoUrl];
}
@end

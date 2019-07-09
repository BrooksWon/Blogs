//
//  AudioCourse.m
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "AudioCourse.h"

@implementation AudioCourse
-(NSString *)description{
    return [NSString stringWithFormat:@"%@+\n%@:%@\n",[super description],
            NSStringFromSelector(@selector(audioUrl)), _audioUrl];
}
@end

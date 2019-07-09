//
//  Course.m
//  NO-OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Course.h"

@implementation Course

-(NSString *)description {
    return [NSString stringWithFormat:@"%p\n{\n%@:%@,\n%@:%@,\n%@:%@,\n%@:%@,\n%@:%@,\n%@:%@,\n%@:%@\n}\n",self,
            NSStringFromSelector(@selector(courseTitle)), _courseTitle,
            NSStringFromSelector(@selector(teacherName)), _teacherName,
            NSStringFromSelector(@selector(courseIntroduction)), _courseIntroduction,
            NSStringFromSelector(@selector(content)), _content,
            NSStringFromSelector(@selector(videoUrl)), _videoUrl,
            NSStringFromSelector(@selector(audioUrl)), _audioUrl,
            NSStringFromSelector(@selector(liveUrl)), _liveUrl];
}

@end

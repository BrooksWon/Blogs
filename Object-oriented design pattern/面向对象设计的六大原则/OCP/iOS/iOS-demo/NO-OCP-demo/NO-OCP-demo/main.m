//
//  main.m
//  NO-OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Course.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //1.文字课程
        Course *contentCourse = Course.new;
        
        contentCourse.courseTitle = @"";
        contentCourse.courseIntroduction = @"";
        contentCourse.teacherName = @"";
        
        contentCourse.content = @"八国联军侵略中国，勿忘国耻...";
        
        
        //2.视频课程
        Course *videoCourse = Course.new;
        
        videoCourse.courseTitle = @"";
        videoCourse.courseIntroduction = @"";
        videoCourse.teacherName = @"";
        
        videoCourse.videoUrl = @"videoUrl";
        
        //3.音频课程
        Course *audioCourse = Course.new;
        
        audioCourse.courseTitle =  @"";
        audioCourse.courseIntroduction = @"";
        audioCourse.teacherName = @"";
        
        audioCourse.audioUrl = @"audioUrl";
        
        //4.直播课程
        Course *liveCourse = Course.new;
        
        liveCourse.courseTitle = @"";
        liveCourse.courseIntroduction = @"";
        liveCourse.teacherName = @"";
        
        liveCourse.liveUrl = @"liveUrl";
        
        NSLog(@"\n contentCourse = %@\n videoCourse = %@\n audioCourse = %@\n liveCourse = %@\n\n", contentCourse, videoCourse, audioCourse, liveCourse);
        
    }
    return 0;
}

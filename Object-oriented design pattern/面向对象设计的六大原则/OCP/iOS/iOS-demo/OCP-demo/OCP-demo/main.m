//
//  main.m
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TextCourse.h"
#import "VideoCourse.h"
#import "AudioCourse.h"
#import "LiveCourse.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...

        //1.文字课程
        TextCourse *contentCourse = TextCourse.new;
        
        contentCourse.courseTitle = @"";
        contentCourse.courseIntroduction = @"";
        contentCourse.teacherName = @"";
        
        contentCourse.content = @"八国联军侵略中国，勿忘国耻...";
        
        
        //2.视频课程
        VideoCourse *videoCourse = VideoCourse.new;
        
        videoCourse.courseTitle = @"";
        videoCourse.courseIntroduction = @"";
        videoCourse.teacherName = @"";
        
        videoCourse.videoUrl = @"videoUrl";
        
        //3.音频课程
        AudioCourse *audioCourse = AudioCourse.new;
        
        audioCourse.courseTitle =  @"";
        audioCourse.courseIntroduction = @"";
        audioCourse.teacherName = @"";
        
        audioCourse.audioUrl = @"audioUrl";
        
        //4.直播课程
        LiveCourse *liveCourse = LiveCourse.new;
        
        liveCourse.courseTitle = @"";
        liveCourse.courseIntroduction = @"";
        liveCourse.teacherName = @"";
        
        liveCourse.liveUrl = @"liveUrl";
        
        NSLog(@"\n contentCourse = %@\n videoCourse = %@\n audioCourse = %@\n liveCourse = %@\n\n", contentCourse, videoCourse, audioCourse, liveCourse);
        
    }
    return 0;
}

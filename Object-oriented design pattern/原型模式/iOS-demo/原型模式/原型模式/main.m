//
//  main.m
//  原型模式
//
//  Created by Brooks on 2019/5/17.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Resume.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //resume for LiLei
        Resume *resume = [[Resume alloc] init];
        resume.name = @"LiLei";
        resume.gender = @"male";
        resume.age = @"24";
        
        UniversityInfo *info = [[UniversityInfo alloc] init];
        info.universityName = @"X";
        info.startYear = @"2014";
        info.endYear = @"2018";
        info.major = @"CS";
        
        resume.universityInfo = info;
        
        
        //resume_copy for HanMeiMei
        Resume *resume_copy = [resume copy];
        
        NSLog(@"\n\n\n======== original resume ======== %@\n\n\n======== copy resume ======== %@",resume,resume_copy);
        
        resume_copy.name = @"HanMeiMei";
        resume_copy.gender = @"female";
        resume_copy.universityInfo.major = @"TeleCommunication";
        
        NSLog(@"\n\n\n======== original resume ======== %@\n\n\n======== revised copy resume ======== %@",resume,resume_copy);
        
        /**
         
         注：还可以用序列化和反序列化的办法来实现深复制
         
         */
    }
    return 0;
}

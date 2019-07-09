//
//  AudioCourse.h
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioCourse : Course
@property (nonatomic, copy) NSString *audioUrl;            //音频地址
@end

NS_ASSUME_NONNULL_END

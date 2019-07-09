//
//  TextCourse.h
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextCourse : Course
@property (nonatomic, copy) NSString *content;             //文字内容
@end

NS_ASSUME_NONNULL_END

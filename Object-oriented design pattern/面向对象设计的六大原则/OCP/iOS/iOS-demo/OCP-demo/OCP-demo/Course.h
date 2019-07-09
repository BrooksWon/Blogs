//
//  Course.h
//  OCP-demo
//
//  Created by Brooks on 2019/5/8.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Course : NSObject

@property (nonatomic, copy) NSString *courseTitle;         //课程名称
@property (nonatomic, copy) NSString *courseIntroduction;  //课程介绍
@property (nonatomic, copy) NSString *teacherName;         //讲师姓名

@end

NS_ASSUME_NONNULL_END



/**
 这样一来，上面的两个问题都得到了解决：
 
 随着课程类型的增加，不需要反复修改最初的父类（Course），只需要新建一个继承于它的子类并在子类中添加仅属于该子类的数据（或行为）即可。
 因为各种课程独有的数据（或行为）都被分散到了不同的课程子类里，所以每个子类的数据（或行为）没有任何冗余。
 
 而且对于第二点：或许今后的视频课程可以有高清地址，视频加速功能。而这些功能只需要在VideoCourse类里添加即可，因为它们都是视频课程所独有的。同样地，直播课程后面还可以支持在线问答功能，也可以仅加在LiveCourse里面。
 我们可以看到，正是由于最初程序设计合理，所以对后面需求的增加才会处理得很好。
 
 下面来看一下这两个设计的UML 类图，可以更形象地看出两种设计上的区别：
 
 */

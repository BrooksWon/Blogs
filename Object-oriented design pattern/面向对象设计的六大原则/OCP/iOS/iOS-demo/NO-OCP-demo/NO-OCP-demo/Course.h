//
//  Course.h
//  NO-OCP-demo
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
@property (nonatomic, copy) NSString *content;             //文字内容


//新需求：视频课程
@property (nonatomic, copy) NSString *videoUrl;

//新需求：音频课程
@property (nonatomic, copy) NSString *audioUrl;

//新需求：直播课程
@property (nonatomic, copy) NSString *liveUrl;

@end

NS_ASSUME_NONNULL_END


/**
 
 三种新增的课程都在原Course类中添加了对应的url。也就是每次添加一个新的类型的课程，都在原有Course类里面修改：新增这种课程需要的数据。
 这就导致：我们从Course类实例化的视频课程对象会包含并不属于自己的数据：audioUrl和liveUrl：这样就造成了冗余，视频课程对象并不是纯粹的视频课程对象，它包含了音频地址，直播地址等成员。
 很显然，这个设计不是一个好的设计，因为（对应上面两段叙述）：
 
 随着需求的增加，需要反复修改之前创建的类。
 给新增的类造成了不必要的冗余。
 
 之所以会造成上述两个缺陷，是因为该设计没有遵循对修改关闭，对扩展开放的开闭原则，而是反其道而行之：开放修改，而且不给扩展提供便利。
 难么怎么做可以遵循开闭原则呢？下面看一下遵循开闭原则的较好的设计：
 
 */

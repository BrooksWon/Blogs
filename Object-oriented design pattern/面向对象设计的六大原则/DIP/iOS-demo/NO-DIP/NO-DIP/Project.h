//
//  Project.h
//  NO-DIP
//
//  Created by Brooks on 2019/5/10.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Project : NSObject

//构造方法，传入开发者的数组
- (instancetype)initWithDevelopers:(NSArray *)developers;

//开始开发
- (void)startDeveloping;

@end


NS_ASSUME_NONNULL_END

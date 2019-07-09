//
//  Observer.h
//  观察者模式
//
//  Created by Brooks on 2019/6/5.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Observer : NSObject
{
    @protected Subject *_subject;
}

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithSubject:(Subject *)subject NS_DESIGNATED_INITIALIZER;

- (void)update;

@end

NS_ASSUME_NONNULL_END

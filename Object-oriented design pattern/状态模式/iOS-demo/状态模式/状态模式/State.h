//
//  State.h
//  状态模式
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Coder.h"
#import "ActionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface State : NSObject <ActionProtocol>
{
    @protected Coder *_coder;
}

- (instancetype)initWithCoder:(Coder *)coder NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END

//
//  RemoteControl.h
//  命令模式2
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommondExcuteProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteControl : NSObject
@property (nonatomic, weak) id <CommondExcuteProtocol> delegate;

- (void)pressButton;

@end

NS_ASSUME_NONNULL_END

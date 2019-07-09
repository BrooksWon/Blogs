//
//  CommandLightOn.h
//  命令模式2
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LightCommondsProtocol.h"
#import "CommondExcuteProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommandLightOn : NSObject <CommondExcuteProtocol>
@property (nonatomic, weak) id <LightCommondsProtocol> delegate;

- (instancetype)initWithLightCommondsObj:(id <LightCommondsProtocol>)obj NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END

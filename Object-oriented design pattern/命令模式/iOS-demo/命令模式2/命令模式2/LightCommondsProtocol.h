//
//  LightCommondsProtocol.h
//  命令模式2
//
//  Created by Brooks on 2019/6/4.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LightCommondsProtocol <NSObject>

@optional
- (void)lightOn;
- (void)lightOff;



@end

NS_ASSUME_NONNULL_END

//
//  HomeDevice.h
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//设备基类

@interface HomeDevice : NSObject

//连接电源
- (void)on;

//关闭电源
- (void)off;

@end

NS_ASSUME_NONNULL_END

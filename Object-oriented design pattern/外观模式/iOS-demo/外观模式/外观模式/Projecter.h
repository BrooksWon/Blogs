//
//  Projecter.h
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HomeDevice.h"

@class DVDPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface Projecter : HomeDevice

//与DVD Player连接
- (void)connetDVDPlayer:(DVDPlayer *)dvdPlayer;

//与DVD Player断开连接
- (void)disconnetDVDPlayer:(DVDPlayer *)dvdPlayer;

@end

NS_ASSUME_NONNULL_END

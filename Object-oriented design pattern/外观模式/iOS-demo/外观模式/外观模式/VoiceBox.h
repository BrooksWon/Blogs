//
//  VoiceBox.h
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "HomeDevice.h"

@class CDPlayer;
@class DVDPlayer;


NS_ASSUME_NONNULL_BEGIN

@interface VoiceBox : HomeDevice

//与CDPlayer连接
- (void)connetCDPlayer:(CDPlayer *)cdPlayer;

//与CDPlayer断开连接
- (void)disconnetCDPlayer:(CDPlayer *)cdPlayer;

//与DVD Player连接
- (void)connetDVDPlayer:(DVDPlayer *)dvdPlayer;

//与DVD Player断开连接
- (void)disconnetDVDPlayer:(DVDPlayer *)dvdPlayer;

@end

NS_ASSUME_NONNULL_END

//
//  HomeDeviceManager.h
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDeviceManager : NSObject

//===== 关于空调的接口 =====

//空调吹冷风
- (void)coolWind;

//空调吹热风
- (void)warmWind;


//===== 关于CD Player的接口 =====

//播放CD
- (void)playMusic;

//关掉音乐
- (void)offMusic;


//===== 关于DVD Player的接口 =====

//播放DVD
- (void)playMovie;

//关闭DVD
- (void)offMoive;


//===== 关于总开关的接口 =====

//打开全部家用电器
- (void)allDeviceOn;

//关闭所有家用电器
- (void)allDeviceOff;


@end

NS_ASSUME_NONNULL_END

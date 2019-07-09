//
//  VoiceBox.m
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "VoiceBox.h"

@implementation VoiceBox
- (void)connetCDPlayer:(CDPlayer *)cdPlayer{
    
    NSLog(@"%@ has connected CDPlayer",[self class]);
}

- (void)disconnetCDPlayer:(CDPlayer *)cdPlayer{
    
    NSLog(@"%@ has disconnected CDPlayer",[self class]);
}

- (void)connetDVDPlayer:(DVDPlayer *)dvdPlayer{
    
    NSLog(@"%@ has connected DVDPlayer",[self class]);
}

- (void)disconnetDVDPlayer:(DVDPlayer *)dvdPlayer{
    
    NSLog(@"%@ has disconnected DVDPlayer",[self class]);
}

@end

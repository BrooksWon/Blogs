//
//  Projecter.m
//  外观模式
//
//  Created by Brooks on 2019/5/23.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Projecter.h"

@implementation Projecter
- (void)connetDVDPlayer:(DVDPlayer *)dvdPlayer{
    
    NSLog(@"%@ has connected DVDPlayer",[self class]);
}


- (void)disconnetDVDPlayer:(DVDPlayer *)dvdPlayer{
    
    NSLog(@"%@ has disconnected DVDPlayer",[self class]);
}
@end

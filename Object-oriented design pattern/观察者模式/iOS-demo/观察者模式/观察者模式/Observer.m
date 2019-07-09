
//
//  Observer.m
//  观察者模式
//
//  Created by Brooks on 2019/6/5.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Observer.h"

@implementation Observer
-(instancetype)initWithSubject:(Subject *)subject{
    
    self = [super init];
    if (self) {
        _subject = subject;
        [_subject addObserver:self];
    }
    return self;
}

- (void)update{
    
    NSLog(@"implementation by subclasses");
}

@end

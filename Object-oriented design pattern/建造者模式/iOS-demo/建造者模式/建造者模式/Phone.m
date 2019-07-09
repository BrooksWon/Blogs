
//
//  Phone.m
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Phone.h"

@implementation Phone

- (NSString *)description {
    return [NSString stringWithFormat:@"%p\n{\n%@:%@,\n%@:%@,\n%@:%@,\n%@:%@\n}\n",self,
            NSStringFromSelector(@selector(cpu)), _cpu,
            NSStringFromSelector(@selector(capacity)), _capacity,
            NSStringFromSelector(@selector(display)), _display,
            NSStringFromSelector(@selector(camera)), _camera];
}

@end

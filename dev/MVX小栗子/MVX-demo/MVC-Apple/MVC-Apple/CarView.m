//
//  CarView.m
//  MVC-Apple
//
//  Created by Brooks on 2019/11/21.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CarView.h"

@implementation CarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _logoView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 200, 150)];
        _nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 150, 200, 50)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_logoView];
        [self addSubview:_nameLabel];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(carViewDidClick:)]) {
        [self.delegate carViewDidClick:self];
    }
}


@end

//
//  CarView.m
//  MVC-Apple
//
//  Created by Brooks on 2019/11/21.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CarView.h"
#import "CarModel.h"
#import "KVOController/NSObject+FBKVOController.h"

@interface CarView ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

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

- (void)setViewModel:(CarViewViewModel *)viewModel
{
    _viewModel = viewModel;
    
    /*
     数据绑定有很多方案可选：
     1.原生KVO；
     2.KVOController；
     3.RAC
     4....
     大家选择合适自己团队的就👌
     */
    
     //使用KVO监听ViewModel的变化
    __weak typeof(self) weakSelf = self;
    [self.KVOController observe:self.viewModel
                        keyPath:@"logoUrl"
                        options:NSKeyValueObservingOptionNew
                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        //取出变化值，改变View的数据显示
        NSString *imageUrlString = change[NSKeyValueChangeNewKey];
        weakSelf.logoView.image = [UIImage imageNamed:imageUrlString];
    }];
    [self.KVOController  observe:self.viewModel
                         keyPath:@"name"
                         options:NSKeyValueObservingOptionNew
                           block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        //取出变化值，改变View的数据显示
        weakSelf.nameLabel.text = change[NSKeyValueChangeNewKey];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(carViewDidClick:)]) {
        [self.delegate carViewDidClick:self];
    }
}

@end

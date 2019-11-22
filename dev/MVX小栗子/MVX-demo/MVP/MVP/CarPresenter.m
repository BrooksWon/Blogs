//
//  CarPresenter.m
//  MVP
//
//  Created by Brooks on 2019/11/22.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CarPresenter.h"
#import "CarModel.h"
#import "CarView.h"

@interface CarPresenter ()<CarViewDelegate>//遵循协议

@property (nonatomic, weak) UIViewController *viewController;//弱引用VC

@end

@implementation CarPresenter

- (instancetype)initWithController:(UIViewController *)viewController
{
    if (self = [super init]) {
        _viewController = viewController;
        
        //创建View
        CarView *carView = [[CarView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        carView.center = _viewController.view.center;
        carView.delegate = self;
        [_viewController.view addSubview:carView];
        
        //加载模型数据
        CarModel *model = [[CarModel alloc] init];
        
        //将Model传递给View的填充数据方法
        [carView fillData:model];
        
    }
    return self;
}

#pragma mark - CarViewDelegate
- (void)carViewDidClick:(CarView *)appView
{
    NSLog(@"presenter 监听了 CarView 的点击");
}

@end

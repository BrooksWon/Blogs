//
//  CarViewViewModel.m
//  MVVM
//
//  Created by Brooks on 2019/11/22.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "CarViewViewModel.h"
#import "CarView.h"
#import "CarModel.h"

@interface CarViewViewModel ()<CarViewDelegate>//遵循协议
@property (nonatomic, weak) UIViewController *viewController;//弱引用VC

@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *name;

@end

@implementation CarViewViewModel

- (instancetype)initWithController:(UIViewController *)viewController
{
    if (self = [super init]) {
        _viewController = viewController;
        
        //创建View
        CarView *carView = [[CarView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        carView.center = _viewController.view.center;
        carView.delegate = self;
        //将ViewModel传递给View
        carView.viewModel = self;
        [_viewController.view addSubview:carView];
        
        //加载模型数据
        CarModel *model = [[CarModel alloc] init];
        //将Model赋值给ViewModel
        self.logoUrl = model.logoUrl;
        self.name = model.name;
    }
    return self;
}


#pragma mark - CarViewDelegate
- (void)carViewDidClick:(CarView *)appView
{
    NSLog(@"viewModel 监听了 CarView 的点击");
        
    //加载模型数据
    CarModel *model = [[CarModel alloc] init];
    model.name = @"宝马";
    model.logoUrl = @"bmw";
    
    //将Model赋值给ViewModel
    self.logoUrl = model.logoUrl;
    self.name = model.name;
}


@end

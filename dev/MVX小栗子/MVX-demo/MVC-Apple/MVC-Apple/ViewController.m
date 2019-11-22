//
//  ViewController.m
//  MVC-Apple
//
//  Created by Brooks on 2019/11/21.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController.h"

#import "CarView.h"
#import "CarModel.h"

@interface ViewController ()<CarViewDelegate>//遵守协议

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建View
    CarView *carView = [[CarView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    carView.center = self.view.center;
    carView.delegate = self;
    [self.view addSubview:carView];
    
    //加载模型数据
    CarModel *model = [[CarModel alloc] init];
    
    //使用Model为View的控件填充数据
    carView.logoView.image = [UIImage imageNamed:model.logoUrl];
    carView.nameLabel.text = model.name;
}

#pragma mark - CarViewDelegate
- (void)carViewDidClick:(CarView *)appView
{
    NSLog(@"ViewController 监听了 CarView 的点击");
}

@end

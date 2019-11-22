//
//  ViewController.m
//  MVVM
//
//  Created by Brooks on 2019/11/22.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController.h"
#import "CarViewViewModel.h"

@interface ViewController ()

@property (nonatomic, strong) CarViewViewModel *carViewModel;//强引用ViewModel

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建ViewModel，将任务交给它处理
    self.carViewModel = [[CarViewViewModel alloc] initWithController:self];
}


@end

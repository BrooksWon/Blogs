//
//  ViewController.m
//  MVP
//
//  Created by Brooks on 2019/11/22.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController.h"
#import "CarPresenter.h"

@interface ViewController ()

@property (nonatomic, strong) CarPresenter *carPresenter;//强引用Presenter

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建Presenter，将任务交给它处理
    self.carPresenter = [[CarPresenter alloc] initWithController:self];
}


@end

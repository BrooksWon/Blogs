//
//  CarView.h
//  MVC-Apple
//
//  Created by Brooks on 2019/11/21.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarViewViewModel.h"

@class CarModel;
@class CarView;

@protocol CarViewDelegate <NSObject>
@optional
- (void)carViewDidClick:(CarView *)appView;
@end

@interface CarView : UIView

@property (nonatomic, weak) CarViewViewModel *viewModel;//在MVVM中，View需要弱引用ViewModel
@property (nonatomic, weak) id<CarViewDelegate> delegate;

@end


//
//  CarView.h
//  MVC-Apple
//
//  Created by Brooks on 2019/11/21.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarModel;
@class CarView;

@protocol CarViewDelegate <NSObject>
@optional
- (void)carViewDidClick:(CarView *)appView;
@end

@interface CarView : UIView
@property (nonatomic, weak) id<CarViewDelegate> delegate;

- (void)fillData:(CarModel*)model;

@end


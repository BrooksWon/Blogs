//
//  SauceDecorator.h
//  装饰者模式
//
//  Created by Brooks on 2019/5/28.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Salad.h"

NS_ASSUME_NONNULL_BEGIN

@interface SauceDecorator : Salad

@property (nonatomic, strong) Salad *salad;

- (instancetype)initWithSalad:(Salad *)salad;

@end

NS_ASSUME_NONNULL_END

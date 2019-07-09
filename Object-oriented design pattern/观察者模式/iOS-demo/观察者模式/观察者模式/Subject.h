//
//  Subject.h
//  观察者模式
//
//  Created by Brooks on 2019/6/5.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Observer;

NS_ASSUME_NONNULL_BEGIN

@interface Subject : NSObject
{
    @protected float _buyingPrice;
//    @protected NSMutableArray <Observer *>*_observers;
    @protected NSHashTable <Observer *>*_observers;
}

- (void)addObserver:(Observer *) observer;


- (void)removeObserver:(Observer *) observer;


- (void)notifyObservers;


- (void)setBuyingPrice:(float)price;


- (double)getBuyingPrice;


@end

NS_ASSUME_NONNULL_END

//
//  Subject.m
//  观察者模式
//
//  Created by Brooks on 2019/6/5.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "Subject.h"
#import "Observer.h"

@implementation Subject
- (instancetype)init{
    
    self = [super init];
    if (self) {
//        _observers = [NSMutableArray array];
        _observers = [NSHashTable hashTableWithOptions:NSPointerFunctionsWeakMemory];
    }
    return self;
}


- (void)addObserver:( Observer * ) observer{
    
    [_observers addObject:observer];
}


- (void)removeObserver:( Observer *) observer{
    
    [_observers removeObject:observer];
}


- (void)notifyObservers{
    
//    [_observers enumerateObjectsUsingBlock:^(Observer *  _Nonnull observer, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        [observer update];
//    }];
    
    [_observers.objectEnumerator.allObjects makeObjectsPerformSelector:@selector(update)];
}


- (void)setBuyingPrice:(float)price{
    
    _buyingPrice = price;
    
    [self notifyObservers];
}


- (double)getBuyingPrice{
    
    return _buyingPrice;
}

@end

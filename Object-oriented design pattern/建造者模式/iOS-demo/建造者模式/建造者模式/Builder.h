//
//  Builder.h
//  建造者模式
//
//  Created by Brooks on 2019/5/16.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Phone.h"

NS_ASSUME_NONNULL_BEGIN

@interface Builder : NSObject
{
@protected Phone *_phone;
}

- (void)createPhone;

- (void)buildCPU;
- (void)buildCapacity;
- (void)buildDisplay;
- (void)buildCamera;


- (Phone *)obtainPhone;

@end

NS_ASSUME_NONNULL_END

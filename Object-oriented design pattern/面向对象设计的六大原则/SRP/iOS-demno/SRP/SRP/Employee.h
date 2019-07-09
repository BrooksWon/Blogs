//
//  Employee.h
//  SRP
//
//  Created by Brooks on 2019/5/9.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Employee : NSObject

//============ 初始需求 ============
@property (nonatomic, copy) NSString *name;       //员工姓名
@property (nonatomic, copy) NSString *address;    //员工住址
@property (nonatomic, copy) NSString *employeeID; //员工ID


@end

NS_ASSUME_NONNULL_END


/**
 
 通过创建了两个分别专门处理薪水和晋升的部门，会计部门和人事部门的类：FinancialApartment 和 HRApartment，把两个任务（责任）分离了出去，让本该处理这些职责的类来处理这些职责。
 这样一来，不仅仅在此次新需求中满足了单一职责原则，以后如果还要增加人事部门和会计部门处理的任务，就可以直接在这两个类里面添加即可。
 
 下面来看一下这两个设计的UML 类图，可以更形象地看出两种设计上的区别：
 
 */

//
//  Employee.h
//  NO-SRP
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



//============ 新需求 ============
//计算薪水
- (double)calculateSalary;

//今年是否晋升
- (BOOL)willGetPromotionThisYear;


@end

NS_ASSUME_NONNULL_END


/**
 
 
 由上面的代码可以看出：
 
 在初始需求下，我们创建了Employee这个员工类，并声明了3个员工信息的属性：员工姓名，地址，员工ID。
 在新需求下，两个方法直接加到了员工类里面。
 
 新需求的做法看似没有问题，因为都是和员工有关的，但却违反了单一职责原则：因为这两个方法并不是员工本身的职责。
 
 calculateSalary这个方法的职责是属于会计部门的：薪水的计算是会计部门负责。
 willPromotionThisYear这个方法的职责是属于人事部门的：考核与晋升机制是人事部门负责。
 
 而上面的设计将本来不属于员工自己的职责强加进了员工类里面，而这个类的设计初衷（原始职责）就是单纯地保留员工的一些信息而已。因此这么做就是给这个类引入了新的职责，故此设计违反了单一职责原则。
 我们可以简单想象一下这么做的后果是什么：如果员工的晋升机制变了，或者税收政策等影响员工工资的因素变了，我们还需要修改当前这个类。
 那么怎么做才能不违反单一职责原则呢？- 我们需要将这两个方法（责任）分离出去，让本应该处理这类任务的类来处理。
 
 
 */

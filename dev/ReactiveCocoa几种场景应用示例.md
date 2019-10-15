# ReactiveCocoa几种场景应用示例

## 1. taget - action

```objective-c
//button
UIButton *btn = [[UIButton alloc] initWithFrame:self.view.bounds];
   [self.view addSubview:btn];
[[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    NSLog(@"%@ 按钮被点击了", x);
}];
    
//手势
self.view.userInteractionEnabled = YES;
UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
[tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * tap) {
    NSLog(@"*****  响应单击手势  *****");
}];
[tap rac_gestureSignal];
[self.view addGestureRecognizer:tap];
```

## 2. KVO

```objective-c
@interface ViewController () 
@property(nonatomic,copy)NSString *textString;
@end

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self, textString) subscribeNext: 		    ^(NSString *newString){
        NSLog(@"newString = %@", newString);
    }];
    self.textString = @"test2";
}
```

## 3. delegate代理

```
@interface ViewController () <UITextFieldDelegate>
@end
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:textField];
    textField.delegate = self;

    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@", x);
    }];
}    
```

## 4. Notification通知

```objective-c
[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
    NSLog(@"%@", x);
}];
```

## 5. 定时器timer

```objective-c
//主线程每 3 秒执行一次
    [[RACSignal interval:3.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"主线程 %@", x);
    }];
    
//创建一个子线程，每 3 秒执行一次
    [[RACSignal interval:3.0 onScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground]] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"子线程 %@", x);
    }];
```

## 6. 数组与字典,遍历元素

```objective-c
    NSArray *racArray = @[@"rac1", @"rac2", @"rac3"];
    [racArray.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"数组元素 %@", x);
    }];
    
    NSDictionary *racDictionary = @{@"zhangsan":@21, @"lisi":@22, @"wangwu":@23};
    [racDictionary.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTuple *tuple = (RACTuple*)x;
        NSLog(@"字典元素-%@：%@", tuple[0], tuple[1]);
    }];
```

## 7. RAC基本使用方法与流程

```objective-c
    //1. 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //3.1 发送信号
        [subscriber sendNext:@"发送信号"];
        
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:101 userInfo:@{@"errorMsg":@"test errorMsg"}];
        //3.1 发送 error 信号
        [subscriber sendNext:error];
        
        //3.1 发送信号已完成
        [subscriber sendCompleted];
        
        //4. 销毁信号
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号已经销毁");
        }];
    }];
    
    //2. 订阅信号 (信号一旦被订阅，就启动了信号发送流程)
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"信号过来了 【%@】", x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error 信号过来了 【%@】", error);
    } completed:^{
        NSLog(@"信号接收处理完毕");
    }];
```

## 8. 多个请求都至少完成一次 然后出发一个总方法

```objective-c
{
    //8. 多个请求都至少完成一次 然后出发一个总方法
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            // 发送请求1
            [subscriber sendNext:@"发送请求1"];
            return nil;
        }];
        
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    RACSignal *request3 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求3
        [subscriber sendNext:@"发送请求3"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(totalFuctonR1:R2:R3:) withSignalsFromArray:@[request1,request2,request3]];
}    

-(void)totalFuctonR1:(id)data1 R2:(id)data2 R3:(id)data3{
    NSLog(@"总方法触发:data1 = %@    -----  data2 = %@    -----  data3 = %@",data1,data2,data3);
}
```

## 9. 将多个不同类型的数据组合成一个元组

```objective-c
    // 把参数中的数据包装成元组
    RACTuple *tuple = RACTuplePack(@"xmg",@20,@"m",@(999),@[@"a"],@{@"key":@"value"});
    
    RACTupleUnpack(NSString *name,NSNumber *age,NSString *sex,NSNumber *price,NSArray *arr,NSDictionary *dic) = tuple;
    NSLog(@"name:%@  age:%@  sex:%@  price:%@ arr:%@  dic:%@",name,age,sex,price,arr,dic);
```

## 10. 使用 #define RAC(TARGET, ...)宏 (通过这个可以将_label的text属性和后面的信号绑定信号内容发生改变的时候自动更新)

```objective-c
RAC(_label,text) = self.textField.rac_textSignal;
```

## 11. RACSignal 的 zipWith、concat、bind 操作

```objective-c
        RACSignal *signal = [RACSignal createSignal:
                             ^RACDisposable *(id<RACSubscriber> subscriber)
        {
            [subscriber sendNext:@1];
            [subscriber sendNext:@2];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"signal dispose 数字");
            }];
        }];


        RACSignal *signals = [RACSignal createSignal:
                             ^RACDisposable *(id<RACSubscriber> subscriber)
        {
            [subscriber sendNext:@"A"];
            [subscriber sendNext:@"B"];
            [subscriber sendNext:@"C"];
            [subscriber sendCompleted];
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"signal dispose 字母");
            }];
        }];
        
        //concat操作就是把两个信号合并起来。注意合并有先后顺序。
        /*
         1.这里有二点需要注意的是：只有当第一个信号完成之后才能收到第二个信号的值，因为第二个信号是在第一个信号completed的闭包里面订阅的，所以第一个信号不结束，第二个信号也不会被订阅。
         2.两个信号concat在一起之后，新的信号的结束信号在第二个信号结束的时候才结束。看上图描述，新的信号的发送长度等于前面两个信号长度之和，concat之后的新信号的结束信号也就是第二个信号的结束信号。
         
         concat是有序的组合，第一个信号完成之后才发送第二个信号。
         */
        RACSignal *concatSignal = [signal concat:signals];
        [concatSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"concatSignal subscribe value = %@", x);
        } completed:^{
            NSLog(@"concatSignal 完成");
        }];
        
        
    //当把两个信号通过zipWith之后，就像上面的那张图一样，拉链的两边被中间的拉索拉到了一起。既然是拉链，那么一一的位置是有对应的，上面的拉链第一个位置只能对着下面拉链第一个位置，这样拉链才能拉到一起去。
        RACSignal *zipSignal = [signal zipWith:signals];
        [zipSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"zipSignal subscribe value = %@", x);

        } completed:^{
            NSLog(@"zipSignal 完成");
        }];
        
        //为当前信号延迟绑定一个block。 Lazily binds a block to the values in the receiver.
        RACSignal *bindSignal = [signal bind:^RACSignalBindBlock _Nonnull{
            return ^RACSignal *(NSNumber *value, BOOL *stop){
                value = @(value.intValue * 2);
                return [RACSignal return:value];
            };
        }];
        [bindSignal subscribeNext:^(id  _Nullable x) {
            NSLog(@"bindSignal subscribe value = %@", x);
        } completed:^{
            NSLog(@"bindSignal 完成");
        }];
```



## 12. 登录界面的一些信号和响应

![login](/Users/Brooks/blog/blogs/dev/login.png)

```objective-c
#import <ReactiveObjC.h>

@interface ViewController () 
@property (weak, nonatomic) IBOutlet UITextField *firstTextfield;
@property (weak, nonatomic) IBOutlet UITextField *secondTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //11. 登录界面的一些信号和响应
    
    //将 textfield 输入信号的 返回值进行修改  得到新的信号！
    RACSignal *firstSignal = [self.firstTextfield.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        if (value.length >= 5 && value.length <= 10) {//账号长度限制
            return @(YES);
        }
        return @(NO);
    }];
    
    RACSignal *secondSignal = [self.secondTextfield.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        if (value.length >= 6 && value.length <= 50) {//密码长度限制
            return @(YES);
        }
        return @(NO);
    }];
    
    // 绑定用户名、密码判断结果的2个信号量，如果都为真，则按钮可用
    RAC(self.loginButton,enabled) = [RACSignal combineLatest:@[firstSignal,secondSignal] reduce:^id(NSNumber *firstRes,NSNumber *secondRes){
        return @(firstRes.boolValue && secondRes.boolValue);
    }];
}

@end
```



参考链接：https://www.jianshu.com/p/d7d951a99db8
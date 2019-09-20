# 「Auto Layout」tips

## Auto Layout 的生命周期

```
针对Auto Layout的生命周期，我是这么理解的：
Auto Layout拥有一套Layout Engine引擎，由它来主导页面的布局。App启动后，主线程的Run Loop会一直处于监听状态，当约束发生变化后会触发Deffered Layout Pass（延迟布局传递），在里面做容错处理（约束丢失等情况）并把view标识为dirty状态，然后Run Loop再次进入监听阶段。当下一次刷新屏幕动作来临（或者是调用layoutIfNeeded）时，Layout Engine 会从上到下调用 layoutSubviews() ，通过 Cassowary算法计算各个子视图的位置，算出来后将子视图的frame从Layout Engine拷贝出来，接下来的过程就跟手写frame是一样的了。
```

## 关于 UI 的布局，是使用 frame 还是 Auto Layout ？

```
关于 UI 的布局，是使用 frame 还是 Auto Layout ？这个问题困扰了我很久，在之前的团队中是建议使用 frame 的，原因是在 layoutSubviews 中做布局，将所有的子视图按照 UI 显示从上至下、从左至右的顺序来布局，感觉也很规范，代码也不会导致不易维护的程度。
我一直有这么一条原则：简单的 UI 使用 Auto Layout ，复杂的 UI 使用 frame。原因如下：
1、从代码量上来看，两种布局方式相差不大。有时候发现复杂的 UI 使用 Auto Layout 的话，代码量反而会变多，因为复杂的 UI 往往会有复杂的逻辑，比如根据数据的不同，部分 UI 的显示会有变动（比如某个子视图隐藏与显示， 会影响到其它视图的布局）。
2、会将那种仅做了一次约束之后，就可以不用做太多 update 的那种视为简单的布局，这种情况下使用 Auto Layout 还是挺方便的。
3、会将 Cell 的高度会随着数据的不同而不同的布局视为复杂的 UI 布局，这种情况下使用 Auto Layout 来布局，感觉就不合适。因为不管是 frame 还是 Auto Layout，都需要去计算高度，其实在计算 高度的时候，所有的子视图的 frame 都已经决定了，这种情况下，直接使用 frame 会比较精简。
4、我见过这样的代码：动态的通过文本，计算出尺寸之后，再使用 Auto Layout 进行 update，感觉太没有这个必要了。
```

## 使用了Auto Layout之后，在哪个时间下能够拿到响应的frame和center？另外自动布局怎么做动画？

```objective-c
1）Layout Engine 会从上到下调用 layoutSubviews() ，可以在该方法内拿到frame信息。

2）动画的话。因为布局约束就是要脱离frame这种表达方式的，可是动画是需要根据这个来执行，这里面就会有些矛盾，不过根据前面说到的布局约束的原理，在某个时刻约束也是会被还原成frame使视图显示，这个时刻可以通过layoutIfNeeded这个方法来进行控制。具体代码如下

[aniView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.bottom.left.right.equalTo(self.view).offset(10);
}];

[aniView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(30);
}];

[UIView animateWithDuration:3 animations:^{
    [self.view layoutIfNeeded];
}];
```

## cell 里面 label的高度自适应问题

```
具体使用，可以看我这篇文章，里面涉及到
https://github.com/ming1016/study/wiki/Masonry

我把相关内容截取到这里

主要是UILabel的高度会有变化，所以这里主要是说说label变化时如何处理，设置UILabel的时候注意要设置preferredMaxLayoutWidth这个宽度，还有ContentHuggingPriority为UILayoutPriorityRequried

CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 10 * 2;

textLabel = [UILabel new];
textLabel.numberOfLines = 0;
textLabel.preferredMaxLayoutWidth = maxWidth;
[self.contentView addSubview:textLabel];

[textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(statusView.mas_bottom).with.offset(10);
    make.left.equalTo(self.contentView).with.offset(10);
    make.right.equalTo(self.contentView).with.offset(-10);
    make.bottom.equalTo(self.contentView).with.offset(-10);
}];

[_contentLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

如果版本支持最低版本为iOS 8以上的话可以直接利用UITableViewAutomaticDimension在tableview的heightForRowAtIndexPath直接返回即可。

tableView.rowHeight = UITableViewAutomaticDimension;
tableView.estimatedRowHeight = 80; //减少第一次计算量，iOS7后支持

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 只用返回这个！
    return UITableViewAutomaticDimension;
}

但如果需要兼容iOS 8之前版本的话，就要回到老路子上了，主要是用systemLayoutSizeFittingSize来取高。步骤是先在数据model中添加一个height的属性用来缓存高，然后在table view的heightForRowAtIndexPath代理里static一个只初始化一次的Cell实例，然后根据model内容填充数据，最后根据cell的contentView的systemLayoutSizeFittingSize的方法获取到cell的高。具体代码如下

//在model中添加属性缓存高度
@interface DataModel : NSObject
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) CGFloat cellHeight; //缓存高度
@end

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CustomCell *cell;
    //只初始化一次cell
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomCell class])];
  

还有这篇 https://ming1016.github.io/2015/11/03/deeply-analyse-autolayout/ 会讲的更详细些
```

## 有时候cell里面的一些 label 会在不同情况下切换显示和隐藏，这时 label 的上下间距，会出现异常，比如：竖着排列3个 label: a-b-c，间距都是20，这时 b 隐藏，c 和 a 的间距是20，设计要求是10，这种怎么处理？

```
layoutsubview 里可以得到 frame 然后判断进行hidden处理
```

## 比较几种不同计算cell高度性能的问题

```
从好到坏：手动frame+计算高度，AutoLayout+计算高度，AutoLayout+自动计算。

建议：
cell 情况复杂时用手动frame+计算高度，简单的用AutoLayout+自动计算
```

## 使用xib布局性能怎么样？

```
xib 的自动布局和手写的自动布局是一样的，xib 只是 GUI 化了。
```


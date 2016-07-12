# PLSegmentView
多段筛选
* 集成简单，只需要一个`.h`和 `.m` 文件即可
* 使用方法 `setSegmentsData:` 自适应文字的长度。 `setSegmentsData:fixWidth:` 可以自定义文字宽度
* 可以自定义title格式，和文字样式
* `showSeparatorLine` 可以显示title与title之间的分割线
* 和一个scrollView进行连动 在UIScrollViewDelegate中方法`scrollViewDidEndDecelerating:`中回调`pl_scrollViewDidEndDecelerating:`

![动态图片效果](https://github.com/loupman/PLSegmentView/blob/master/result0.gif)

//
//  YYSegmentView.h
//  YunYinDesign
//
//  Created by PhilipLee on 15/12/10.
//  Copyright © 2015年 PhilipLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLSegmentView : UIView
{
    UIScrollView *_bgScrollView;
    NSInteger _count;
}

/**
 *  subline color on bottom of title.
 */
@property (strong, nonatomic) UIColor *bottomLineColor;

/**
 *  title font  default is font12
 */
@property (strong, nonatomic) UIFont *titleFont;

/**
 *  current selected title color. default is darkGrayColor
 */
@property (strong, nonatomic) UIColor *selectedTitleColor;

/**
 *  title color, Default is lightGrayColor
 */
@property (strong, nonatomic) UIColor *titleColor;

/**
 * whether show the sparator between two titles, Default is NO
 */
@property (assign, nonatomic) BOOL showSeparatorLine;  // default is NO;

/**
 *  block callback when use touch the title, tag start from 0
 */
@property (copy, nonatomic) void (^didTouchTheTitleWithTag)(NSInteger tag);

/**
 *  当前选中的title tag（从0开始）
 */
@property (assign, nonatomic, readonly) NSInteger currentSelectedTag;

/**
 *  当前的segments
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> *segments;

/**
 *  title的下划线，不满意默认的样式，可以自定义。
 */
@property (strong, nonatomic, readonly) UIView *lineview;

/**
 *  autolayout the segment
 *
 *  @param segments segment titles array
 */
- (void) setSegmentsData:(NSArray<NSString *> *)segments;

/**
 *   autolayout for width when passed-in width<0, or use fixed width.
 *
 *  @param segments segment titles array
 *  @param width    fixed width value
 */
- (void) setSegmentsData:(NSArray<NSString *> *)segments fixWidth:(CGFloat)width;


/**
 * 请先实现 UIScrollViewDelegate的方法 scrollViewDidEndDecelerating:
 *  需要联动segment时，需要从外部传入需要联动的 scrollView
 *
 *  @param scrollView 需要联动的 scrollView
 */
- (void) pl_scrollViewDidEndDecelerating:(__weak UIScrollView *)scrollView;

/**
 *  动态更改 文字的下划线，需要实现 UIScrollViewDelegate的方法 scrollViewDidScroll:
 *  并传入当前需要联动的scrollView
 *
 *  @param scrollView 需要联动的 scrollView
 */
- (void) pl_scrollViewDidScroll:(__weak UIScrollView *)scrollView;
@end

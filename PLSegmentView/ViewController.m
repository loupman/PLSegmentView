//
//  ViewController.m
//  PLSegmentView
//
//  Created by PhilipLee on 16/6/24.
//  Copyright © 2016年 Philip Lee. All rights reserved.
//

#import "ViewController.h"
#import "PLSegmentView.h"

#define kScreenWidth          [UIScreen mainScreen].bounds.size.width
#define kScreenHeight         [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) PLSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentView = [[PLSegmentView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 42)];
    _segmentView.botLineColor = [UIColor orangeColor];
    _segmentView.titleFont = [UIFont systemFontOfSize:14];
    _segmentView.selectedTitleColor = [UIColor blackColor];
    _segmentView.titleColor = [UIColor grayColor];
    [_segmentView setSegmentsData:@[@"title0", @"title1", @"title2", @"title3", @"title4", @"title5", @"title6"] fixWidth:80];
    
    __weak __typeof(&*self)weakSelf = self;
    _segmentView.didTouchTheTitleWithTag = ^(NSInteger tag){
        [weakSelf.scrollView setContentOffset:CGPointMake(tag * CGRectGetWidth(weakSelf.scrollView.frame), 0)];
        
        // 更新内容
    };
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentView.frame),
                                                                 kScreenWidth, 100)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth*_segmentView.segments.count, CGRectGetHeight(_scrollView.frame));
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [_segmentView.segments enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = weakSelf.scrollView.frame;
        frame.origin.x = frame.size.width * idx;
        frame.origin.y = 0;
        UIView *view = [[UIView alloc] initWithFrame:frame];
        
        if (idx % 2 == 0) {
            view.backgroundColor = [UIColor grayColor];
        } else {
            view.backgroundColor = [UIColor blueColor];
        }
        [weakSelf.scrollView addSubview:view];
    }];
    
    [self.view addSubview:_segmentView];
    [self.view addSubview:_scrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) { // in case much scrollView
        [_segmentView pl_scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {  // in case much scrollView
        [_segmentView pl_scrollViewDidScroll:scrollView];
    }
}

@end

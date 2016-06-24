//
//  YYSegmentView
//  YunYinDesign
//
//  Created by PhilipLee on 15/12/10.
//  Copyright © 2015年 PhilipLee. All rights reserved.
//

#import "PLSegmentView.h"

#define kButtonTag                    3000
#define kSubLineMarginLeft            10

@interface PLSegmentView() {
}

@property(strong, nonatomic) NSMutableArray *buttons;
@property(strong, nonatomic) NSMutableArray *separatorLines;
@property(strong, nonatomic) NSMutableArray *buttonWidths;
@property(assign, nonatomic) CGFloat fixWidth;

@end

@implementation PLSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        _buttons = [NSMutableArray array];
        _buttonWidths = [NSMutableArray array];
        
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_bgScrollView];
        
        _bgScrollView.contentSize = CGSizeMake(frame.size.width, -8);
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.directionalLockEnabled = YES;
        _bgScrollView.bounces = NO;
        _bgScrollView.scrollsToTop = NO;
        _bgScrollView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
        _bgScrollView.layer.borderWidth = 0.5;
        _bgScrollView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        _bgScrollView.layer.shadowOpacity = 1;
        _bgScrollView.layer.shadowColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
        
        self.exclusiveTouch = YES;
    }
    return self;
}

/// init default data
-(void) initSegmentData
{
    _titleFont = _titleFont?:[UIFont systemFontOfSize:12];
    _titleColor = _titleColor?:[UIColor lightGrayColor];
    _selectedTitleColor = _selectedTitleColor?:[UIColor darkGrayColor];
}

- (void) setSegmentsData:(NSArray<NSString *> *)segments fixWidth:(CGFloat)width
{
    _segments = segments;
    _fixWidth = width;
    
    if (segments.count > 0) {
        [self initSegmentData];
        [self setupSubviews];
    }
}

-(void) setSegmentsData:(NSArray<NSString *> *)segments
{
    [self setSegmentsData:segments fixWidth:-1];
}

- (void) setupSubviews
{
    _count = _segments.count;
    CGFloat selfHeight = _bgScrollView.frame.size.height;
    CGFloat lastTotalWidth = 0;
    
    for (NSUInteger i = 0;  i < _count ; i ++) {
        
        NSString *title = _segments[i];
        CGFloat buttonWidth = _fixWidth;
        
        if (_fixWidth <= 0) {
            CGRect titleSize = [title boundingRectWithSize:self.frame.size
                                                   options:NSStringDrawingUsesDeviceMetrics |
                                                           NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:_titleFont} context:nil];
            buttonWidth = titleSize.size.width + 25;
        }
        
        [_buttonWidths addObject:@(buttonWidth)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(lastTotalWidth, 0, buttonWidth, selfHeight)];
        [btn setTag:kButtonTag + i];
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = _titleFont;
        [btn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        
        [btn setSelected:(i == 0)?YES:NO];
        if (i == 0)  _currentSelectedTag = 0;
        
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:btn];
        
        [self.buttons addObject:btn];
        lastTotalWidth += buttonWidth;
        
        // Add separator line between two title if need
        if (_showSeparatorLine && (i != _count -1)) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(lastTotalWidth, (selfHeight-16)/2, 0.5, 16)];
            separator.backgroundColor = [UIColor lightGrayColor];
            
            [_bgScrollView addSubview:separator];
            [self.separatorLines addObject:separator];
        }
    }
    UIButton *firstOne = _buttons[0];
    _lineview = [[UIView alloc] initWithFrame:CGRectMake(kSubLineMarginLeft, selfHeight - 2,
                                                         firstOne.bounds.size.width - kSubLineMarginLeft*2, 2)];
    [_lineview setBackgroundColor:_botLineColor?:[UIColor redColor]];

    CGFloat scrollWidth = lastTotalWidth;
    if (scrollWidth < self.frame.size.width) {
        scrollWidth = self.frame.size.width;
    }
    [_bgScrollView addSubview:_lineview];
    _bgScrollView.contentSize = CGSizeMake(scrollWidth, _bgScrollView.contentSize.height);

}

-(void)clickButton:(UIButton*)button
{
    if (button.selected) {
        return;
    }
    
    [self updateSelectButtonWithTag:button.tag - kButtonTag];
    
    if (_didTouchTheTitleWithTag) {
        _didTouchTheTitleWithTag(button.tag - kButtonTag);
    }
}

-(void) adjustSelectedTitleToCenter
{
    NSInteger realTag = _currentSelectedTag;
    if (realTag >= _buttons.count) {
        return;
    }
    UIButton *button = _buttons[realTag];
    
    // 当前点击的按钮 在该view的父类view上的位置
    CGPoint point = [_bgScrollView convertPoint:button.frame.origin toView:self.superview];
    
    CGFloat posx = 0;
    CGFloat btnHalfWidth = CGRectGetWidth(button.frame)/2;
    CGFloat selfWidth = CGRectGetWidth(_bgScrollView.frame);
    CGFloat contentWidth = _bgScrollView.contentSize.width;
    
    
    if ((point.x + btnHalfWidth) > selfWidth/2) {
        // 向前移动，判断后面是否到头了
        posx = button.frame.origin.x- selfWidth/2 + btnHalfWidth;
        if ((posx + selfWidth + 0.2) > _bgScrollView.contentSize.width) {
            posx = contentWidth - selfWidth;
        }
    } else {
        // 向后移动，判断前面是否到头了。
        posx = button.frame.origin.x - (selfWidth/2 - point.x) + btnHalfWidth;
        
        if (posx <= 0.2) {
            posx = 0;
        } else if ((posx + selfWidth + 0.2) > _bgScrollView.contentSize.width) {
            // 向后移动，判断移动button移动到中心位置后，是否前面到头了。
            posx = contentWidth - selfWidth;
        }
    }
    [_bgScrollView setContentOffset:CGPointMake(posx, 0) animated:YES];
}

#pragma mark lazy getters
-(NSMutableArray *)separatorLines
{
    if (!_separatorLines) {
        _separatorLines = [NSMutableArray array];
    }
    return _separatorLines;
}

// update method
- (void)updateSelectButtonWithTag:(NSInteger)tag
{
    _currentSelectedTag = tag;
    UIButton *button = nil;
    for (UIButton *btn in _buttons) {
        [btn setSelected:(tag == (btn.tag-kButtonTag))?YES:NO];
        
        if (btn.selected) {
            button = btn;
        }
    }
    CGFloat buttonWidth = button.bounds.size.width;
    CGFloat height = _lineview.bounds.size.height;
    [UIView animateWithDuration:0.2 animations:^(void){
        [_lineview setFrame:CGRectMake(CGRectGetMinX(button.frame) + kSubLineMarginLeft,
                                       CGRectGetHeight(_bgScrollView.frame) - height,
                                       buttonWidth - kSubLineMarginLeft*2, height)];
    }];
    
    [self adjustSelectedTitleToCenter];
}

/// 联动更改segment 的位置
- (void) pl_scrollViewDidEndDecelerating:(__weak UIScrollView *)scrollView
{
    NSInteger offset = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    [self updateSelectButtonWithTag:offset];
}

- (void) pl_scrollViewDidScroll:(__weak UIScrollView *)scrollView
{
//    CGPoint point = scrollView.contentOffset;
//    CGFloat ratio = point.x / scrollView.contentSize.width;
//    
//    CGFloat originX = CGRectGetWidth(scrollView.frame) * ratio;
//    CGRect frame = _lineview.frame;
//    frame = (CGRect){{originX + 10,frame.origin.y}, frame.size};
//    
//    [_lineview setFrame:frame];
}
@end

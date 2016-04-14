//
//  DBSeeDetailScrollView.m
//  ScrollToSeeDetail
//
//  Created by arons on 16/3/9.
//  Copyright © 2016年 arons. All rights reserved.
//

#import "DBSeeDetailScrollView.h"
#import "UIImageView+WebCache.h"


@implementation DBScrollImagItem

@end


typedef enum : NSUInteger {
    DBScrollStateDrag,
    DBScrollStateRelease,
} DBScrollViewState;

@interface DBSeeDetailScrollView ()<UIScrollViewDelegate>

@property(nonatomic, strong) NSArray* adImages;
@property(nonatomic, assign) DBScrollViewState state;

@property(nonatomic, weak) UIScrollView* scrollView;
@property(nonatomic, weak) UILabel* showLabel;
@property(nonatomic, weak) UIImageView* arrowImageView;
@property(nonatomic, weak) UIPageControl* pageControl;

@end


static CGFloat tipsViewW = 56;


@implementation DBSeeDetailScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        [self setProperty];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setProperty];
    }
    return self;
}

-(void)setProperty{
    _state = DBScrollStateDrag;
    _adImages = [NSMutableArray array];
    
    NSString* str1 = @"拖动查看图文详情";
    NSString* str2 = @"释放查看图文详情";
    _inDragStateString = str1;
    _releaseStateString = str2;
    
    _pageIndicatorTintColor = [UIColor grayColor];
    _currentPageIndicatorTintColor = [UIColor redColor];
}

-(void)setImageUrls:(NSArray*)imageUrls {
    _adImages = imageUrls;
    [self updateUI];
}

-(void)updateUI{
    
    // 删除旧的View
    [_scrollView removeFromSuperview];
    [_pageControl removeFromSuperview];
    
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    UIScrollView* scrollView = [UIScrollView new];
    scrollView.frame = CGRectMake(0, 0, viewW, viewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor colorWithRed:239.0f/255 green:239.0f/255 blue:239.0f/255 alpha:1];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    // 添加图片的子页面
    for (int i =0; i<_adImages.count; i++) {
        DBScrollImagItem* adImage = _adImages[i];
        UIImageView* imageView = [UIImageView new];
        if (adImage.isLocal) {
            imageView.image = [UIImage imageNamed:adImage.imgUrl];
        }else {
            [imageView sd_setImageWithURL:[NSURL URLWithString:adImage.imgUrl]];
        }
        imageView.frame = CGRectMake(viewW*i, 0, viewW, viewH);
        [scrollView addSubview:imageView];
    }
    
    // 添加拖动查看详情的View
    UIView* tipsView = [[UIView alloc] init];
    tipsView.backgroundColor = [UIColor clearColor];
    tipsView.frame = CGRectMake(_adImages.count*viewW, 0, tipsViewW, viewH);
    [scrollView addSubview:tipsView];
    
    UIImageView* arrowImageView = [UIImageView new];
    arrowImageView.frame = CGRectMake(8, 0, 15, viewH);
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.image = [UIImage imageNamed:@"db_see_detail_swipe_arrow"];
    [tipsView addSubview:arrowImageView];
    _arrowImageView = arrowImageView;
    
    UILabel* showLabel = [UILabel new];
    showLabel.frame = CGRectMake(30, 0, 25, viewH);
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.font = [UIFont boldSystemFontOfSize:13];
    showLabel.textColor = [UIColor colorWithRed:154.0f/255 green:154.0f/255 blue:154.0f/255 alpha:1];
    showLabel.lineBreakMode = NSLineBreakByWordWrapping;
    showLabel.numberOfLines = 0;
    [tipsView addSubview:showLabel];
    _showLabel = showLabel;
    
    scrollView.contentSize = CGSizeMake(_adImages.count*viewW, viewH);
    
    UIPageControl* pageControl = [UIPageControl new];
    pageControl.hidesForSinglePage = YES;
    pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    pageControl.currentPage = 1;
    pageControl.numberOfPages = _adImages.count;
    pageControl.frame = CGRectMake(0, viewH - 30, viewW, 30);
    [self addSubview:pageControl];
    _pageControl = pageControl;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat off = scrollView.contentOffset.x;
    CGFloat viewW = self.frame.size.width;
    CGFloat MaxOff = 30;
    int page = MIN(((int)(off/viewW+0.5)), _adImages.count);
    page = MAX(0, page);
    _pageControl.currentPage = page;
    CGFloat scale = 0;
    CGFloat maxOff = (_adImages.count - 1)*viewW + tipsViewW;
    if (off>maxOff) {
      // 滚动在Detail区域
        scale = (off - maxOff) > MaxOff ? 1.0: ((off - maxOff)/MaxOff);
        NSLog(@"%lf",scale);
        _showLabel.text = _releaseStateString;
        
        if (_state != DBScrollStateRelease) {
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
        }
        _state = DBScrollStateRelease;
        
    }else {
    //滚动在图片区域
         self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI * scale);
        _showLabel.text = _inDragStateString;
        
        if (_state != DBScrollStateDrag) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }
        _state = DBScrollStateDrag;
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat off = scrollView.contentOffset.x;
    CGFloat viewW = self.frame.size.width;
    
    CGFloat maxOff = (_adImages.count - 1)*viewW + tipsViewW;
    if (off>maxOff) {
        if (_showDetailBlock) {
            _showDetailBlock();
        }
    }
}

-(NSString*)convertToVStr:(NSString*)hStr{
    NSMutableString* vStr = [NSMutableString new];
    for (int i = 0; i<hStr.length; i++) {
        [vStr appendString:[hStr substringWithRange:NSMakeRange(i, 1)]];
        [vStr appendString:@"\n"];
    }
    return vStr;
}

@end

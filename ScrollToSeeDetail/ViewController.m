//
//  ViewController.m
//  ScrollToSeeDetail
//
//  Created by arons on 16/3/9.
//  Copyright © 2016年 arons. All rights reserved.
//

#import "ViewController.h"

#import "DBSeeDetailScrollView.h"


typedef enum : NSUInteger {
    DBScrollStateDrag,
    DBScrollStateRelease,
} DBScrollState;

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) NSArray* adImages;
@property(nonatomic, assign) DBScrollState state;

@property(nonatomic, strong) UILabel* showLabel;
@property(nonatomic, strong) UIImageView* arrowImageView;
@end

static CGFloat tipsViewW = 56;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    _state = DBScrollStateDrag;
//    _adImages = @[@"banner1", @"banner2"];
//    
//    UIScrollView* scrollView = [UIScrollView new];
//    scrollView.frame = CGRectMake(0, 0, 320, 200);
//    scrollView.pagingEnabled = YES;
//    scrollView.backgroundColor = [UIColor colorWithRed:239.0f/255 green:239.0f/255 blue:239.0f/255 alpha:1];
//    scrollView.delegate = self;
//    [self.view addSubview:scrollView];
//    
//    // 添加展示图片的子页面
//    for (int i =0; i<_adImages.count; i++) {
//        NSString* adImage = _adImages[i];
//        UIImageView* imageView = [UIImageView new];
//        imageView.image = [UIImage imageNamed:adImage];
//        imageView.frame = CGRectMake(320*i, 0, 320, 200);
//        [scrollView addSubview:imageView];
//    }
//    
//    // 添加拖动查看详情的View
//    UIView* tipsView = [[UIView alloc] init];
//    tipsView.backgroundColor = [UIColor clearColor];
//    tipsView.frame = CGRectMake(_adImages.count*320, 0, tipsViewW, 200);
//    [scrollView addSubview:tipsView];
//
//    UIImageView* arrowImageView = [UIImageView new];
//    arrowImageView.frame = CGRectMake(8, 0, 15, 200);
//    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
//    arrowImageView.image = [UIImage imageNamed:@"ic_swipe_arrow"];
//    [tipsView addSubview:arrowImageView];
//    _arrowImageView = arrowImageView;
//    
//    UILabel* showLabel = [UILabel new];
//    showLabel.frame = CGRectMake(30, 0, 25, 200);
//    showLabel.backgroundColor = [UIColor clearColor];
//    showLabel.font = [UIFont boldSystemFontOfSize:13];
//    showLabel.textColor = [UIColor colorWithRed:154.0f/255 green:154.0f/255 blue:154.0f/255 alpha:1];
//    showLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    showLabel.numberOfLines = 0;
//    [tipsView addSubview:showLabel];
//    _showLabel = showLabel;
//
//    scrollView.contentSize = CGSizeMake(_adImages.count*320, 200);
    
    
    NSArray* tmpImages = @[@"banner1", @"banner2", @"banner3"];
    NSMutableArray* images = [NSMutableArray array];
    for (int i = 0; i<tmpImages.count; i++) {
        NSString* imgUrl = tmpImages[i];
        DBScrollImagItem* imgItem = [DBScrollImagItem new];
        imgItem.imgUrl = imgUrl;
        imgItem.isLocal = YES;
        [images addObject:imgItem];
    }
    
    NSString* webImgUrl = @"http://img4.duitang.com/uploads/item/201205/31/20120531170732_sSwAu.jpeg";
    DBScrollImagItem* imgItem = [DBScrollImagItem new];
    imgItem.imgUrl = webImgUrl;
    imgItem.isLocal = NO;
    [images addObject:imgItem];
    
    DBSeeDetailScrollView* seeDetailScrollView = [[DBSeeDetailScrollView alloc] initWithFrame:CGRectMake(10, 300, 300, 180)];
    [seeDetailScrollView setImageUrls:images];
    [seeDetailScrollView updateUI];
    seeDetailScrollView.showDetailBlock = ^(){
        NSLog(@"=======");
    };
    [self.view addSubview:seeDetailScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat off = scrollView.contentOffset.x;
    // NSLog(@"scrollViewDidScroll off:%f", off);
    
    NSString* str1 = @"拖动查看图文详情";
    NSString* str2 = @"释放查看图文详情";
    CGFloat maxOff = (_adImages.count - 1)*320 + tipsViewW;
    if (off>maxOff) {
        _showLabel.text = str2;
        
        if (_state != DBScrollStateRelease) {
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
        }
        _state = DBScrollStateRelease;

    }else {
        _showLabel.text = str1;
        
        if (_state != DBScrollStateDrag) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        }
        _state = DBScrollStateDrag;

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
    CGFloat off = scrollView.contentOffset.x;

    CGFloat maxOff = (_adImages.count - 1)*320 + tipsViewW;
    if (off>maxOff) {
        NSLog(@"查看详情");
    }else {
        NSLog(@"不查看详情");
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

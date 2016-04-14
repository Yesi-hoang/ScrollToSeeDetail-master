//
//  DBSeeDetailScrollView.h
//  ScrollToSeeDetail
//
//  Created by arons on 16/3/9.
//  Copyright © 2016年 arons. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DBScrollImagItem : NSObject

@property (nonatomic, assign) BOOL isLocal;
@property (nonatomic, copy) NSString* imgUrl;

@end


typedef void(^ShowDetailBlock)();

@interface DBSeeDetailScrollView : UIView

@property (nonatomic, strong) UIColor* pageIndicatorTintColor;
@property (nonatomic, strong) UIColor* currentPageIndicatorTintColor;

@property (nonatomic, copy) NSString* inDragStateString;
@property (nonatomic, copy) NSString* releaseStateString;

@property (nonatomic, copy) ShowDetailBlock showDetailBlock;

-(void)updateUI;

-(void)setImageUrls:(NSArray*)imageUrls;

@end

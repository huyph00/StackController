//
//  StackController.h
//  StackController
//
//  Created by NCXT on 17/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StackObject.h"
@protocol StackControllerDelegate
@optional
-(void)selectedObject:(StackObject*)obj;
@end
@interface StackController : UIView<UIScrollViewDelegate>
{
    BOOL isSelecting;
    NSArray * arrData;
    NSMutableArray * arrStacks;

    StackObject * stackSelected;

    int selecttingIndex;
    
    UIView * viewSelected;
    
    id<StackControllerDelegate> delegate;
    UIScrollView * scrView;
    
    UIButton * btnHome;
    CGFloat curr_scroll_y;
    CGFloat topSpace;
    CGFloat rateFinal ;
    CGFloat selectedStack_offset_y ;
    CGFloat titleHeight;

    UIFont * titleFont;
}
@property(nonatomic,strong)UIScrollView * scrView;
@property(nonatomic,strong)UIFont * titleFont;

@property(nonatomic)CGFloat titleHeight;

@property(nonatomic,strong) StackObject * stackSelected;
-(id)initWithFrame:(CGRect)frame data:(NSArray *)data titleFont:(UIFont*)font selectStackOffsetY:(CGFloat)offset_y selectedIndex:(int)index;
-(void)setUpView;

@end

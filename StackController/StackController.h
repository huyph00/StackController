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
    NSArray * arrData;
    NSMutableArray * arrStacks;

    StackObject * stackSelected;

    CGFloat curr_scroll_y;
    
    int selecttingIndex;
    
    UIView * viewSelected;
    
    id<StackControllerDelegate> delegate;
    UIScrollView * scrView;

    CGFloat zoomRate;
    CGFloat titleHeight;
    
    UIButton * btnHome;
}
@property(nonatomic)CGFloat zoomRate;
@property(nonatomic)CGFloat titleHeight;

@property(nonatomic,strong) StackObject * stackSelected;
-(id)initWithFrame:(CGRect)frame data:(NSArray *)data selectedIndex:(int)index;

@end
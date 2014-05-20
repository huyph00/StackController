//
//  StackController.m
//  StackController
//
//  Created by NCXT on 17/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "StackController.h"

@implementation StackController
@synthesize stackSelected,titleHeight,zoomRate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame data:(NSArray *)data selectedIndex:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        zoomRate = 0.05;
        titleHeight = 50;
        arrData = data;
        selecttingIndex = index;
        arrStacks = [NSMutableArray array];
        topSpace = self.frame.size.height/2; // define topspace = viewheight/2
        CGRect scrRect = self.bounds;
        CGFloat scrHeightSize = topSpace + topSpace * arrData.count;
        scrView = [[UIScrollView alloc]initWithFrame:scrRect];
        scrView.delegate = self;
        [self addSubview:scrView];
        
        [scrView setContentSize:CGSizeMake(self.frame.size.width, scrHeightSize)];
        //button remove showing view
        btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
        btnHome.frame = CGRectMake(0, 50, 100, 40);
        [btnHome setTitle:@"Back" forState:UIControlStateNormal];
        [btnHome setBackgroundColor:[UIColor redColor]];
        [btnHome addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnHome];
        scrView.bounces = NO;
        
        //init stack view
        for (int i = 0 ; i < data.count; i++) {
            StackObject * stk = [data objectAtIndex:i];
            CGRect itemFrame = self.bounds;
            
            itemFrame.origin.y =scrRect.size.height/2 + scrRect.size.height/2 * i;
            
            UIView * viewStack = [[UIView alloc]initWithFrame:itemFrame];
            viewStack.backgroundColor = [UIColor yellowColor];
            viewStack.layer.borderColor = [UIColor blackColor].CGColor;
            viewStack.layer.borderWidth = 1;

            UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemFrame.size.width, titleHeight)];
            lblTitle.text = stk.strTitle;
            lblTitle.textAlignment = NSTextAlignmentCenter;
            [viewStack addSubview:lblTitle];
            

            
            stk.viewDetail.frame = CGRectMake(0, titleHeight, viewStack.frame.size.width, viewStack.frame.size.height);
            [viewStack addSubview:stk.viewDetail];
            
            
            //add button event touch stack
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = viewStack.bounds;
            [viewStack addSubview:button];
            [button setTag:i];
            [button addTarget:self action:@selector(stackSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrView addSubview:viewStack];
            [arrStacks addObject:viewStack];
            
        }
        
        [scrView setContentOffset:CGPointMake(0, selecttingIndex * topSpace)];
        curr_scroll_y = scrView.contentOffset.y;
        NSLog(@"start offset %f",scrView.contentOffset.y);
        [self fixFrameForItems];
    }
    return self;
}
-(void)backToHome:(UIButton *)button
{
    if(viewSelected)
    {
        UIView * removeView = stackSelected.viewDetail;
        [UIView animateWithDuration:1.0 animations:^{
        
            removeView.frame = oldFrame;
        }completion:^(BOOL finished){
            removeView.frame = CGRectMake(0, titleHeight, self.frame.size.width, self.frame.size.height);
            NSLog(@"%f",viewSelected.frame.size.width);
            [viewSelected addSubview:removeView];
            [viewSelected sendSubviewToBack:removeView];
            viewSelected = nil;
        }];
    }
}

static CGRect oldFrame;

-(void)stackSelected:(UIButton*)button
{
    StackObject * obj = [arrData objectAtIndex:button.tag];
    [delegate selectedObject:obj];
    stackSelected = obj;
    viewSelected= [arrStacks objectAtIndex:button.tag];
    
    CGFloat viewY =viewSelected.frame.origin.y + titleHeight-   scrView.contentOffset.y;
    CGFloat  viewX = viewSelected.layer.frame.origin.x ;
    CGFloat  viewWidth = viewSelected.layer.frame.size.width;
    oldFrame =CGRectMake(viewX, viewY,viewWidth, obj.viewDetail.frame.size.height);
    obj.viewDetail.frame = oldFrame;
    [self addSubview:obj.viewDetail];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        
        obj.viewDetail.frame = self.bounds;
        [self bringSubviewToFront:btnHome];
        
    }];}
-(void)showView
{
    
}
static CGFloat topSpace = 230;

-(void)fixFrameForItems
{
  
    //range from 0 -> 230 iphone
    //fix current item
    CGFloat range = selecttingIndex * topSpace -curr_scroll_y ;
    CGFloat distance =titleHeight + (topSpace - titleHeight)*range/topSpace;
     //   NSLog(@"distance %f",distance);
    
    UIView * curView = [arrStacks objectAtIndex:selecttingIndex];
    //update selected view
    CGRect itemFrame = curView.frame;
    itemFrame.origin.y =topSpace + topSpace * selecttingIndex;
    curView.frame = itemFrame;
    CGFloat rate = 1.0 -(topSpace - range)/topSpace * 0.05;
    
  //  NSLog(@"rate %f",rate);
    [self transFormView:curView rate:1.0f];
    
    //fix above item
    if(selecttingIndex > 0)
    {
        
        UIView* aboveView =[arrStacks objectAtIndex:selecttingIndex-1];
        CGRect rect = aboveView.frame;
        rect.origin.y = curView.frame.origin.y - distance*rate;
        aboveView.frame = rect;
        
        
        [self transFormView:aboveView rate:rate];

        
    }
    //fix other items
    if(selecttingIndex > 1)for (int i = selecttingIndex - 1; i > 0; i--)
    {
        UIView * view1 =[arrStacks objectAtIndex:i];
        UIView * view2 =[arrStacks objectAtIndex:i-1];
        
        
        range = i * topSpace -curr_scroll_y;
        CGFloat rate = 1.0 -(topSpace - range)/topSpace * zoomRate;
        NSLog(@"range %f",range);
        CGRect rect = view2.frame;
        rect.origin.y = view1.frame.origin.y - titleHeight*rate;
        view2.frame = rect;

        [self transFormView:view2 rate:rate];

    }
    
}

-(void)transFormView:(UIView *)view rate:(CGFloat)rate

{
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//     rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
    rotationAndPerspectiveTransform = CATransform3DMakeScale(rate, rate, 1.0f);
//    view.layer.anchorPoint = CGPointMake(0.5, 0);
    view.layer.transform = rotationAndPerspectiveTransform;

}


#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;                                               // any offset changes
{

    curr_scroll_y = scrollView.contentOffset.y ;
    selecttingIndex = curr_scroll_y/topSpace + 1;
    if(selecttingIndex >= arrStacks.count)selecttingIndex = arrStacks.count-1;

    [self fixFrameForItems];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{

    if (!decelerate) {
        int index2 = scrollView.contentOffset.y / (topSpace/2);
        
        int index = (index2 % 2 > 0) ? index2/2 + 1:index2 /2;
        
        NSLog(@"index %d",index);
        [scrollView setContentOffset:CGPointMake(0, index* topSpace) animated:YES];
        ;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    int index2 = scrollView.contentOffset.y / (topSpace/2);
    
    int index = (index2 % 2 > 0) ? index2/2 + 1:index2 /2;
    
    [scrollView setContentOffset:CGPointMake(0, index* topSpace) animated:YES];
    ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  StackController.m
//  StackController
//
//  Created by NCXT on 17/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "StackController.h"

@implementation StackController
@synthesize stackSelected,titleHeight,zoomRate,scrView,titleFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame data:(NSArray *)data titleFont:(UIFont*)font selectedIndex:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        rateFinal = 0.8 ;
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
        scrView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [scrView setShowsVerticalScrollIndicator:NO];
        titleFont=font;
        [self addSubview:scrView];
        
        [scrView setContentSize:CGSizeMake(self.frame.size.width, scrHeightSize)];
        //button remove showing view
        btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        
        btnHome.frame = CGRectMake(30, 30, 40 , 40);
      //  [btnHome setImage:[self standarScaleWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close-btn" ofType:@"png"]]] forState:UIControlStateNormal];
        [btnHome setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close-btn" ofType:@"png"]] forState:UIControlStateNormal];
        [btnHome addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnHome];
        scrView.bounces = NO;
        
        btnHome.hidden= YES;
        
        //init stack view
        for (int i = 0 ; i < data.count; i++) {
            StackObject * stk = [data objectAtIndex:i];
            CGRect itemFrame = self.bounds;
            
            itemFrame.origin.y =topSpace + topSpace * i;
            // create stack
            UIView * viewStack = [[UIView alloc]initWithFrame:itemFrame];
            viewStack.backgroundColor = [UIColor clearColor];
            viewStack.layer.borderColor = [UIColor blackColor].CGColor;
            viewStack.clipsToBounds = NO;
            
            //add background for stack
            UIImage * bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stack-bg-1" ofType:@"png"]];
            UIImageView * bgImageView = [[UIImageView alloc]initWithImage:[self standarScaleWithImage:bgImage]];
            bgImageView.frame =CGRectMake(0, -20, itemFrame.size.width, titleHeight+20);
            [viewStack addSubview:bgImageView];
            
            bgImageView.tag = 199;
            
            
            //add label title
            UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, itemFrame.size.width, titleHeight)];
            lblTitle.text = stk.strTitle;
            lblTitle.backgroundColor = [UIColor clearColor];
            lblTitle.textAlignment = NSTextAlignmentCenter;
            lblTitle.textColor = [UIColor whiteColor];
            [viewStack addSubview:lblTitle];
            lblTitle.font = titleFont;

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


-(UIImage*)standarScaleWithImage:(UIImage *)imgStandar
{
    
    return [imgStandar resizableImageWithCapInsets:UIEdgeInsetsMake(imgStandar.size.height/2, imgStandar.size.width/2, imgStandar.size.height/2,imgStandar.size.width/2)];
    
}


-(void)backToHome:(UIButton *)button
{
    if(viewSelected)
    {
        isSelecting = NO;

        btnHome.hidden= YES;

        UIView * removeView = stackSelected.viewDetail;
        [UIView animateWithDuration:0.5 animations:^{
        
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

static CGRect oldFrame;//save frame to send back presenting view

-(void)stackSelected:(UIButton*)button
{
    //check view presenting
    if(viewSelected) return;
    if (selecttingIndex - 1 != button.tag) {
        isSelecting = YES;

     //   CGPoint offset = scrView.contentOffset;
     //   [scrView setContentOffset:offset animated:NO];
        [scrView setContentOffset:CGPointMake(0,  topSpace* button.tag)animated:YES];
        return;
    }
    
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
    
    
    [UIView animateWithDuration:0.5 animations:^{
        
        obj.viewDetail.frame = self.bounds;
        [self bringSubviewToFront:btnHome];
        
    }completion:^(BOOL finished){
    
        btnHome.hidden= NO;

    
    }];
}

-(void)fixFrameForItems
{
  
    //range from 0 -> 230 iphone
    //fix current item
    CGFloat range = selecttingIndex * topSpace -curr_scroll_y ;
    CGFloat distance =titleHeight + (topSpace - titleHeight)*range/topSpace;
    
    UIView * curView = [arrStacks objectAtIndex:selecttingIndex];
    //update selected view
    CGRect itemFrame = curView.frame;
    itemFrame.origin.y =topSpace + topSpace * selecttingIndex;
    curView.frame = itemFrame;

    [self transFormView:curView rate:1.0f];
    
    //fix above item
    if(selecttingIndex > 0)
    {
        
        UIView* aboveView =[arrStacks objectAtIndex:selecttingIndex-1];
        CGRect rect = aboveView.frame;
        rect.origin.y = curView.frame.origin.y - distance;
        aboveView.frame = rect;
        CGFloat x =(topSpace - range)/topSpace;
        CGFloat rate = 1.0 -rateFinal*x/(x + 10);
        [self transFormView:aboveView rate:rate];

        
    }
    //fix other items
    if(selecttingIndex > 1)
        for (int i = selecttingIndex - 1; i > 0; i--)
        {
            UIView * view1 =[arrStacks objectAtIndex:i];
            UIView * view2 =[arrStacks objectAtIndex:i-1];
            
            range = i * topSpace -curr_scroll_y;
            
            
            CGFloat x =(topSpace - range)/topSpace;
            CGFloat rate = 1.0 -rateFinal*x/(x + 10);
            NSLog(@"range %f; rate %f",range,rate);

            [self transFormView:view2 rate:rate];
         
            CGRect rect = view2.frame;
            rect.origin.y = view1.frame.origin.y - titleHeight*rate;

            view2.frame = rect;
        }
    
}

-(void)transFormView:(UIView *)view rate:(CGFloat)rate

{
  //  view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    view.transform =  CGAffineTransformMakeScale(rate, rate);

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
    if (isSelecting) {
        return;
    }
    if (!decelerate) {
        int index2 = scrollView.contentOffset.y / (topSpace/2);
        
        int index = (index2 % 2 > 0) ? index2/2 + 1:index2 /2;

        [scrollView setContentOffset:CGPointMake(0, index* topSpace) animated:YES];

    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    if (isSelecting) {
        return;
    }

    int index2 = scrollView.contentOffset.y / (topSpace/2);
    
    int index = (index2 % 2 > 0) ? index2/2 + 1:index2 /2;
    
    [scrollView setContentOffset:CGPointMake(0, index* topSpace) animated:YES];

//   NSLog(@"index %d",index);

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
{
    isSelecting = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
/*
static CGPoint point1;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    UITouch *touch=[touches anyObject];

    CGPoint point2 = [touch locationInView:self];//(point2 is type of CGPoint)
    
    CGFloat disTance = point2.y - point1.y;
    point1 = point2;
    NSLog(@"%f",disTance);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}
 */
@end

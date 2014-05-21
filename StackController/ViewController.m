//
//  ViewController.m
//  StackController
//
//  Created by NCXT on 17/05/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    

    NSMutableArray * arrStack = [NSMutableArray array];
    
    for (int i = 0; i <50; i++) {
        StackObject *stack = [[StackObject alloc]init];
        stack.strTitle = [NSString stringWithFormat:@"stack %d",i];
        UIView * view= [[UIView alloc]initWithFrame:self.view.bounds];
        [view setBackgroundColor:[UIColor grayColor]];
        stack.viewDetail = view;
        [arrStack addObject:stack];
        
    }
    
    StackController *stackView= [[StackController alloc]initWithFrame:self.view.bounds data:arrStack titleFont:nil selectedIndex:3];
    [self.view addSubview:stackView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testAnimation:(id)sender {
    
 //   aView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    CGRect frame = aView.frame;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
    
    aView.layer.anchorPoint = CGPointMake(0.5, 0);
    aView.transform = CGAffineTransformMakeScale(1.0, 0.5);
    aView.layer.position = topCenter;

    
}
#pragma mark - stack controller delegate
-(void)selectedObject:(StackObject *)obj
{
    
}

@end

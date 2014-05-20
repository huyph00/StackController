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
    
    for (int i = 0; i <5; i++) {
        StackObject *stack = [[StackObject alloc]init];
        stack.strTitle = [NSString stringWithFormat:@"stack %d",i];
        UIView * view= [[UIView alloc]initWithFrame:self.view.bounds];
        [view setBackgroundColor:[UIColor grayColor]];
        stack.viewDetail = view;
        [arrStack addObject:stack];
        
    }
    
    StackController *stackView= [[StackController alloc]initWithFrame:self.view.bounds data:arrStack selectedIndex:3];
    [self.view addSubview:stackView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testAnimation:(id)sender {
    

//    [UIView animateWithDuration:1.0 animations:^{
//        
////        CGRect rect = aView.frame;
////        rect.origin.y +=100;
////        aView.frame = rect;
//        
//        
//        
//        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//   //     rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
//        rotationAndPerspectiveTransform = CATransform3DMakeScale( 0.5f, 0.5f, 0.5f);
//        
//        
//     //   aView.layer.anchorPoint = CGPointMake(0.5, 0);
//        aView.layer.transform = rotationAndPerspectiveTransform;
//        
//        bView.layer.transform = rotationAndPerspectiveTransform;
//    } completion:^(BOOL finished){
//        // code to be executed when flip is completed
//    }];
    
}
#pragma mark - stack controller delegate
-(void)selectedObject:(StackObject *)obj
{
    
}

@end

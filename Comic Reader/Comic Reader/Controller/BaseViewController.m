//
//  BaseViewController.m
//  Comic Reader
//
//  Created by Tran Han on 2/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "BaseViewController.h"
#import "Header.h"
@interface BaseViewController ()
@end

@implementation BaseViewController
@synthesize customNav;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:NIB_CUSTOM_NAVIGATION_BAR
                                                      owner:self
                                                    options:nil];
    
    customNav = [ nibViews objectAtIndex:0];
    
    customNav.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:customNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutView
{
    // init backgroung color
    // hoddenview for subclass
    // detect view that will show
    [self customNavigationBar];
    //    self.navigationController.navigationBar.hidden = YES;
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:customNav
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:20.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:customNav
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeRight
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:customNav
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeft
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:customNav
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:customNav
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:60.0]];
    
    
    [self.view updateConstraints];
    
}
-(void)customNavigationBar
{
    // init backgroung color navigationbar
    
    // add row back button
    //    [self.navigationController.navigationBar addSubview:]
    if (self.hasBack) {
        
        //        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"arrowBack.png"] forBarMetrics:UIBarMetricsDefault];
        //        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"arrowBack.png"]];
        
    }else
    {
        //        self.navigationController.navigationBar.backItem.hidesBackButton = YES;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)layoutView
{
    // init backgroung color
    // hoddenview for subclass
    // detect view that will show
    [self customNavigationBar];
}
-(void)customNavigationBar
{
    // init backgroung color navigationbar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:55.0/255.0f green:113.0/255.0f blue:183.0/255.0f alpha:1.0]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // add row back button
//    [self.navigationController.navigationBar addSubview:]
    if (self.hasBack) {
        
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"arrowBack.png"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"arrowBack.png"]];

    }else
    {
        self.navigationController.navigationBar.backItem.hidesBackButton = YES;
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

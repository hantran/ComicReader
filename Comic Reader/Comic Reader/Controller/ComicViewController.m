//
//  ComicViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicViewController.h"

@interface ComicViewController ()

@end

@implementation ComicViewController
@synthesize scrollView;
@synthesize imageComic;
@synthesize labelPage;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasBack = YES;
    imageComic.image = [UIImage imageNamed:@"b.jpg"];
    [scrollView setMaximumZoomScale:2.0f];
    [scrollView setClipsToBounds:YES];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return imageComic;
}
-(void)customNavigationBar
{
    [super customNavigationBar];
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

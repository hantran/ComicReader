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
   
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    
    UIImage *image0 = [UIImage imageNamed:@"b.jpg"];
    UIImage *image1 = [UIImage imageNamed:@"ah1.jpg"];
    UIImage *image2 = [UIImage imageNamed:@"ah2.jpg"];
    UIImage *image3 = [UIImage imageNamed:@"ah3.jpg"];
    
    NSArray *images = [[NSArray alloc] initWithObjects:image0,image1,image2,image3,nil];
    // Now create a UIScrollView to hold the UIImageViews
    scrollView.pagingEnabled = YES;
    
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    for (int i = 0; i < [images count]; i++) {
        CGFloat xOrigin = i * screenWidth;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,0,screenWidth,screenHeight)];
        [imageView setImage:[images objectAtIndex:i]];
        [scrollView addSubview:imageView];
    }
    
    // Set the contentSize equal to the size of the UIImageView
//     scrollView.contentSize = imageView.scrollview.size;
    scrollView.contentSize = CGSizeMake(4 * screenWidth, scrollView.frame.size.height);
    [scrollView setMaximumZoomScale:2.0f];
    [scrollView setClipsToBounds:YES];
    
    
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

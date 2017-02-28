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
@synthesize titleLabel;
@synthesize comic;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasBack = YES;
    self.titleNav.text = titleLabel;
    [self initDataComic];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutView];

}
-(void)initDataComic{
    
    NSString *comicPath = [comic valueForKey:@"comicPath"];
    int numOfPage = [comic valueForKey:@"totalPage"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    
    scrollView.pagingEnabled = YES;
    
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    for (int i = 0; i < numOfPage; i++) {
        CGFloat xOrigin = i * screenWidth;
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.jpg", comicPath, i +1]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,0,screenWidth,screenHeight)];
        [imageView setImage:image];
        [scrollView addSubview:imageView];
    }
    scrollView.contentSize = CGSizeMake(numOfPage * screenWidth, screenHeight - 60);
    [scrollView setMaximumZoomScale:2.0f];
    [scrollView setClipsToBounds:YES];

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

//
//  ComicViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicViewController.h"
#import "LocalManager.h"

@interface ComicViewController ()

@end

@implementation ComicViewController
@synthesize scrollView;
@synthesize pageIndex;
@synthesize labelPage;
@synthesize titleLabel;
@synthesize comic;
@synthesize numOfPage;
@synthesize comicPath;
@synthesize screenWidth;
@synthesize screenHeight;
@synthesize size;
@synthesize imageArray;
@synthesize position;
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
    
    
    comicPath = [comic valueForKey:@"comicPath"];
    numOfPage =   [comic valueForKey:@"totalPage"];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    size = CGSizeMake(screenWidth, screenHeight);


    scrollView.pagingEnabled = YES;
    
    [scrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    scrollView.contentSize = CGSizeMake([numOfPage intValue] * screenWidth, screenHeight - 60);
    [scrollView setMaximumZoomScale:4.0f];
    [scrollView setMaximumZoomScale:1.0f];
    [scrollView setClipsToBounds:YES];
    [self initImage];


}

-(void)initImage{
        for (int i = 0; i < 2; i++) {
        CGFloat xOrigin = i * screenWidth;
        UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.jpg",[LocalManager createDirectoryComic:comicPath], i + 1]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,0,screenWidth,screenHeight -60)];
        imageView.tag = (NSInteger)i;
        [imageView setImage:[self imageWithImage:image]];
            pageIndex.text = [NSString stringWithFormat:@"1/%d", [numOfPage intValue]];
        [imageArray addObject:imageView];
        [scrollView addSubview:imageView];
    }

}
- (UIImage *)imageWithImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
-(void) loadImage{
    
    CGPoint offSet = scrollView.contentOffset;
    CGFloat x = offSet.x;
    position = [[NSNumber numberWithFloat:x/screenWidth] intValue];
    CGFloat xOrigin = (position + 1) * screenWidth;
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.jpg", [LocalManager createDirectoryComic:comicPath], position + 1]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin,0,screenWidth,screenHeight - 60)];
    imageView.tag = (NSInteger)(position +1);
    [imageView setImage:[self imageWithImage:image]];
    [imageArray addObject:imageView];
    [scrollView addSubview:imageView];
    pageIndex.text = [NSString stringWithFormat:@"%d/%d",position+1, [numOfPage intValue]];

    NSLog(@"position page: %d",position );
    
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [imageArray objectAtIndex:(NSInteger)(position - 1)];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrolled");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImage];

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

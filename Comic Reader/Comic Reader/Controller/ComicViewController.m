//
//  ComicViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicViewController.h"
#import "LocalManager.h"
#import "AsyncImageView.h"
#import "ComicOverViewController.h"
#import "Header.h"

@interface ComicViewController ()

@end

@implementation ComicViewController
@synthesize mScrollView;
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
    [self loadImageAtIndex:0];
    [self loadImageAtIndex:1];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutView];
    
}
-(void)initDataComic{
    
#warning don`t execute value DB at controller
    comicPath = [comic valueForKey:COMIC_PATH_TITLE];
    numOfPage =   [comic valueForKey:TOTAL_PAGE];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    size = CGSizeMake(screenWidth, screenHeight);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    mScrollView.pagingEnabled = YES;
    mScrollView.delegate = self;
    [mScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    mScrollView.contentSize = CGSizeMake([numOfPage intValue] * screenWidth, 0);
    [mScrollView setMaximumZoomScale:4.0f];
    [mScrollView setMaximumZoomScale:1.0f];
    [mScrollView setClipsToBounds:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDoubleTap:)];
    [tap setNumberOfTapsRequired:2];
    [mScrollView addGestureRecognizer:tap];
    
}

-(void)actionDoubleTap:(UILongPressGestureRecognizer *)press{
    [self performSegueWithIdentifier:SEGUE_SHOW_COMIC_OVER_VIEW sender:self];
    
}

- (UIImage *)imageWithImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
-(void) loadImageAtCurrentIndex:(NSInteger)index{
    [self loadImageAtIndex:(int)(index-1)];
    [self loadImageAtIndex:(int)index];
    [self loadImageAtIndex:(int)(index+1)];
    
    NSLog(@"position page: %d",position);
    
}
-(NSInteger) caculatorPosition{
    CGPoint offSet = mScrollView.contentOffset;
    CGFloat x = offSet.x;
    position = [[NSNumber numberWithFloat:x/screenWidth] intValue];
    return (NSInteger)position;
}

-(void)loadImageAtIndex:(int) i{
    UIImageView *mImage = (UIImageView *)[self.view viewWithTag:(NSInteger)(i+1)];
    if(mImage == nil){
        
        CGFloat xOrigin = i * screenWidth;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
#warning execute common task
            UIImage *image = [self imageWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.jpg", [LocalManager getDirectoryComic:comicPath], i + 1]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,screenWidth,mScrollView.frame.size.height)];
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(xOrigin,0,screenWidth,screenHeight - 60)];
                subScrollView.minimumZoomScale = 1.0f;
                subScrollView.maximumZoomScale = 2.0f;
                subScrollView.zoomScale = 1.0f;
                subScrollView.contentSize = CGSizeMake(screenWidth, screenHeight - 60);
                subScrollView.delegate = self;
                subScrollView.showsHorizontalScrollIndicator = NO;
                subScrollView.showsVerticalScrollIndicator = NO;
                imageView.tag = (NSInteger)(i +1);
                [imageView setImage:image];
                [imageArray addObject:imageView];
                [subScrollView addSubview:imageView];
                [mScrollView addSubview:subScrollView];
            });
            
        });
    }
    pageIndex.text = [NSString stringWithFormat:@"%d/%d",i, [numOfPage intValue]];
    
}
-(void)jumpToPage:(int)i{
    [self loadImageAtCurrentIndex:(NSInteger)i];
    [mScrollView setContentOffset:CGPointMake(i * screenWidth, 0)];
}
-(void)removeImageAtIndex: (int) i{
    UIImageView *mImage = (UIImageView *)[self.view viewWithTag:(NSInteger)(i+1)];
    [mImage removeFromSuperview];
    mImage = nil;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:position + 1];
    ;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"scrolled");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImageAtCurrentIndex:[self caculatorPosition]];
}
-(void)customNavigationBar
{
    [super customNavigationBar];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SEGUE_SHOW_COMIC_OVER_VIEW]) {
        ComicOverViewController *overViewController = segue.destinationViewController;
        overViewController.comic = comic;
        overViewController.comicViewController = self;
        [ComicViewController setPresentationStyleForSelfController:self presentingController:overViewController];
        
        
    }
    
}
+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
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

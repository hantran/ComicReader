//
//  ComicViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicViewController.h"
#import "LocalManager.h"
#import "ComicOverViewController.h"
#import "Header.h"
#import "CommonTask.h"
#import "ComicReaderDatabase.h"

@interface ComicViewController ()
@property (strong, nonatomic) CommonTask *common;
@property (strong, nonatomic) ComicReaderDatabase *database;
@property (strong, nonatomic) NSOperationQueue *mainQueue;

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
@synthesize common;
@synthesize currentReaded;
@synthesize database;
@synthesize mainQueue;
@synthesize backArrow;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.hasBack = YES;
//    self.titleNav.text = titleLabel;
    [self initDataComic];
    [self initLoadComicAtIndex];
}
-(void)viewWillAppear:(BOOL)animated{
    [self setConstraint];
}
-(void)setConstraint{
//    [self.customNav setAlpha:0.6f];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.customNav
//                              attribute:NSLayoutAttributeTop
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeTop
//                              multiplier:1.0
//                              constant:20.0]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.customNav
//                              attribute:NSLayoutAttributeRight
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeRight
//                              multiplier:1.0
//                              constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.customNav
//                              attribute:NSLayoutAttributeLeft
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeLeft
//                              multiplier:1.0
//                              constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.customNav
//                              attribute:NSLayoutAttributeBottom
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeBottom
//                              multiplier:1.0
//                              constant:0.0]];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.customNav
//                              attribute:NSLayoutAttributeHeight
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:nil
//                              attribute:NSLayoutAttributeNotAnAttribute
//                              multiplier:1.0
//                              constant:60.0]];
//    
//    
//    [self.view updateConstraints];

}
-(void)initDataComic{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    size = CGSizeMake(screenWidth, screenHeight);
    [backArrow setUserInteractionEnabled:YES];
    [backArrow setHidden:YES];
    
    common = [[CommonTask alloc] init];
    database = [[ComicReaderDatabase alloc] init];
    mainQueue = [[NSOperationQueue alloc] init];
    
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDoubleTap:)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipe:)];
    [swipe setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [tap setNumberOfTapsRequired:1];
    [doubleTap setNumberOfTapsRequired:2];
    [mScrollView addGestureRecognizer:tap];
    [mScrollView addGestureRecognizer:doubleTap];
    [mScrollView addGestureRecognizer:swipe];
    
}

-(void)initLoadComicAtIndex{
    [self jumpToPage:[currentReaded intValue]];
   }
-(void)actionTap:(UITapGestureRecognizer *)tap{
    if(backArrow.isHidden == YES){
    [backArrow setHidden:NO];
    backArrow.alpha = 0.0f;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        backArrow.alpha = 1.0f;
    } completion:^(BOOL finished) {

    }];
    } else{
        backArrow.alpha = 1.0f;
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            backArrow.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [backArrow setHidden:YES];
        }];

    }
}
-(void)actionDoubleTap:(UILongPressGestureRecognizer *)press{
    [self performSegueWithIdentifier:SEGUE_SHOW_COMIC_OVER_VIEW sender:self];
    
}
-(void)actionSwipe:(UISwipeGestureRecognizer *)swipe{
    [mainQueue cancelAllOperations];
    [self.navigationController popViewControllerAnimated:YES];

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
    [database saveCurrentReaded:comic position:[NSNumber numberWithInteger:index]];
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
            UIImage *image = [self imageWithImage:
                              [common loadImageFromLocal:[LocalManager getDirectoryComic:comicPath] index:i]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,screenWidth,mScrollView.frame.size.height)];
                UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(xOrigin,0,screenWidth,screenHeight)];
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
                 NSLog(@"Loading %@",[NSString stringWithFormat:@"%d/%d",i, [numOfPage intValue]]);
            });
            
        });
    }
    pageIndex.text = [NSString stringWithFormat:@"%d/%d",i, [numOfPage intValue]];
   
    
}
-(void)jumpToPage:(int)i{
    [self loadImageAtCurrentIndex:(NSInteger)i];
    [mScrollView setContentOffset:CGPointMake(i * screenWidth, 0)];
}

- (IBAction)actionBack:(id)sender {
    [mainQueue cancelAllOperations];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)removeImageAtIndex: (int) i{
    UIImageView *mImage = (UIImageView *)[self.view viewWithTag:(NSInteger)(i+1)];
    [mImage removeFromSuperview];
    mImage = nil;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:[self caculatorPosition] + 1];
    ;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"scrolled");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImageAtCurrentIndex:[self caculatorPosition]];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SEGUE_SHOW_COMIC_OVER_VIEW]) {
        ComicOverViewController *overViewController = segue.destinationViewController;
        overViewController.comic = comic;
        overViewController.comicViewController = self;
        overViewController.position = (int)[self caculatorPosition];
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

//
//  ComicOverViewController.m
//  Comic Reader
//
//  Created by administrator on 3/2/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicOverViewController.h"
#import "ComicOverViewDialog.h"
#import "ComicOverViewCell.h"
#import "LocalManager.h"
@interface ComicOverViewController ()

@end

@implementation ComicOverViewController
@synthesize comicOverViewDialog;
@synthesize mComicScrollView;
@synthesize mComicTitle;
@synthesize comic;
@synthesize numOfPage;
@synthesize comicPath;
@synthesize screenWidth;
@synthesize screenHeight;
@synthesize size;
@synthesize imageArray;
@synthesize position;
@synthesize comicViewController;
@synthesize checkLoadComplete;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComicOverViewDialog];
    
}

-(void)initComicOverViewDialog{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ComicOverViewDialog"
                                                      owner:self
                                                    options:nil];
    comicOverViewDialog = [nibViews objectAtIndex:0];
    comicOverViewDialog.translatesAutoresizingMaskIntoConstraints = NO;
    comicOverViewDialog.layer.borderColor = [UIColor whiteColor].CGColor;
    comicOverViewDialog.layer.borderWidth = 5.0;
    comicOverViewDialog.layer.cornerRadius = 5.0;
    comicOverViewDialog.layer.masksToBounds = YES;
    comicPath = [comic valueForKey:@"comicPath"];
    numOfPage =   [comic valueForKey:@"totalPage"];
    size = CGSizeMake(80, 80);
    checkLoadComplete = YES;
    mComicScrollView.delegate = self;
    
    [self.view addSubview:comicOverViewDialog];
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [tap setNumberOfTapsRequired:1];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    mComicScrollView.contentSize = CGSizeMake([numOfPage intValue] * 80.0, 0.0);
//    [self initFirstSubComic];
}

-(void)initSubComic:(int)i{
//    ComicOverViewCell *comicCell = (ComicOverViewCell *)[self.view viewWithTag:(NSInteger)(i+1)];
//    if(comicCell == nil){
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ComicOverViewCell"
                                                          owner:self
                                                        options:nil];
        ComicOverViewCell *comicCell = [nibViews objectAtIndex:0];
        UITapGestureRecognizer *tapSubView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapSubView:)];
        [tapSubView setNumberOfTapsRequired:1];
        tapSubView.delegate = self;
        CGFloat xOrigin = i * 80.0 + 10;
            UIImage *image = [self imageWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.jpg", [LocalManager getDirectoryComic:comicPath], i + 1]]];
            NSLog(@"Start async %d",i +1);
            dispatch_async(dispatch_get_main_queue(), ^{
                comicCell.comicImage.frame = CGRectMake(xOrigin,0, 60.0,mComicScrollView.frame.size.height - 10);
                comicCell.frame = comicCell.comicImage.frame;
                comicCell.tag = (NSInteger)(i +1);
                [comicCell addGestureRecognizer:tapSubView];
                [comicCell setUserInteractionEnabled:YES];
                comicCell.comicIndex.text = [NSString stringWithFormat:@"%d",i+1];
                comicCell.comicImage.image = image;
                [mComicScrollView addSubview:comicCell];
                NSLog(@"Finish async %d",i +1);
            });
    
}

-(void)actionTapSubView:(UITapGestureRecognizer *)tap{
    dispatch_async(dispatch_get_main_queue(), ^{
        [comicViewController jumpToPage:(int)(tap.view.tag - 1)];
    });
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    
    dispatch_queue_t myQueue = dispatch_queue_create("MyQueue", DISPATCH_QUEUE_SERIAL);
    for(int i = 0;i< [numOfPage intValue];i++){
        dispatch_async(myQueue, ^{
            [self initSubComic:i];
        }) ;
    }
    
}
- (UIImage *)imageWithImage:(UIImage *)image {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, 80, 80)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Finish scroll");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"Start scroll");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"X offset: %f", mComicScrollView.contentOffset.x);
//    [self updateSubComicWithScroll];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //    if([touch.view isDescendantOfView:comicOverViewDialog])
    //        return NO;
    //    else
    return YES;
}
-(void)actionTap:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [self initConstraint];
}

-(void) initConstraintSubComic:(ComicOverViewCell *)comicCell{
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicCell
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:mComicScrollView
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicCell
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:mComicScrollView
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicCell
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:mComicScrollView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1.0
                              constant:0.0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicCell
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:70]];
    
    
    [self.view updateConstraints];
    
}
-(void) initConstraint{
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicOverViewDialog
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicOverViewDialog
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicOverViewDialog
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:- 10.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicOverViewDialog
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:comicOverViewDialog
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:150]];
    
    
    [self.view updateConstraints];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

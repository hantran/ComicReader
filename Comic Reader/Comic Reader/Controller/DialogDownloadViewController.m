//
//  DialogDownloadViewController.m
//  Comic Reader
//
//  Created by administrator on 2/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "DialogDownloadViewController.h"
#import "ComicReaderService.h"
#import <UIKit/UIKit.h>
#import "LocalManager.h"
#import "ComicReaderDatabase.h"
#import "Header.h"
#import "AlertViewManager.h"

@interface DialogDownloadViewController ()

@end

@implementation DialogDownloadViewController
@synthesize comic;
@synthesize position;
@synthesize progressDialog;
@synthesize comicTitle;
@synthesize totalPage;
@synthesize progressDowload;
@synthesize per;
@synthesize percent;
@synthesize collectionView;
@synthesize cateId;
@synthesize database;
@synthesize delegate;
typedef void (^test)(UIProgressView *progressDowload);
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:NIB_PROGRESS_VIEW_DIALOG
                                                      owner:self
                                                    options:nil];
    progressDialog = [nibViews objectAtIndex:0];
    progressDialog.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:progressDialog];
    self.view.opaque = YES;
    self.view.backgroundColor = [UIColor clearColor];
    progressDialog.layer.borderColor = [UIColor whiteColor].CGColor;
    progressDialog.layer.borderWidth = 5.0;
    progressDialog.layer.cornerRadius = 5.0;
    progressDialog.layer.masksToBounds = YES;
    progressDowload.progress = 0.0;
    per = 0.0;
    database = [[ComicReaderDatabase alloc] init];
    comicTitle.text = [database getComicTitle:comic];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    [tap setNumberOfTapsRequired:1];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    [database setIsDownloading:comic status:YES];
    [collectionView reloadData];
    [self startDownloadService];

}
-(void)startDownloadService{
    NSString *path = [LocalManager getDirectoryComic:[database getComicPath:comic]];
    ComicReaderService *service = [[ComicReaderService alloc] init];
    [service downloadComicImage:[NSString stringWithFormat:COMIC_DOWNLOAD_API,(int)cateId,[[database getComicId:comic] intValue]] totalPage:[database getNumOfPage:comic] path:path dialogDownload:self nsObject:comic];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
        if([touch.view isDescendantOfView:progressDialog])
            return NO;
        else
    return YES;
}

-(void)actionTap:(UITapGestureRecognizer *)tap{
      [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)onDownLoadFinish{
    [ComicReaderDatabase updateDataComic:comic];
    [collectionView reloadData];
    delegate.checkIsDownloading = NO;
    [database setIsDownloading:comic status:NO];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:- 10.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:160]];
    
    
    [self.view updateConstraints];
    
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

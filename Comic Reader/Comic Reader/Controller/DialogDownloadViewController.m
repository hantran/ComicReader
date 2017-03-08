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
    comicTitle.text = [comic valueForKey:Title];
    NSString *path = [LocalManager getDirectoryComic:[comic valueForKey:COMIC_PATH_TITLE]];
    [ComicReaderService downloadComicImage:COMIC_DOWNLOAD_API totalPage:[comic valueForKey:TOTAL_PAGE] path:path dialogDownload:self nsObject:comic];
}

-(void)onDownLoadFinish{
    [ComicReaderDatabase updateDataComic:comic];
    [collectionView reloadData];
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

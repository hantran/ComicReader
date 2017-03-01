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
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ProgressViewDialog"
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
    comicTitle.text = [[comic objectAtIndex:position] valueForKey:@"title"];
    NSString *path = [LocalManager createDirectoryComic:[[comic objectAtIndex:position] valueForKey:@"comicPath"]];
    [ComicReaderService downloadComicImage:@"http://172.20.23.10/ComicReader/images/1/1/1/" totalPage:[[comic objectAtIndex:position] valueForKey:@"totalPage"] path:path dialogDownload:self dataObject:[comic objectAtIndex:position] collectionView:collectionView];
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
                              constant:- 20.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:20.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:progressDialog
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:150]];
    
    
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

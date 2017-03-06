//
//  DialogDownloadViewController.h
//  Comic Reader
//
//  Created by administrator on 2/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewDialog.h"
#import "AppDelegate.h"

@interface DialogDownloadViewController : UIViewController
@property(strong, nonatomic) NSManagedObject *comic;
@property(strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) float per;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UIProgressView *progressDowload;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UILabel *totalPage;
@property (strong, nonatomic)  ProgressViewDialog *progressDialog;
-(void)onDownLoadFinish;
@end

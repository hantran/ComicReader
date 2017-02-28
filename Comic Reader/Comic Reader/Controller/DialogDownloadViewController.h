//
//  DialogDownloadViewController.h
//  Comic Reader
//
//  Created by administrator on 2/24/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewDialog.h"

@interface DialogDownloadViewController : UIViewController
@property(strong, nonatomic) NSMutableArray *comic;
@property(strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, assign) int position;
@property (nonatomic, assign) float per;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UIProgressView *progressDowload;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UILabel *totalPage;
@property (strong, nonatomic)  ProgressViewDialog *progressDialog;
@end

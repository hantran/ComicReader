//
//  SubCategoryControllerViewController.h
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"
@interface SubCategoryController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic) NSInteger cateId;
@property (nonatomic) NSInteger cateCount;
@property (strong,nonatomic) NSString *titleLabel;
@property (nonatomic, assign) NSInteger position;


-(void)removeFavComic:(NSInteger)index;
-(void)startDownloadComic;
-(void)checkUpdateComic;
@end

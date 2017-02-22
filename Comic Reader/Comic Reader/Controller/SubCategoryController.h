//
//  SubCategoryControllerViewController.h
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface SubCategoryController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mCollectionView;
@property (nonatomic) int cateId;
@property (strong,nonatomic) NSString *titleLabel;
@end

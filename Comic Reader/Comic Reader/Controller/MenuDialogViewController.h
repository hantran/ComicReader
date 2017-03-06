//
//  MenuDialogViewController.h
//  Comic Reader
//
//  Created by administrator on 3/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewDialog.h"
#import "AppDelegate.h"
#import "SubCategoryController.h"

@interface MenuDialogViewController : UIViewController <UIGestureRecognizerDelegate>
@property(strong, nonatomic) MenuViewDialog *menuDialogView;
@property (strong, nonatomic) SubCategoryController *subCategory;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;
@property (weak, nonatomic) IBOutlet UILabel *addFavLabel;
@property (strong, nonatomic) NSManagedObject *comic;
@property(strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSInteger position;
@property (nonatomic) BOOL isFavComicView;


@end

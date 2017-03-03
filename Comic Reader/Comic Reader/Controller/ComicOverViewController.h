//
//  ComicOverViewController.h
//  Comic Reader
//
//  Created by administrator on 3/2/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicOverViewDialog.h"
#import "AppDelegate.h"
#import "ComicViewController.h"
@interface ComicOverViewController : UIViewController <UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mComicScrollView;
@property (weak, nonatomic) IBOutlet UILabel *mComicTitle;
@property(strong, nonatomic) ComicOverViewDialog *comicOverViewDialog;
@property(strong, nonatomic) NSManagedObject *comic;
@property (strong,nonatomic) NSNumber *numOfPage;
@property (strong,nonatomic) NSString *comicPath;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGSize size;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (nonatomic) int position;
@property (nonatomic) BOOL checkLoadComplete;
@property (strong, nonatomic) ComicViewController *comicViewController;

@end

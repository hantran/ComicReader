//
//  ComicViewController.h
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"


@interface ComicViewController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (weak, nonatomic) IBOutlet UILabel *pageIndex;
@property (weak, nonatomic) IBOutlet UIButton *backArrow;
@property (weak, nonatomic) UILabel *labelPage;
@property (strong,nonatomic) NSString *titleLabel;
@property (strong, nonatomic) NSManagedObject *comic;
@property (strong,nonatomic) NSNumber *numOfPage;
@property (strong,nonatomic) NSNumber *currentReaded;
@property (strong,nonatomic) NSString *comicPath;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGSize size;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (nonatomic) int position;
-(void)jumpToPage:(int)i;
- (IBAction)actionBack:(id)sender;


@end

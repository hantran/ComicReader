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

@interface ComicViewController : BaseViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageComic;
@property (weak, nonatomic) UILabel *labelPage;
@property (strong,nonatomic) NSString *titleLabel;
@property (strong, nonatomic) NSManagedObject *comic;

@end

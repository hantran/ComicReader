//
//  SubCategoryCell.h
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicReaderDatabase.h"
#import "SubCategoryController.h"

@interface SubCategoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCell;
@property (weak, nonatomic) IBOutlet UILabel *comicTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinDownload;
@property (strong, nonatomic) ComicReaderDatabase *database;
@property (strong, nonatomic) SubCategoryController *viewController;
@property (nonatomic, assign) NSInteger position;


-(UIImage *)resizeBackgroundImage:(UIImage *)image;
-(void)initCell:(NSManagedObject *)comic;

@end

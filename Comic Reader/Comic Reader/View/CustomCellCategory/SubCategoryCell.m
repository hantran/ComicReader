//
//  SubCategoryCell.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SubCategoryCell.h"
#import "Header.h"
#import "LocalManager.h"
#import "ComicReaderDatabase.h"

@implementation SubCategoryCell
@synthesize comicTitle;
@synthesize imageViewCell;
@synthesize imageTitle;
@synthesize database;
@synthesize position;
@synthesize viewController;
- (void)awakeFromNib {
    [super awakeFromNib];
    database = [[ComicReaderDatabase alloc] init];
}
-(void)prepareForReuse{
    [super prepareForReuse];
    self.imageViewCell.image = nil;

}
-(void)initCell:(NSManagedObject *)comic{
    BOOL isDownloaded = [database checkIsDownloaded:comic];
    BOOL isMyComic = [database checkIsMyComic:comic];
    NSString *path = [LocalManager getDirectoryComic:[database getComicPath:comic]];
    self.comicTitle.text = [database getComicTitle:comic];
    NSLog(@"Comic path: %@",[database getComicPath:comic]);
    dispatch_queue_t myQueue = dispatch_queue_create("MyQueue", DISPATCH_QUEUE_SERIAL);
    if(!isDownloaded){
        self.imageViewCell.image = [UIImage imageNamed:ICON_COMIC];
        if(isMyComic)
            self.imageTitle.image = [UIImage imageNamed:ICON_STAR];
        else
            self.imageTitle.image = [UIImage imageNamed:ICON_NEW];
    }
    else{
        if(isMyComic)
            self.imageTitle.image = [UIImage imageNamed:ICON_STAR];
        else
            self.imageTitle.image = nil;
        dispatch_async(myQueue, ^{
            UIImage *image = [self resizeBackgroundImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/1.jpg",path]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageViewCell.image = image;
            });
        });
        
        
        //            cell.imageViewCell.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/1.jpg",path]];
        NSLog(@"Image background path name %@",[database getComicTitle:comic]);
        NSLog(@"Image background path %@",path);
        
    }
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressComic:)];
    [longPress setMinimumPressDuration:0.5];
    [self addGestureRecognizer:longPress];

}
-(void)longPressComic:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateEnded) {
    }
    else if (longPress.state == UIGestureRecognizerStateBegan){
        viewController.position = position;
        [viewController performSegueWithIdentifier:SEGUE_ON_CLICK_MENU sender:viewController];
    }
    
}

-(UIImage *)resizeBackgroundImage:(UIImage *)image{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat scale = width/height;
    UIGraphicsBeginImageContext(CGSizeMake(80 * scale, 80));
    [image drawInRect:CGRectMake(0, 0, 80 * scale, 80)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
    
}


@end

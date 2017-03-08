//
//  MenuDialogViewController.m
//  Comic Reader
//
//  Created by administrator on 3/6/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MenuDialogViewController.h"
#import "ComicReaderDatabase.h"
#import "Header.h"

@interface MenuDialogViewController ()

@end

@implementation MenuDialogViewController
@synthesize menuDialogView;
@synthesize downloadLabel;
@synthesize addFavLabel;
@synthesize comic;
@synthesize collectionView;
@synthesize position;
@synthesize isFavComicView;
@synthesize subCategory;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMenuDialogView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initConstraint];
}

-(void)initMenuDialogView{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:NIB_MENU_VIEW_DIALOG
                                                      owner:self
                                                    options:nil];
    menuDialogView = [nibViews objectAtIndex:0];
    menuDialogView.translatesAutoresizingMaskIntoConstraints = NO;
    menuDialogView.layer.borderColor = [UIColor whiteColor].CGColor;
    menuDialogView.layer.borderWidth = 5.0;
    menuDialogView.layer.cornerRadius = 5.0;
    menuDialogView.layer.masksToBounds = YES;
    downloadLabel.tag = 0;
    addFavLabel.tag = 1;
    [self.view addSubview:menuDialogView];
    self.view.opaque = YES;
    [self.view setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapAddFav = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAddFav:)];
    UITapGestureRecognizer *tapDownload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDownload:)];
    UITapGestureRecognizer *tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionDismiss:)];
    
    [tapAddFav setNumberOfTapsRequired:1];
    [tapDownload setNumberOfTapsRequired:1];
    [tapDismiss setNumberOfTapsRequired:1];
    
    [self.view addGestureRecognizer:tapDismiss];
    [downloadLabel addGestureRecognizer:tapDownload];
    [addFavLabel addGestureRecognizer:tapAddFav];
    [addFavLabel setUserInteractionEnabled:YES];
    [downloadLabel setUserInteractionEnabled:YES];
    BOOL isMyComic = [[comic valueForKey:IS_MYCOMIC] boolValue];
    if(isMyComic)
        addFavLabel.text = REMOVE_FAV_COMIC;
    else
        addFavLabel.text = ADD_FAV_COMIC;
}
-(void)initConstraint{
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:menuDialogView
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1.0
                              constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:menuDialogView
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1.0
                              constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:menuDialogView
                              attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTrailing
                              multiplier:1.0
                              constant:- 10.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:menuDialogView
                              attribute:NSLayoutAttributeLeading
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeLeading
                              multiplier:1.0
                              constant:10.0]];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:menuDialogView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:1.0
                              constant:150]];
    
    
    [self.view updateConstraints];
    
}

-(void)actionAddFav:(UITapGestureRecognizer *)tap{
    NSLog(@"AddFav");
    if(![[comic valueForKey:IS_MYCOMIC] boolValue])
        [self addFavComic];
    else
        [self removeFavComic];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)actionDownload:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(![[comic valueForKey:IS_DOWNLOADED] boolValue])
        [subCategory startDownloadComic];
    
}

-(void)actionDismiss:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)addFavComic{
    [ComicReaderDatabase addFavComic:comic];
    [collectionView reloadData];
}
-(void)removeFavComic{
    [ComicReaderDatabase removeFavComic:comic];
    if(isFavComicView)
        [subCategory removeFavComic:position];
    [collectionView reloadData];
}
@end

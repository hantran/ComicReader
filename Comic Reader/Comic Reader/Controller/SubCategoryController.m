//
//  SubCategoryControllerViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SubCategoryController.h"
#import "SubCategoryCell.h"
#import "ComicViewController.h"
#import "ProgressViewDialog.h"
#import "SubCategoryController.h"
#import "AppDelegate.h"
#import "ComicReaderDatabase.h"
#import "ComicReaderService.h"
#import "DialogDownloadViewController.h"
#import "LocalManager.h"
#import "MenuDialogViewController.h"
#import "Header.h"



@interface SubCategoryController ()
@property(nonatomic,strong) NSArray *array;
@property(strong, nonatomic) NSMutableArray *comic;
@property (nonatomic, assign) NSInteger position;
@property (strong, nonatomic) NSManagedObject *currentComic;
@property (strong, nonnull) ComicReaderDatabase *database;


@end

@implementation SubCategoryController

@synthesize array;
@synthesize mCollectionView;
@synthesize comic;
@synthesize cateId;
@synthesize cateCount;
@synthesize titleLabel;
@synthesize position;
@synthesize currentComic;
@synthesize database;

-(void)viewWillAppear:(BOOL)animated{
    [self layoutView];
}
-(void)customNavigationBar
{
    [super customNavigationBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasBack  =  YES;
    database = [[ComicReaderDatabase alloc] init];
    [self.mCollectionView registerNib:[UINib nibWithNibName:NIB_SUB_CATEGORY_CELL bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:NIB_SUB_CATEGORY_CELL];
    self.titleNav.text = titleLabel;
    [self setPaddingCollectionView];
    if(cateId == (cateCount -1))
        [self loadFavComic];
    else
        comic = [database loadDataComicWithCategory:cateId];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
}

-(void) setPaddingCollectionView{
    mCollectionView.contentInset = UIEdgeInsetsMake(0, 16, 0, 16);
    
}
-(void)loadFavComic{
    comic = [database loadFavoriteComic];
}
-(void)removeFavComic:(NSInteger)index{
    [comic removeObjectAtIndex:index];
    [mCollectionView reloadData];
}
-(void)startDownloadComic{
    [self performSegueWithIdentifier:SEGUE_ON_CLICK_DOWNLOAD sender:self];
    
}
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [comic count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = NIB_SUB_CATEGORY_CELL;
    
    SubCategoryCell *cell = (SubCategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NIB_SUB_CATEGORY_CELL owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    //    cell.backgroundColor = [UIColor redColor];
    NSManagedObject *cmi = [comic objectAtIndex:indexPath.row];
    BOOL isDownloaded = [[cmi valueForKey:IS_DOWNLOADED] boolValue];
    BOOL isMyComic = [[cmi valueForKey:IS_MYCOMIC] boolValue];
    NSString *path = [LocalManager getDirectoryComic:[[comic objectAtIndex:indexPath.row] valueForKey:COMIC_PATH_TITLE]];
    cell.imageViewCell.image = [UIImage imageNamed:ICON_COMIC];
    cell.comicTitle.text = [cmi valueForKey:Title];
    NSLog(@"Comic path: %@",[cmi valueForKey:@"comicPath"]);
    if(!isDownloaded)
        if(isMyComic)
            cell.imageTitle.image = [UIImage imageNamed:ICON_STAR];
        else
            cell.imageTitle.image = [UIImage imageNamed:ICON_NEW];
        else{
            if(isMyComic)
                cell.imageTitle.image = [UIImage imageNamed:ICON_STAR];
            else
                cell.imageTitle.image = nil;
            cell.imageViewCell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/1.jpg",path]];
            
        }
    cell.tag = indexPath.row;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressComic:)];
    [longPress setMinimumPressDuration:0.5];
    [cell addGestureRecognizer:longPress];
    return cell;
}

-(void)longPressComic:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateEnded) {
    }
    else if (longPress.state == UIGestureRecognizerStateBegan){
        position = longPress.view.tag;
        [self performSegueWithIdentifier:SEGUE_ON_CLICK_MENU sender:self];
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    currentComic = [comic objectAtIndex:indexPath.row];
    titleLabel = [currentComic valueForKey:Title];
    position = indexPath.row;
    BOOL isDownloaded = [[currentComic valueForKey:IS_DOWNLOADED] boolValue];
    if(isDownloaded)
        [self performSegueWithIdentifier:SEGUE_ON_CLICK_COMIC sender:self];
    else
        [self performSegueWithIdentifier:SEGUE_ON_CLICK_DOWNLOAD sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SEGUE_ON_CLICK_COMIC]) {
        ComicViewController *comicViewController =segue.destinationViewController;
        comicViewController.titleLabel = titleLabel;
        comicViewController.comic = currentComic;
    }
    if ([segue.identifier isEqualToString:SEGUE_ON_CLICK_DOWNLOAD]) {
        DialogDownloadViewController *dialogViewController = segue.destinationViewController;
        [SubCategoryController setPresentationStyleForSelfController:self presentingController:dialogViewController];
        dialogViewController.comic = [comic objectAtIndex:position];
        dialogViewController.position = position;
        dialogViewController.collectionView = mCollectionView;
    }
    
    if ([segue.identifier isEqualToString:SEGUE_ON_CLICK_MENU]) {
        MenuDialogViewController *menuDialogViewController = segue.destinationViewController;
        [SubCategoryController setPresentationStyleForSelfController:self presentingController:menuDialogViewController];
        menuDialogViewController.subCategory = self;
        menuDialogViewController.position = position;
        menuDialogViewController.comic = [comic objectAtIndex:position];
        menuDialogViewController.collectionView = mCollectionView;
        if(cateId == (cateCount -1))
            menuDialogViewController.isFavComicView = YES;
        else
            menuDialogViewController.isFavComicView = NO;
        
    }
    
    
    
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

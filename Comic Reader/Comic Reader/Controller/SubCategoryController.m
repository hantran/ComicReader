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
@property (strong, nonatomic) NSManagedObject *currentComic;
@property (strong, nonnull) ComicReaderDatabase *database;
@property (strong, nonnull) ComicReaderService *fetchService;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



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
@synthesize fetchService;
@synthesize refreshControl;

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
    fetchService = [[ComicReaderService alloc] init];
    [self.mCollectionView registerNib:[UINib nibWithNibName:NIB_SUB_CATEGORY_CELL bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:NIB_SUB_CATEGORY_CELL];
    self.titleNav.text = titleLabel;
    [self setPaddingCollectionView];
    if(cateId == (cateCount -1))
        [self loadFavComic];
    else{
        comic = [database loadDataComicWithCategory:cateId];
    }
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(startRefresh) forControlEvents:UIControlEventValueChanged];
    [mCollectionView addSubview:refreshControl];
    mCollectionView.alwaysBounceVertical = YES;
}
-(void)startRefresh{
    if(cateId != (cateCount -1))
    [fetchService fetchComicData:[NSString stringWithFormat:COMIC_API,(int)(cateId +1)] categoryId:(int)(cateId +1) viewController:self checkUpdate:YES];
    [refreshControl endRefreshing];
}
-(void) checkUpdateComic{
    comic = [database loadDataComicWithCategory:cateId];
    [mCollectionView reloadData];
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
    NSManagedObject *cmi = [comic objectAtIndex:indexPath.row];
    cell.position = indexPath.row;
    cell.viewController = self;
    [cell initCell:cmi];
    return cell;
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
        comicViewController.comicPath = [database getComicPath:currentComic];
        comicViewController.numOfPage = [database getNumOfPage:currentComic];
        comicViewController.comic = currentComic;
    }
    if ([segue.identifier isEqualToString:SEGUE_ON_CLICK_DOWNLOAD]) {
        DialogDownloadViewController *dialogViewController = segue.destinationViewController;
        [SubCategoryController setPresentationStyleForSelfController:self presentingController:dialogViewController];
        dialogViewController.comic = [comic objectAtIndex:position];
        dialogViewController.position = [[database getComicId:[comic objectAtIndex:position]] integerValue];
        dialogViewController.cateId = [[database getComicCategoryId:[comic objectAtIndex:position]] integerValue];
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

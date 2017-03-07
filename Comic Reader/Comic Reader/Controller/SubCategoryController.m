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
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCell" bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:@"SubCategoryCell"];
    //    [self loadDataComic];
    self.titleNav.text = titleLabel;
    if(cateId == (cateCount -1))
        [self loadFavComic];
    else
        comic = [database loadDataComicWithCategory:cateId];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
}
-(void)loadFavComic{
    comic = [database loadFavoriteComic];
}
-(void)removeFavComic:(NSInteger)index{
    [comic removeObjectAtIndex:index];
    [mCollectionView reloadData];
}
-(void)startDownloadComic{
    [self performSegueWithIdentifier:@"onClickDownload" sender:self];
    
}
-(BOOL)loadDataComic{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idCategory == %d", cateId + 1]];
    self.comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([comic count]>0){
        [mCollectionView reloadData];
        return NO;
    }
    else
        return YES;
}

-(void) saveImageToSD{
    
}

- (void) viewDidAppear:(BOOL)animated{
    //    [mCollectionView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [comic count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SubCategoryCell";
    
    SubCategoryCell *cell = (SubCategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSManagedObject *cmi = [comic objectAtIndex:indexPath.row];
    BOOL isDownloaded = [[cmi valueForKey:@"isDownloaded"] boolValue];
    BOOL isMyComic = [[cmi valueForKey:@"isMyComic"] boolValue];
    NSString *path = [LocalManager getDirectoryComic:[[comic objectAtIndex:indexPath.row] valueForKey:@"comicPath"]];
    cell.imageViewCell.image = [UIImage imageNamed:@"comic.png"];
    cell.comicTitle.text = [cmi valueForKey:@"title"];
    NSLog(@"Comic path: %@",[cmi valueForKey:@"comicPath"]);
    if(!isDownloaded)
        if(isMyComic)
            cell.imageTitle.image = [UIImage imageNamed:@"star.png"];
        else
            cell.imageTitle.image = [UIImage imageNamed:@"new.png"];
        else{
            if(isMyComic)
                cell.imageTitle.image = [UIImage imageNamed:@"star.png"];
            else
                cell.imageTitle.image = nil;
            cell.imageViewCell.image = [self resizeBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/1.jpg",path]]];
        }
    cell.tag = indexPath.row;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressComic:)];
    [longPress setMinimumPressDuration:0.5];
    [cell addGestureRecognizer:longPress];
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

-(void)longPressComic:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        //Do Whatever You want on End of Gesture
    }
    else if (longPress.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        position = longPress.view.tag;
        [self performSegueWithIdentifier:@"onClickMenu" sender:self];
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    currentComic = [comic objectAtIndex:indexPath.row];
    titleLabel = [currentComic valueForKey:@"title"];
    position = indexPath.row;
    BOOL isDownloaded = [[currentComic valueForKey:@"isDownloaded"] boolValue];
    if(isDownloaded)
        [self performSegueWithIdentifier:@"onClickComic" sender:self];
    else
        [self performSegueWithIdentifier:@"onClickDownload" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"onClickComic"]) {
        ComicViewController *comicViewController =segue.destinationViewController;
        comicViewController.titleLabel = titleLabel;
        comicViewController.comic = currentComic;
    }
    if ([segue.identifier isEqualToString:@"onClickDownload"]) {
        DialogDownloadViewController *dialogViewController = segue.destinationViewController;
        [SubCategoryController setPresentationStyleForSelfController:self presentingController:dialogViewController];
        dialogViewController.comic = [comic objectAtIndex:position];
        dialogViewController.position = position;
        dialogViewController.collectionView = mCollectionView;
    }
    
    if ([segue.identifier isEqualToString:@"onClickMenu"]) {
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

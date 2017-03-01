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

@interface SubCategoryController ()
@property(nonatomic,strong) NSArray *array;
@property(strong, nonatomic) NSMutableArray *comic;
@property (nonatomic, assign) NSInteger position;
@property (strong, nonatomic) NSManagedObject *currentComic;


@end

@implementation SubCategoryController

@synthesize array;
@synthesize mCollectionView;
@synthesize comic;
@synthesize cateId;
@synthesize titleLabel;
@synthesize position;
@synthesize currentComic;

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
    ComicReaderDatabase *database = [[ComicReaderDatabase alloc] init];
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCell" bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:@"SubCategoryCell"];
//    [self loadDataComic];
    self.titleNav.text = titleLabel;
    comic = [database loadDataComicWithCategory:cateId];
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
}

-(BOOL)loadDataComic{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
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
    NSString *path = [LocalManager createDirectoryComic:[[comic objectAtIndex:position] valueForKey:@"comicPath"]];
    cell.imageViewCell.image = [UIImage imageNamed:@"comic.png"];
    cell.comicTitle.text = [cmi valueForKey:@"title"];
    NSLog(@"Comic path: %@",[cmi valueForKey:@"comicPath"]);
    if(!isDownloaded)
        cell.imageTitle.image = [UIImage imageNamed:@"new.png"];
    else{
        cell.imageTitle.image = nil;
        cell.imageViewCell.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/1.jpg",path]];
    }

    

    return cell;
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
        
        dialogViewController.comic = comic;
        dialogViewController.position = position;
        dialogViewController.collectionView = mCollectionView;
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

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
#import "ProgressView.h"
#import "SubCategoryController.h"
#import "AppDelegate.h"

@interface SubCategoryController ()
@property(nonatomic,strong) NSArray *array;
@property(strong, nonatomic) NSMutableArray *comic;
@end

@implementation SubCategoryController

@synthesize array;
@synthesize mCollectionView;
@synthesize comic;
@synthesize cateId;

-(void)viewWillAppear:(BOOL)animated{
    [self layoutView];
}
-(void)customNavigationBar
{
    [super customNavigationBar];
}
- (void)viewDidLoad {
    self.hasBack  =  YES;
    [super viewDidLoad];
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCell" bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:@"SubCategoryCell"];
    [self loadDataComic];
    
}

-(BOOL)loadDataComic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idCategory == %d", cateId + 1]];
    self.comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([comic count]>0){
        return NO;
        [mCollectionView reloadData];
    }
    else
        return YES;
}

- (void) viewDidAppear:(BOOL)animated{
    
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
    cell.imageViewCell.image = [UIImage imageNamed:@"comic.png"];
    cell.comicTitle.text = [cmi valueForKey:@"title"];
    if(indexPath.row == 0 || indexPath.row == 4)
        cell.imageTitle.image = [UIImage imageNamed:@"star.png"];
    if(indexPath.row == 1)
        cell.imageTitle.image = [UIImage imageNamed:@"new.png"];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        //        ProgressView *progress = [[ProgressView alloc] init];
        //        [self showViewController:progress sender:nil];
    }else
        [self performSegueWithIdentifier:@"onClickComic" sender:self];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"onClickComic"]) {
        ComicViewController *comicViewController =segue.destinationViewController;
        
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

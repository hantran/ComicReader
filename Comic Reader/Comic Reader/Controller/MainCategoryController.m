//
//  ViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MainCategoryController.h"
#import "MainCategoryCell.h"
#import "SubCategoryController.h"
#import "AppDelegate.h"
#import "ComicReaderService.h"


@interface MainCategoryController ()
@property(nonatomic,strong) NSArray *array;
@property(strong, nonatomic) NSMutableArray *category;
@property(strong, nonatomic) NSMutableArray *comic;
@property(nonatomic,assign) int cateId;

@end

@implementation MainCategoryController
@synthesize mTableView;
@synthesize array;
@synthesize context;
@synthesize category;
@synthesize comic;
@synthesize cateId;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasBack = NO;
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    context = delegate.persistentContainer.viewContext;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrowBack.png"] style:UIBarButtonItemStyleDone target:nil action:nil];
//    [backButtonItem setBackgroundImage:[UIImage imageNamed:@"arrowBack.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    self.navigationItem.backBarButtonItem = backButtonItem;
    
    }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutView];
}
-(void)viewDidAppear:(BOOL)animated{
    if([self loadDataCategory]){
        ComicReaderService *parseService = [[ComicReaderService alloc] init];
        [parseService fetchCategoryData:@"http://172.20.23.10/ComicReader/category/list/" main:self];
    }
}

-(BOOL)loadDataCategory{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    self.category = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([category count]>0){
        [self.mTableView reloadData];
        return NO;
    }
    else
        return YES;
}

-(BOOL)loadDataComic{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    self.comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([comic count]>0){
        return NO;
    }
    else
        return YES;
}

-(void)customNavigationBar
{
    [super customNavigationBar];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return category.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MainCategoryCell";
    
    MainCategoryCell *cell = (MainCategoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSManagedObject *cate = [category objectAtIndex:indexPath.row];
    cell.categoryName.text = [cate valueForKey:@"title"];
    cell.categoryName.highlightedTextColor = [UIColor orangeColor];
    cell.imageArrow.image = [UIImage imageNamed:@"arrow.png"];
    cell.imageArrow.highlightedImage = [UIImage imageNamed:@"arrowhighlight.png"];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cateId = indexPath.row;
    [self performSegueWithIdentifier:@"onClickTableCell" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"onClickTableCell"]) {
        SubCategoryController *subViewController =segue.destinationViewController;
        subViewController.cateId = cateId;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

@end

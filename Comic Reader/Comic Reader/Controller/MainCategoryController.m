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


@interface MainCategoryController ()
@property(nonatomic,strong) NSArray *array;
@property(strong, nonatomic) NSMutableArray *category;

@end

@implementation MainCategoryController
@synthesize mTableView;
@synthesize array;
@synthesize context;
@synthesize category;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasBack = NO;
    // Do any additional setup after loading the view, typically from a nib.
    array = @[@"Truyện chưởng", @"Truyện cười", @"Truyện ngắn", @"Truyện tình yêu", @"Truyện của tôi"];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutView];
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
    }

- (void)loadData{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    self.category = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.mTableView reloadData];
}

-(void)customNavigationBar
{
    [super customNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self performSegueWithIdentifier:@"onClickTableCell" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"onClickTableCell"]) {
        SubCategoryController *subViewController =segue.destinationViewController;
//        subViewController.sTitle = [[NSString alloc] initWithFormat:@"Hello"];
    }
}

@end

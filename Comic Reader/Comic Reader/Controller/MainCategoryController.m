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
#import "AddComicController.h";


@interface MainCategoryController ()
@property(nonatomic,strong) NSArray *array;
@property(strong) NSMutableArray *comic;
@property(strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation MainCategoryController
@synthesize mTableView;
@synthesize array;
@synthesize comic;
@synthesize context;
#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    array = @[@"Truyện chưởng", @"Truyện cười", @"Truyện ngắn", @"Truyện tình yêu", @"Truyện của tôi"];
}

-(void)viewDidAppear:(BOOL)animated{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    self.comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [comic count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MainCategoryCell";
    
    MainCategoryCell *cell = (MainCategoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSManagedObject *cm = [comic objectAtIndex:indexPath.row];
    cell.categoryName.text = [cm valueForKey:@"title"];
    cell.categoryName.highlightedTextColor = [UIColor redColor];
    cell.imageArrow.image = [UIImage imageNamed:@"ic_keyboard_arrow_right_3x.png"];
    cell.imageArrow.highlightedImage = [UIImage imageNamed:@"b.jpg"];
    cell.imageArrow.tag = indexPath.row;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEdit:)];
    [cell.imageArrow addGestureRecognizer:tap];
    cell.imageArrow.userInteractionEnabled = YES;
    
    return cell;
}

-(void) tapEdit:(UITapGestureRecognizer *)reconizer{
//    [self performSegueWithIdentifier:@"onClickUpdate" sender:self];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self performSegueWithIdentifier:@"onClickTableCell" sender:self];
    [self performSegueWithIdentifier:@"onClickUpdate" sender:self];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [context deleteObject:[comic objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [self.comic removeObjectAtIndex:indexPath.row];
        [self.mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"onClickTableCell"]) {
        SubCategoryController *subViewController =segue.destinationViewController;
    }
    if ([segue.identifier isEqualToString:@"onClickUpdate"]) {
        NSManagedObject *comicObject = [comic objectAtIndex:[mTableView indexPathForSelectedRow].row];
        AddComicController *addComicController =segue.destinationViewController;
        addComicController.comicObject = comicObject;
        
    }
}



@end

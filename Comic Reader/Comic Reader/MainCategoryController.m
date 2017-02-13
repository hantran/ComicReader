//
//  ViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MainCategoryController.h"
#import "MainCategoryCell.h"


@interface MainCategoryController ()
@property(nonatomic,strong) NSArray *array;

@end

@implementation MainCategoryController
@synthesize mTableView;
@synthesize array;

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    array = @[@"Truyện chưởng", @"Truyện cười", @"Truyện ngắn", @"Truyện tình yêu", @"Truyện của tôi"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MainCategoryCell";
    
    MainCategoryCell *cell = (MainCategoryCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.categoryName.text = [array objectAtIndex:indexPath.row];
    cell.imageArrow.image = [UIImage imageNamed:@"ic_keyboard_arrow_right_3x.png"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:[array objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [messageAlert show];

}
@end

//
//  SubCategoryControllerViewController.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "SubCategoryControllerViewController.h"
#import "SubCategoryCell.h"

@interface SubCategoryControllerViewController ()
@property(nonatomic,strong) NSArray *array;

@end

@implementation SubCategoryControllerViewController

@synthesize array;
- (void)viewDidLoad {
    [super viewDidLoad];
    array = @[@"Truyện chưởng", @"Truyện cười", @"Truyện ngắn", @"Truyện tình yêu", @"Truyện của tôi"];
    
    [self.mCollectionView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
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
    
    return [array count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SubCategoryCell";
    
    SubCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

//    SubCategoryCell *cell = (SubCategoryCell *)[collectionView dequeueReusableCellWithIdentifier:identifier];
//    
//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//    recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
    cell.comicTitle.text = [array objectAtIndex:indexPath.row];
    return cell;
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

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

@interface SubCategoryController ()
@property(nonatomic,strong) NSArray *array;

@end

@implementation SubCategoryController

@synthesize array;
@synthesize mCollectionView;

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
    array = @[@"Thần điêu đại hiệp", @"Anh hùng xạ điêu", @"Phong Vân", @"Thần điêu đại hiệp", @"Anh hùng xạ điêu", @"Phong Vân",@"Thần điêu đại hiệp", @"Anh hùng xạ điêu", @"Phong Vân"];
    // Do any additional setup after loading the view.
    [self.mCollectionView registerNib:[UINib nibWithNibName:@"SubCategoryCell" bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:@"SubCategoryCell"];

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
    
    SubCategoryCell *cell = (SubCategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.imageViewCell.image = [UIImage imageNamed:@"comic.png"];
    cell.comicTitle.text = [array objectAtIndex:indexPath.row];
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

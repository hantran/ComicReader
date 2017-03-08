//
//  MainCategoryCell.m
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MainCategoryCell.h"

@implementation MainCategoryCell
@synthesize categoryName;
@synthesize imageArrow;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, screenWidth, 1.5)];
    separatorLineView.backgroundColor = [UIColor colorWithRed:74.0/255.0f green:126.0/255.0f blue:187.0/255.0f alpha:1.0];
    [self.contentView addSubview:separatorLineView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

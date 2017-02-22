//
//  BaseViewController.h
//  Comic Reader
//
//  Created by Tran Han on 2/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationBar.h"

@interface BaseViewController : UIViewController
@property (strong, nonatomic)  CustomNavigationBar *customNav;
@property (nonatomic,assign) BOOL hasBack;
@property (nonatomic,strong) NSString *strTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
- (IBAction)actionBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleNav;

-(void)layoutView;
-(void)customNavigationBar;
@end

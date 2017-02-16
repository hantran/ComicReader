//
//  BaseViewController.h
//  Comic Reader
//
//  Created by Tran Han on 2/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic,assign) BOOL hasBack;
@property (nonatomic,strong) NSString *strTitle;

-(void)layoutView;
-(void)customNavigationBar;
@end

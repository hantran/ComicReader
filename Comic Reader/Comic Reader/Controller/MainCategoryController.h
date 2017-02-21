//
//  ViewController.h
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MainCategoryController : BaseViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) NSManagedObjectContext *context;

-(BOOL)loadDataCategory;
@end


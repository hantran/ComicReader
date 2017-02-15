//
//  AddComicController.h
//  Comic Reader
//
//  Created by administrator on 2/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddComicController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *comicName;
@property(strong) NSManagedObjectModel *comicObject;
- (IBAction)save:(id)sender;

@end

//
//  AddComicController.m
//  Comic Reader
//
//  Created by administrator on 2/15/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "AddComicController.h"
#import "AppDelegate.h"

@interface AddComicController ()
@end

@implementation AddComicController
@synthesize comicName;
@synthesize comicObject;
- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.comicObject){
        comicName.text = [comicObject valueForKey:@"title"];
    }
}


- (IBAction)save:(id)sender {
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    if(self.comicObject){
        [comicObject setValue:self.comicName.text forKey:@"title"];
    } else{
    
    NSManagedObject *newComic = [NSEntityDescription insertNewObjectForEntityForName:@"Comic" inManagedObjectContext:context];
    [newComic setValue:self.comicName.text forKey:@"title"];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

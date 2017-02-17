//
//  AFService.m
//  Comic Reader
//
//  Created by administrator on 2/16/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicReaderService.h"
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "MainCategoryController.h"
@implementation ComicReaderService
@synthesize category;
-(AFHTTPRequestOperationManager *)getRequestOperation{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return manager;
}
-(void)fetchCategoryData: (NSString *)stringURL{
    MainCategoryController *main = [[MainCategoryController alloc] init];
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager GET:stringURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        category = (NSDictionary *)responseObject;
        [self saveDataCategory:category];
//        [main loadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                                                              message:[error localizedDescription]
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"Ok"
                                                                                    otherButtonTitles:nil];
                                          [alertView show];

    }];
    
    }
-(void)fetchComicData: (NSString *)stringURL{
    
}

- (void)saveDataCategory:(NSDictionary *) comicCategory{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    for(int i = 0; i < [comicCategory count];i++){
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
        [newCategory setValue:[comicCategory valueForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:@"title"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    }

}
@end

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
@synthesize comic;
-(AFHTTPRequestOperationManager *)getRequestOperation{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return manager;
}
-(void)fetchCategoryData: (NSString *)stringURL main:(MainCategoryController *) mainCate{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager GET:stringURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        category = (NSDictionary *)responseObject;
        [self saveDataCategory:category];
        [mainCate loadDataCategory];
        if([self loadDataComic]){
            for(int i = 1;i <= [category count];i++)
                [self fetchComicData:[NSString stringWithFormat:@"http://172.20.23.10/ComicReader/category/list/%d/",i] categoryId:i];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Category"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
}
-(void)fetchComicData: (NSString *)stringURL categoryId:(int) cateId{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager GET:stringURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        comic = (NSDictionary *)responseObject;
        [self saveDataComic:comic categoryId:cateId];
        //        [mainCate loadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Comic"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
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

- (void)saveDataComic:(NSDictionary *) comicData categoryId:(int) cateId{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    for(int i = 0; i < [comicData count];i++){
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Comic" inManagedObjectContext:context];
        [newCategory setValue:[NSNumber numberWithInt:cateId] forKey:@"idCategory"];
        [newCategory setValue:[NSNumber numberWithInt:i+1] forKey:@"id"];
        [newCategory setValue:[comicData valueForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:@"title"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
}
-(BOOL)loadDataComic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    self.comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([comic count]>0){
        return NO;
    }
    else
        return YES;
}


@end

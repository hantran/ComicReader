//
//  ComicReaderDatabase.m
//  Comic Reader
//
//  Created by administrator on 2/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "ComicReaderDatabase.h"
#import "AppDelegate.h"
#import "MainCategoryController.h"
#import "LocalManager.h"

@implementation ComicReaderDatabase

+ (void)saveDataCategory:(NSDictionary *) comicCategory{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    for(int i = 0; i < [comicCategory count];i++){
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
        [newCategory setValue:[comicCategory valueForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:@"title"];
        [LocalManager createDirectoryComic:[NSString stringWithFormat:@"/%@",[NSString stringWithFormat:@"%d",i+1]]];
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
}

+ (void)saveDataComic:(NSDictionary *) comicData categoryId:(NSInteger) cateId{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    
    for(int i = 0; i < [comicData count];i++){
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Comic" inManagedObjectContext:context];
        [newCategory setValue:[NSNumber numberWithInteger:cateId] forKey:@"idCategory"];
        [newCategory setValue:[NSNumber numberWithInt:i+1] forKey:@"id"];
        NSDictionary *detailComic = [comicData valueForKey:[NSString stringWithFormat:@"%d",i+1]];
        [newCategory setValue:[detailComic valueForKey:@"1"] forKey:@"title"];
        [newCategory setValue:[detailComic valueForKey:@"2"] forKey:@"totalPage"];
        [newCategory setValue:[NSNumber numberWithBool:NO] forKey:@"isDownloaded"];
        [newCategory setValue:[NSNumber numberWithBool:NO] forKey:@"isMyComic"];
        [newCategory setValue:0 forKey:@"currentDownloaded"];
        [newCategory setValue:0 forKey:@"currentReaded"];
        NSString *directory = [NSString stringWithFormat:@"/%@/%d",[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:cateId]], i+1];
//        [newCategory setValue:[LocalManager createDirectoryComic:directory] forKey:@"comicPath"];
        [newCategory setValue:directory forKey:@"comicPath"];

        
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    
}

+(void)updateDataComic:(NSManagedObject *)comic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    [comic setValue:[NSNumber numberWithBool:YES] forKey:@"isDownloaded"];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

+(BOOL)checkDataComic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    NSMutableArray *comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([comic count]>0){
        return NO;
    }
    else
        return YES;
}

-(NSMutableArray *)loadDataComicWithCategory:(NSInteger)cateId{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Comic"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idCategory == %d", cateId + 1]];
    NSMutableArray *comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return comic;
}


+(NSMutableArray *)loadDataCategory:(MainCategoryController *)mMain{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    NSMutableArray *category = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];

    return category;
}


@end

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
#import "Header.h"
#import "SubCategoryController.h"

@implementation ComicReaderDatabase

+ (void)saveDataCategory:(NSDictionary *) comicCategory{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    for(int i = 0; i < [comicCategory count];i++){
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:CategoryDataName inManagedObjectContext:context];
        [newCategory setValue:[comicCategory valueForKey:[NSString stringWithFormat:@"%d",i+1]] forKey:Title];
        [LocalManager createDirectoryComic:[NSString stringWithFormat:@"/%@",[NSString stringWithFormat:@"%d",i+1]]];
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(CANT_SAVE, error, [error localizedDescription]);
        }
    }
    
}

+ (void)saveDataComic:(NSDictionary *) comicData categoryId:(NSInteger) cateId totalCurrentComic:(int)total {
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    for(int i = 0; i < [comicData count];i++){
        NSManagedObject *newCategory = [NSEntityDescription insertNewObjectForEntityForName:ComicDataName inManagedObjectContext:context];
        [newCategory setValue:[NSNumber numberWithInteger:cateId] forKey:ID_CATEGORY];
        [newCategory setValue:[NSNumber numberWithInt:i+1] forKey:ID];
        NSDictionary *detailComic = [comicData valueForKey:[NSString stringWithFormat:@"%d", total+i+1]];
        [newCategory setValue:[detailComic valueForKey:@"1"] forKey:Title];
        [newCategory setValue:[detailComic valueForKey:@"2"] forKey:TOTAL_PAGE];
        [newCategory setValue:[NSNumber numberWithBool:NO] forKey:IS_DOWNLOADED];
        [newCategory setValue:[NSNumber numberWithBool:NO] forKey:IS_MYCOMIC];
        [newCategory setValue:[NSNumber numberWithInt:1] forKey:CURRENT_DOWNLOADED];
        [newCategory setValue:0 forKey:CURRENT_READED];
        NSString *directory = [NSString stringWithFormat:@"/%@/%d",[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:cateId]], total+i+1];
        [newCategory setValue:directory forKey:COMIC_PATH_TITLE];
        [LocalManager createDirectoryComic:directory];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(CANT_SAVE, error, [error localizedDescription]);
        }
    }
    
}

-(void)updateDataComic:(NSMutableArray *)oldData newData:(NSDictionary *)newData cate:(NSInteger)cateId viewController:(id)viewController{
    NSMutableDictionary *update = [[NSMutableDictionary alloc] init];
    NSDictionary *updateComic = [[NSDictionary alloc] init];
//    if([oldData isEqualToDictionary:newData]){
//        NSLog(@"2 Dic is equal");
//    }
    if(oldData.count > newData.count){
        
    } else if (oldData.count < newData.count){
        for(int i = (int)oldData.count; i< (int)newData.count; i++){
            NSDictionary *newComic = [[NSDictionary alloc] init];
            newComic = [newData valueForKey:[NSString stringWithFormat:@"%d",i+1]];
            [update setObject:newComic forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        updateComic = [update mutableCopy];
        [ComicReaderDatabase saveDataComic:updateComic categoryId:cateId totalCurrentComic:(int)oldData.count];
        SubCategoryController *subcate = (SubCategoryController*)viewController;
        [subcate checkUpdateComic];

    }
}

+(void)updateDataComic:(NSManagedObject *)comic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    [comic setValue:[NSNumber numberWithBool:YES] forKey:IS_DOWNLOADED];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(CANT_SAVE, error, [error localizedDescription]);
    }
    
}

+(void)addFavComic:(NSManagedObject *)comic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    [comic setValue:[NSNumber numberWithBool:YES] forKey:IS_MYCOMIC];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(CANT_SAVE, error, [error localizedDescription]);
    }
    
}
+(void)removeFavComic:(NSManagedObject *)comic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    [comic setValue:[NSNumber numberWithBool:NO] forKey:IS_MYCOMIC];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(CANT_SAVE, error, [error localizedDescription]);
    }
    
}
+(void)updateCurrentDownloaded:(NSManagedObject *)comic current:(int) position{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    [comic setValue:[NSNumber numberWithInt:position] forKey:CURRENT_DOWNLOADED];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(CANT_SAVE, error, [error localizedDescription]);
    }
    
}


+(BOOL)checkDataComic{
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ComicDataName];
    NSMutableArray *comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if([comic count]>0){
        return NO;
    }
    else
        return YES;
}
-(NSMutableArray *)loadFavoriteComic{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ComicDataName];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:PREDICATE_IS_MYCOMIC, [NSNumber numberWithBool:YES]]];
    NSMutableArray *comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return comic;
}

-(NSMutableArray *)loadDataComicWithCategory:(NSInteger)cateId{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:ComicDataName];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:PREDICATE_ID_CATEGORY, cateId + 1]];
    NSMutableArray *comic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    return comic;
}


+(NSMutableArray *)loadDataCategory:(MainCategoryController *)mMain{
    AppDelegate *delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:CategoryDataName];
    NSMutableArray *category = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return category;
}

-(NSString *)getComicPath:(NSManagedObject *)comic{
    return [comic valueForKey:COMIC_PATH_TITLE];
}
-(NSString *)getComicTitle:(NSManagedObject *)comic{
    return [comic valueForKey:Title];
}
-(NSNumber *)getNumOfPage:(NSManagedObject *)comic{
    return [comic valueForKey:TOTAL_PAGE];
}
-(NSNumber *)getComicId:(NSManagedObject *)comic{
    return [comic valueForKey:ID];
}
-(NSNumber *)getComicCategoryId:(NSManagedObject *)comic{
    return [comic valueForKey:ID_CATEGORY];
}
-(NSNumber *)getCurrentDownloaded:(NSManagedObject *)comic{
    return [comic valueForKey:CURRENT_DOWNLOADED];
}
-(NSNumber *)getCurrentReaded:(NSManagedObject *)comic{
    return [comic valueForKey:CURRENT_READED];
}
-(void)saveCurrentReaded:(NSManagedObject *)comic position:(NSNumber *)position {
    AppDelegate *delegate =(AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    [comic setValue:position forKey:CURRENT_READED];
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(CANT_SAVE, error, [error localizedDescription]);
    }

}

-(BOOL)checkIsDownloaded:(NSManagedObject *)comic{
    return [[comic valueForKey:IS_DOWNLOADED] boolValue];
}
-(BOOL)checkIsMyComic:(NSManagedObject *)comic{
    return [[comic valueForKey:IS_MYCOMIC] boolValue];
}

@end

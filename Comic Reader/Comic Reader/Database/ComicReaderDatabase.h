//
//  ComicReaderDatabase.h
//  Comic Reader
//
//  Created by administrator on 2/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MainCategoryController.h"
#import "AppDelegate.h"

@interface ComicReaderDatabase : NSObject

+(BOOL)checkDataComic;
+ (void)saveDataCategory:(NSDictionary *) comicCategory;
+ (void)saveDataComic:(NSDictionary *) comicData categoryId:(NSInteger) cateId;
-(NSMutableArray *)loadDataComicWithCategory: (NSInteger)cateId;
+(NSMutableArray *)loadDataCategory:(MainCategoryController *)mMain;
-(NSMutableArray *)loadFavoriteComic;
+(void)updateDataComic:(NSManagedObject *)comic;
+(void)addFavComic:(NSManagedObject *)comic;
+(void)removeFavComic:(NSManagedObject *)comic;
+(void)updateCurrentDownloaded:(NSManagedObject *)comic current:(int) position;
@end

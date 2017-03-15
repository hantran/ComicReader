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
+ (void)saveDataComic:(NSDictionary *) comicData categoryId:(NSInteger) cateId totalCurrentComic:(int)total;
-(NSMutableArray *)loadDataComicWithCategory: (NSInteger)cateId;
+(NSMutableArray *)loadDataCategory:(MainCategoryController *)mMain;
-(NSMutableArray *)loadFavoriteComic;
+(void)updateDataComic:(NSManagedObject *)comic;
-(void)setIsDownloading:(NSManagedObject *)comic status:(BOOL) status;
+(void)addFavComic:(NSManagedObject *)comic;
+(void)removeFavComic:(NSManagedObject *)comic;
+(void)updateCurrentDownloaded:(NSManagedObject *)comic current:(int) position;
-(NSString *)getComicPath:(NSManagedObject *)comic;
-(NSString *)getComicTitle:(NSManagedObject *)comic;
-(NSNumber *)getNumOfPage:(NSManagedObject *)comic;
-(NSNumber *)getCurrentDownloaded:(NSManagedObject *)comic;
-(NSNumber *)getCurrentReaded:(NSManagedObject *)comic;
-(void)saveCurrentReaded:(NSManagedObject *)comic position:(NSNumber *)position;
-(BOOL)checkIsDownloaded:(NSManagedObject *)comic;
-(BOOL)checkIsDownloading:(NSManagedObject *)comic;
-(BOOL)checkIsMyComic:(NSManagedObject *)comic;
-(NSNumber *)getComicId:(NSManagedObject *)comic;
-(NSNumber *)getComicCategoryId:(NSManagedObject *)comic;
-(void)updateDataComic:(NSMutableArray *)oldData newData:(NSDictionary *)newData cate:(NSInteger)cateId viewController:(id)viewController;
@end

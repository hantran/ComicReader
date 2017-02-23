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

@interface ComicReaderDatabase : NSObject

+(BOOL)checkDataComic;
+ (void)saveDataCategory:(NSDictionary *) comicCategory;
+ (void)saveDataComic:(NSDictionary *) comicData categoryId:(int) cateId;
-(NSMutableArray *)loadDataComicWithCategory: (int)cateId;
+(NSMutableArray *)loadDataCategory:(MainCategoryController *)mMain;
@end

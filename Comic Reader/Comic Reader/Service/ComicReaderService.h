//
//  AFService.h
//  Comic Reader
//
//  Created by administrator on 2/16/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "MainCategoryController.h"
#import "SubCategoryController.h"
#import "DialogDownloadViewController.h"
#import "AppDelegate.h"


@interface ComicReaderService : NSObject
@property(strong, nonatomic) NSDictionary *category;
@property(strong, nonatomic) NSDictionary *comic;

-(void) fetchCategoryData: (NSString *)stringURL main: (MainCategoryController *) mainCate;
-(void) fetchComicData: (NSString *)stringURL categoryId:(int) cateId;
+(void)downloadComicImage:(NSString *)url totalPage:(NSNumber *)n path:(NSString *) folderPath dialogDownload:(DialogDownloadViewController *) dialogView dataObject:(NSManagedObject *)comic collectionView:(UICollectionView *)collectionView;

@end

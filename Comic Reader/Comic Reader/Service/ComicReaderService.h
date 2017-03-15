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
@property(strong, nonatomic) AFURLSessionManager *urlManager;


-(id)initService;
-(void) fetchCategoryData: (NSString *)stringURL main: (MainCategoryController *) mainCate;
-(void) fetchComicData: (NSString *)stringURL categoryId:(int) cateId viewController:(UIViewController *) viewController checkUpdate:(BOOL)isUpdate;
-(void)downloadComicImage:(NSString *)url totalPage:(NSNumber *)n path:(NSString *) folderPath dialogDownload:(DialogDownloadViewController *) dialogView nsObject:(NSManagedObject *)comic;
-(void)downloadAtIndex:(int)i total:(NSNumber *)n manage:(AFURLSessionManager *)manager url:(NSString *)url folderPath:(NSString *)folderPath dialogView:(DialogDownloadViewController *) dialogView nsObject:(NSManagedObject *)comic;
- (void)updateProgressView:(UIProgressView *)progressDownload percent:(float)n;
@end

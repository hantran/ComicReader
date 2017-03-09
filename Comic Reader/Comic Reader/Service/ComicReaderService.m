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
#import "ComicReaderDatabase.h"
#import "DialogDownloadViewController.h"
#import "AlertViewManager.h"
#import "Header.h"
@implementation ComicReaderService
@synthesize category;
@synthesize comic;
-(void)fetchCategoryData: (NSString *)stringURL main:(MainCategoryController *) mainCate{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:TYPE_PARSE_JSON forHTTPHeaderField:HTTP_HEADER];
    [manager GET:stringURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        category = (NSDictionary *)responseObject;
        [ComicReaderDatabase saveDataCategory:category];
        mainCate.category = [ComicReaderDatabase loadDataCategory:mainCate];
        [mainCate.mTableView reloadData];
        if([ComicReaderDatabase checkDataComic]){
            for(int i = 1;i < [category count];i++)
                [self fetchComicData:[NSString stringWithFormat:COMIC_API,i] categoryId:i viewController:mainCate checkUpdate:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [mainCate presentViewController:[AlertViewManager showAlertError:ERROR_RETRIEVING_CATEGORY error:error view:nil]animated:YES completion:nil];
    }];
}
-(void)fetchComicData: (NSString *)stringURL categoryId:(int) cateId viewController:(id) viewController checkUpdate:(BOOL)isUpdate{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    ComicReaderDatabase *database = [[ComicReaderDatabase alloc] init];
    [manager.requestSerializer setValue:TYPE_PARSE_JSON forHTTPHeaderField:HTTP_HEADER];
    [manager GET:stringURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        comic = (NSDictionary *)responseObject;
        if(isUpdate){
            [database updateDataComic:[database loadDataComicWithCategory:(NSInteger)(cateId - 1)] newData:comic cate:(NSInteger)cateId viewController:viewController];
        }
        else{
            [ComicReaderDatabase saveDataComic:comic categoryId:cateId totalCurrentComic:0];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [(UIViewController *)viewController presentViewController:[AlertViewManager showAlertError:ERROR_RETRIEVING_COMIC error:error view:nil]animated:YES completion:nil];
        
    }];
    
    
}

+(void)downloadComicImage:(NSString *)url totalPage:(NSNumber *)n path:(NSString *) folderPath dialogDownload:(DialogDownloadViewController *) dialogView nsObject:(NSManagedObject *)comic {
    ComicReaderDatabase *database = [[ComicReaderDatabase alloc] init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    dialogView.per = [[database getCurrentDownloaded:comic] floatValue] - 1.0;
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        
        if(totalBytesWritten == totalBytesExpectedToWrite){
            dispatch_async(dispatch_get_main_queue(), ^{
                dialogView.per += 1.0;
                float m = dialogView.per/100;
                dialogView.percent.text = [NSString stringWithFormat:@"%0.0f%%",dialogView.per];
                dialogView.totalPage.text = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%0.0f",dialogView.per], n];
                dialogView.progressDowload.progress = m;
            });
            
        }
        
    }];
    [self downloadAtIndex:[[database getCurrentDownloaded:comic] intValue] total:n manage:manager url:url folderPath:folderPath dialogView:dialogView nsObject:comic];
}

+(void)downloadAtIndex:(int)i total:(NSNumber *)n manage:(AFURLSessionManager *)manager url:(NSString *)url folderPath:(NSString *)folderPath dialogView:(DialogDownloadViewController *) dialogView nsObject:(NSManagedObject *)comic{
    __block int count = i;
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.jpg", url,i]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSURL alloc] initFileURLWithPath:folderPath];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        NSLog(@"Error: %@", error);
        if(error == nil)
            if(count == [n intValue] ){
                [dialogView onDownLoadFinish];
            }
            else{
                count ++;
                [self downloadAtIndex:count total:n manage:manager url:url folderPath:folderPath dialogView:dialogView nsObject:comic];
            }
            else{
                [dialogView presentViewController:[AlertViewManager showAlertError:ERROR_DOWNLOAD_COMIC error:error view:dialogView]animated:YES completion:nil];
                [ComicReaderDatabase updateCurrentDownloaded:comic current:count];
            }
    }];
    [downloadTask resume];
}
- (void)updateProgressView:(UIProgressView *)progressDownload percent:(float)n{
    progressDownload.progress = n;
}



@end

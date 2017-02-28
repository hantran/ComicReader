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
@implementation ComicReaderService
@synthesize category;
@synthesize comic;

-(void)fetchCategoryData: (NSString *)stringURL main:(MainCategoryController *) mainCate{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager GET:stringURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        category = (NSDictionary *)responseObject;
        [ComicReaderDatabase saveDataCategory:category];
        mainCate.category = [ComicReaderDatabase loadDataCategory:mainCate];
        [mainCate.mTableView reloadData];
        if([ComicReaderDatabase checkDataComic]){
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
        [ComicReaderDatabase saveDataComic:comic categoryId:cateId];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Comic"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
    
}

+(void)downloadComicImage:(NSString *)url totalPage:(int)n path:(NSString *) folderPath dialogDownload:(DialogDownloadViewController *) dialogView dataObject:(NSManagedObject *)comic collectionView:(UICollectionView *)collectionView{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    __block int count = 0;
//    __block float defaultOnePercent = (float)n/100;
    __block float onePercent = (float)n/100;
    __block float remainPercent = 0.0;
    __block float needPercent = onePercent - remainPercent;
    __block BOOL check = YES;
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        dispatch_queue_t myQueue = dispatch_queue_create("myQueue", NULL);
        
        if(check)
        if(totalBytesWritten >= needPercent * totalBytesExpectedToWrite){
            remainPercent = 1 - needPercent;
            needPercent = onePercent - remainPercent;
            count ++;
            check = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                dialogView.per += 1.0;
                float n = dialogView.per/100;
                dialogView.percent.text = [NSString stringWithFormat:@"%0.0f%%",dialogView.per];
                dialogView.progressDowload.progress = n;
            });
            
        }
        
        if(totalBytesWritten == totalBytesExpectedToWrite)
            check = YES;
//        NSLog(@"byte written: %lld", totalBytesWritten);
//        NSLog(@"Total byte: %lld", totalBytesExpectedToWrite);
        
    }];
    
    for(int i = 1; i<= n;i++){
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.jpg", url,i]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
        
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSURL alloc] initFileURLWithPath:folderPath];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if(i == n ){
            [ComicReaderDatabase updateDataComic:comic];
            [collectionView reloadData];
            [dialogView dismissViewControllerAnimated:YES completion:^{
                
            }];

        }
        
    }];
    [downloadTask resume];
    }
    
}

- (void)updateProgressView:(UIProgressView *)progressDownload percent:(float)n{
    progressDownload.progress = n;
    
}



@end

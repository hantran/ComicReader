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

+(void)downloadComicImage:(NSString *)url totalPage:(NSNumber *)n path:(NSString *) folderPath dialogDownload:(DialogDownloadViewController *) dialogView {
   
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
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
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:1];

    for(int i = 1 ; i < [n intValue];i++){
        
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%d.jpg", url,i]];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSURL alloc] initFileURLWithPath:folderPath];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
                if(i == [n intValue] ){
                    [dialogView onDownLoadFinish];
                }
            }];
            [downloadTask resume];

        }];
        [operationQueue addOperation:operation];
    }
    [operationQueue waitUntilAllOperationsAreFinished];
}

- (void)updateProgressView:(UIProgressView *)progressDownload percent:(float)n{
    progressDownload.progress = n;
    
}



@end

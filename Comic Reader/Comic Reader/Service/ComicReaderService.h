//
//  AFService.h
//  Comic Reader
//
//  Created by administrator on 2/16/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


@interface ComicReaderService : NSObject
@property(strong, nonatomic) NSDictionary *category;
-(AFHTTPRequestOperationManager *)getRequestOperation;
-(void) fetchCategoryData: (NSString *)stringURL;
-(void) fetchComicData: (NSString *)stringURL;


@end

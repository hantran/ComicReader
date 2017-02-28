//
//  LocalManager.h
//  Comic Reader
//
//  Created by administrator on 2/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalManager : NSObject

+(NSString *)createDirectoryComic:(NSString *)directory;
+(NSString *)getDocumentPath;
+(BOOL)checkEmptyFolder:(NSString *)path;
@end

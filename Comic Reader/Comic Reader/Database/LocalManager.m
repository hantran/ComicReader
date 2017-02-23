//
//  LocalManager.m
//  Comic Reader
//
//  Created by administrator on 2/23/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "LocalManager.h"

@implementation LocalManager
+(NSString *)createDirectoryComic:(NSString *)directory{
       NSString *filePathAndDirectory = [[LocalManager getDocumentPath] stringByAppendingPathComponent:directory];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
    return filePathAndDirectory;
}
+(NSString *)getDocumentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                               NSUserDomainMask, YES) objectAtIndex:0];
}
@end

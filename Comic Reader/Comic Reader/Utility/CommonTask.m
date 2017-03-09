//
//  CommonTask.m
//  Comic Reader
//
//  Created by administrator on 3/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "CommonTask.h"

@implementation CommonTask
-(UIImage *)loadImageFromLocal:(NSString *)path index:(int)i{
   return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.jpg", path, i + 1]];
}
@end

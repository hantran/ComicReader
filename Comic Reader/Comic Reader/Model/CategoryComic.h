//
//  CategoryComic.h
//  Comic Reader
//
//  Created by administrator on 2/16/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comic.h"

@interface CategoryComic : NSObject
@property(strong, nonatomic) NSString *categoryTitle;
@property(strong,nonatomic) NSMutableArray *comicArray;
@end

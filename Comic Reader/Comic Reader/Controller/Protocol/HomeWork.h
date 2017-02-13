//
//  HomeWork.h
//  Comic Reader
//
//  Created by administrator on 2/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeWork <NSObject>
@optional
-(void)giveGift;
@required
-(void)giveHomework: (NSString *)name;
@end

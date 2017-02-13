//
//  Student.h
//  Comic Reader
//
//  Created by administrator on 2/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeWork.h"
@interface Student : NSObject
@property(strong, nonatomic) NSString *name;
@property int age;
@property (strong,nonatomic) id<HomeWork> mydelegate;
@property (strong,nonatomic) id<HomeWork> mydelegateFortectcher;

-(void) giveNameAndTakeHomeWork;
@end

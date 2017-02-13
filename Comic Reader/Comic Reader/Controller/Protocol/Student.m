//
//  Student.m
//  Comic Reader
//
//  Created by administrator on 2/9/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "Student.h"

@implementation Student
@synthesize name;
@synthesize age;
-(void) giveNameAndTakeHomeWork{
    name = @"Nguyen Van A";
    age = 25;
    [self.mydelegate giveHomework:[NSString stringWithFormat:@"take home ửok for %@ at %d",name,age]];
    [self.mydelegateFortectcher giveHomework:[NSString stringWithFormat:@"take home ửok for %@ at %d",name,age]];

}
@end

//
//  AlertViewManager.h
//  Comic Reader
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface AlertViewManager : NSObject
+(UIAlertController *)showAlertError:(NSString *)title error:(NSError *)error view:(UIViewController *)viewController;
@end

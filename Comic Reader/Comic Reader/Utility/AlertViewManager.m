//
//  AlertViewManager.m
//  Comic Reader
//
//  Created by administrator on 3/7/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "AlertViewManager.h"
#import <UIKit/UIViewController.h>
#import <AFNetworking/AFNetworking.h>

@implementation AlertViewManager

+(UIAlertController *)showAlertError:(NSString *)title error:(NSError *)error view:(UIViewController *)viewController{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:error.localizedDescription
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    if(viewController != nil)
                                    [viewController dismissViewControllerAnimated:YES completion:^{
                                    }];
                                }];
    [alert addAction:yesButton];
    return alert;
}

@end

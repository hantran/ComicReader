//
//  AppDelegate.h
//  Comic Reader
//
//  Created by administrator on 2/8/17.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AFNetworking/AFNetworking.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property(strong,nonatomic) NSDictionary *category;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSURLSessionConfiguration *configuration;
@property(strong, nonatomic) AFURLSessionManager *urlManager;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();
@property (nonatomic) BOOL checkIsDownloading;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (AFURLSessionManager *)sessionManager;

@end


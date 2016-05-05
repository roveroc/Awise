//
//  AppDelegate.m
//  AwiseController
//
//  Created by rover on 16/4/20.
//  Copyright © 2016年 rover. All rights reserved.
//

#import "AppDelegate.h"
#import "RootController.h"
#import "MoreController.h"
#import "AwiseGlobal.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabCon = [[UITabBarController alloc] init];
    
    RootController *rootCon = [[RootController alloc] init];
//    rootCon.tabBarItem.image = [UIImage imageNamed:@"single.png"];
    rootCon.title= @"设备";
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:rootCon];
    
    MoreController *moreCon = [[MoreController alloc] init];
//    moreCon.tabBarItem.image = [UIImage imageNamed:@"more.png"];
    moreCon.title= @"更多";
    UINavigationController *setNav = [[UINavigationController alloc] initWithRootViewController:moreCon];
    
    NSArray *navArray = [[NSArray alloc] initWithObjects:mainNav,setNav, nil];
    tabCon.viewControllers = navArray;
    self.window.rootViewController = tabCon;
//给单色触摸存储默认场景值
    NSDictionary *singleScenedefaultValue = [NSDictionary dictionaryWithObjectsAndKeys:@"100&100&100&100", @"singleTouchSceneValue",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:singleScenedefaultValue];
    
/*********************水族灯部分**********************/
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"light_precent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    
    NSDictionary *defaultValues1 = [NSDictionary dictionaryWithObjectsAndKeys:@"00:00", @"light_sTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues1];
    
    NSDictionary *defaultValues2 = [NSDictionary dictionaryWithObjectsAndKeys:@"12:00", @"light_eTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues2];
    
    NSDictionary *defaultValues3 = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"light_switch",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues3];
    
    NSDictionary *defaultValues_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"100", @"cloudy_precent",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues_1];
    
    NSDictionary *defaultValues1_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"00:00", @"cloudy_sTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues1_1];
    
    NSDictionary *defaultValues2_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"12:00", @"cloudy_eTime",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues2_1];
    
    NSDictionary *defaultValues3_1 = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"cloudy_switch",nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues3_1];
    
    [AwiseGlobal sharedInstance].enterBackgroundFlag = NO;
    [AwiseGlobal sharedInstance].deviceSSIDArray = [[NSMutableArray alloc] init];
    [AwiseGlobal sharedInstance].IphoneIP = [[AwiseGlobal sharedInstance] getiPhoneIP];
/*********************水族灯部分**********************/
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tlblios.AwiseController" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AwiseController" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AwiseController.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

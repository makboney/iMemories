//
//  AppDelegate.m
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "AppDelegate.h"

#import "MemoryVaultViewController.h"

#import "GiftViewController.h"

#import "FriendsViewController.h"

#import "SettingsViewController.h"

#import "MainScreenViewController.h"

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [self saveField];
    
    [self saveTemplateType];
    
    [self saveTemplate];
    
    UIViewController *viewController2,*viewController3,*viewController4;
    MemoryVaultViewController *viewController1;
    UINavigationController *navController1;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[[MemoryVaultViewController alloc] initWithNibName:@"MemoryVaultViewController" bundle:nil] autorelease];
        viewController2 = [[[GiftViewController alloc] initWithNibName:@"GiftViewController" bundle:nil] autorelease];
        viewController3 = [[[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil] autorelease];
        viewController4 = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil] autorelease];
    } else {
        viewController1 = [[[MemoryVaultViewController alloc] initWithNibName:@"MemoryVaultViewController_iPad" bundle:nil] autorelease];
        viewController2 = [[[GiftViewController alloc] initWithNibName:@"GiftViewController_iPad" bundle:nil] autorelease];
        viewController3 = [[[FriendsViewController alloc] initWithNibName:@"FriendsViewController_iPad" bundle:nil] autorelease];
        viewController4 = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil] autorelease];
    }
    viewController1.managedObjectContext = self.managedObjectContext;
    
    navController1 = [[[UINavigationController alloc] initWithRootViewController:viewController1] autorelease];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.106 green:0.169 blue:0.204 alpha:1.000];
    self.tabBarController.viewControllers = @[navController1, viewController2,viewController3,viewController4];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    MainScreenViewController *mainscrnController = [[[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:mainscrnController] autorelease];
    [_tabBarController presentViewController:_navigationController animated:NO completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark -
#pragma mark - Class Methods
- (void)logedInSuccesfully{
    UINavigationController *navcontroller = [_tabBarController.viewControllers objectAtIndex:0];
    MemoryVaultViewController *controller = (MemoryVaultViewController*)navcontroller.topViewController;
    [controller reloadView];
}

#pragma mark -
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"memories" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"memories.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (void)saveTemplateType{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TemplateType" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchresults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchresults == nil) {
        //Handle Error
        NSLog(@"Handle Fetch error");
    }
    if ([mutableFetchresults count] >0) {
        return;
    }
    _templateTypeAlbum = (TemplateType *)[NSEntityDescription insertNewObjectForEntityForName:@"TemplateType" inManagedObjectContext:self.managedObjectContext];
    [_templateTypeAlbum setName:@"Album"];
    [_templateTypeAlbum setCreatedBy:[@"admin" uppercaseString]];
    [_templateTypeAlbum setUpdatedBy:[@"admin" uppercaseString]];
    [_templateTypeAlbum setCreatedDate:[NSDate date]];
    [_templateTypeAlbum setUpdatedDate:[NSDate date]];
    [_templateTypeAlbum setIcon:UIImagePNGRepresentation([UIImage imageNamed:@"Birth Certificate@2x.png"])];
    
    _templateTypePassword = (TemplateType *)[NSEntityDescription insertNewObjectForEntityForName:@"TemplateType" inManagedObjectContext:self.managedObjectContext];
    [_templateTypePassword setName:@"Password"];
    [_templateTypePassword setCreatedBy:[@"admin" uppercaseString]];
    [_templateTypePassword setUpdatedBy:[@"admin" uppercaseString]];
    [_templateTypePassword setCreatedDate:[NSDate date]];
    [_templateTypePassword setUpdatedDate:[NSDate date]];
    [_templateTypePassword setIcon:UIImagePNGRepresentation([UIImage imageNamed:@"Password@2x.png"])];
    
    _templateTypeBankAccount = (TemplateType *)[NSEntityDescription insertNewObjectForEntityForName:@"TemplateType" inManagedObjectContext:self.managedObjectContext];
    [_templateTypeBankAccount setName:@"Bank Account"];
    [_templateTypeBankAccount setCreatedBy:[@"admin" uppercaseString]];
    [_templateTypeBankAccount setUpdatedBy:[@"admin" uppercaseString]];
    [_templateTypeBankAccount setCreatedDate:[NSDate date]];
    [_templateTypeBankAccount setUpdatedDate:[NSDate date]];
    [_templateTypeBankAccount setIcon:UIImagePNGRepresentation([UIImage imageNamed:@"Bank Account@2x.png"])];
    
    if (![self.managedObjectContext save:&error]) {
        //Handle Error
        NSLog(@"Handle Error");
    }else{
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)saveField{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchresults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchresults == nil) {
        //Handle Error
        NSLog(@"Handle Fetch error");
    }
    if ([mutableFetchresults count] >0) {
        return;
    }
    fieldTitileTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldTitileTextField setType:@"UITextField"];
    [fieldTitileTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldTitileTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldTitileTextField setCreatedDate:[NSDate date]];
    [fieldTitileTextField setUpdatedDate:[NSDate date]];
    [fieldTitileTextField setName:@"Name"];
    
    fieldUserNameTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldUserNameTextField setType:@"UITextField"];
    [fieldUserNameTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldUserNameTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldUserNameTextField setCreatedDate:[NSDate date]];
    [fieldUserNameTextField setUpdatedDate:[NSDate date]];
    [fieldUserNameTextField setName:@"User Name"];
    
    fieldUserPassTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldUserPassTextField setType:@"UITextField"];
    [fieldUserPassTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldUserPassTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldUserPassTextField setCreatedDate:[NSDate date]];
    [fieldUserPassTextField setUpdatedDate:[NSDate date]];
    [fieldUserPassTextField setName:@"Password"];
    
    fieldWebSiteTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldWebSiteTextField setType:@"UITextField"];
    [fieldWebSiteTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldWebSiteTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldWebSiteTextField setCreatedDate:[NSDate date]];
    [fieldWebSiteTextField setUpdatedDate:[NSDate date]];
    [fieldWebSiteTextField setName:@"Website Address"];
    
    fieldPinTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldPinTextField setType:@"UITextField"];
    [fieldPinTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldPinTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldPinTextField setCreatedDate:[NSDate date]];
    [fieldPinTextField setUpdatedDate:[NSDate date]];
    [fieldPinTextField setName:@"Pin Code"];
    
    fieldbankNameTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldbankNameTextField setType:@"UITextField"];
    [fieldbankNameTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldbankNameTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldbankNameTextField setCreatedDate:[NSDate date]];
    [fieldbankNameTextField setUpdatedDate:[NSDate date]];
    [fieldbankNameTextField setName:@"Bank Name"];
    
    fieldAcountTypeTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldAcountTypeTextField setType:@"UITextField"];
    [fieldAcountTypeTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldAcountTypeTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldAcountTypeTextField setCreatedDate:[NSDate date]];
    [fieldAcountTypeTextField setUpdatedDate:[NSDate date]];
    [fieldAcountTypeTextField setName:@"Account Type"];
    
    fieldAcountNOTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldAcountNOTextField setType:@"UITextField"];
    [fieldAcountNOTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldAcountNOTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldAcountNOTextField setCreatedDate:[NSDate date]];
    [fieldAcountNOTextField setUpdatedDate:[NSDate date]];
    [fieldAcountNOTextField setName:@"Account Number"];
    
    fieldRoutingNOTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldRoutingNOTextField setType:@"UITextField"];
    [fieldRoutingNOTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldRoutingNOTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldRoutingNOTextField setCreatedDate:[NSDate date]];
    [fieldRoutingNOTextField setUpdatedDate:[NSDate date]];
    [fieldRoutingNOTextField setName:@"Routing Number"];
    
    fieldAccContctNoTextField = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldAccContctNoTextField setType:@"UITextField"];
    [fieldAccContctNoTextField setCreatedBy:[@"admin" uppercaseString]];
    [fieldAccContctNoTextField setUpdatedBy:[@"admin" uppercaseString]];
    [fieldAccContctNoTextField setCreatedDate:[NSDate date]];
    [fieldAccContctNoTextField setUpdatedDate:[NSDate date]];
    [fieldAccContctNoTextField setName:@"Account Contact Number"];
    
    fieldAttachment = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldAttachment setType:@"UIImage"];
    [fieldAttachment setCreatedBy:[@"admin" uppercaseString] ];
    [fieldAttachment setUpdatedBy:[@"admin" uppercaseString]];
    [fieldAttachment setCreatedDate:[NSDate date]];
    [fieldAttachment setUpdatedDate:[NSDate date]];
    [fieldAttachment setName:@"Attachment"];
    
    fieldAlbum = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldAlbum setType:@"UIImages"];
    [fieldAttachment setCreatedBy:[@"admin" uppercaseString] ];
    [fieldAlbum setUpdatedBy:[@"admin" uppercaseString]];
    [fieldAlbum setCreatedDate:[NSDate date]];
    [fieldAlbum setUpdatedDate:[NSDate date]];
    [fieldAlbum setName:@"Album"];
    
    fieldNote = (Field *)[NSEntityDescription insertNewObjectForEntityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [fieldNote setType:@"UITextView"];
    [fieldNote setCreatedBy:[@"admin" uppercaseString] ];
    [fieldNote setUpdatedBy:[@"admin" uppercaseString]];
    [fieldNote setCreatedDate:[NSDate date]];
    [fieldNote setUpdatedDate:[NSDate date]];
    [fieldNote setName:@"Note"];
    
    if (![self.managedObjectContext save:&error]) {
        //Handle Error
        NSLog(@"Handle Error");
    }else{
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)saveTemplate{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchresults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (Template *t in mutableFetchresults) {
        NSLog(@"%d",[t.field count]);
    }
    if (mutableFetchresults == nil) {
        //Handle Error
        NSLog(@"Handle Fetch error");
    }
    if ([mutableFetchresults count] >0) {
        return;
    }
    
    NSEntityDescription *entityForFields = [NSEntityDescription entityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityForFields];
    
    NSMutableArray *mutableFetchresultsForFields = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchresultsForFields == nil) {
        //Handle Error
        NSLog(@"Handle Fetch error");
    }
    Template *templateSAPassWord = (Template *)[NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    NSMutableArray *fields4Entry = [[NSMutableArray alloc] init];
    for (Field *tField in mutableFetchresultsForFields) {
        
        if ([tField.name isEqualToString:@"User Name"]) {
            tField.order = [NSNumber numberWithInt:1];
            [fields4Entry addObject:tField];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }else if ([tField.name isEqualToString:@"Website Address"]) {
            [fields4Entry addObject:tField];
            tField.order = [NSNumber numberWithInt:2];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }else if ([tField.name isEqualToString:@"Password"]) {
            [fields4Entry addObject:tField];
            tField.order = [NSNumber numberWithInt:3];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }else if ([tField.name isEqualToString:@"Pin Code"]) {
            [fields4Entry addObject:tField];
            tField.order = [NSNumber numberWithInt:4];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }else if ([tField.name isEqualToString:@"Note"]) {
            [fields4Entry addObject:tField];
            tField.order = [NSNumber numberWithInt:10];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }else if ([tField.name isEqualToString:@"Name"]) {
            [fields4Entry addObject:tField];
            tField.order = [NSNumber numberWithInt:0];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }else if ([tField.name isEqualToString:@"Attachment"]) {
            [fields4Entry addObject:tField];
            tField.order = [NSNumber numberWithInt:6];
            [templateSAPassWord addFieldObject:tField];
            [tField addTemplateObject:templateSAPassWord];
        }
    }
    NSLog(@"count %d",[fields4Entry count]);
    
    [templateSAPassWord setName:@"com.surroundapps.password"];
    [templateSAPassWord setCreatedBy:[@"admin" uppercaseString]];
    [templateSAPassWord setUpdatedBy:[@"admin" uppercaseString]];
    [templateSAPassWord setCreatedDate:[NSDate date]];
    [templateSAPassWord setUpdatedDate:[NSDate date]];
    NSSet *setttt = [[NSSet alloc] initWithArray:fields4Entry];
    NSLog(@"count %d",[setttt count]);
    //[templateSAPassWord addField:setttt];
    [setttt release];
    [templateSAPassWord setTemplateType:_templateTypePassword];
    [fields4Entry release];
    
    
    NSMutableArray *fields4Entry2 = [[NSMutableArray alloc] init];
    Template *templateSABankAccount = (Template *)[NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    for (Field *tField in mutableFetchresultsForFields) {
        
        if ([tField.name isEqualToString:@"Name"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:0];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Bank Name"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:1];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Account Type"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:3];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Account Number"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:2];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Routing Number"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:4];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Website Address"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:5];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Note"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:6];
            [tField addTemplateObject:templateSABankAccount];
        }else if ([tField.name isEqualToString:@"Attachment"]) {
            [fields4Entry2 addObject:tField];
            tField.order = [NSNumber numberWithInt:7];
            [tField addTemplateObject:templateSABankAccount];
        }
    }NSLog(@"count %d",[fields4Entry2 count]);
    
    [templateSABankAccount setName:@"com.surroundapps.bankaccount"];
    [templateSABankAccount setCreatedBy:[@"admin" uppercaseString]];
    [templateSABankAccount setUpdatedBy:[@"admin" uppercaseString]];
    [templateSABankAccount setCreatedDate:[NSDate date]];
    [templateSABankAccount setUpdatedDate:[NSDate date]];
    
    NSSet *settt = [[NSSet alloc] initWithArray:fields4Entry2];
    [templateSABankAccount addField:settt];
    [settt release];
    [templateSABankAccount setTemplateType:_templateTypeBankAccount];
    [fields4Entry2 release];
    
    Template *templateSAAlbum = (Template *)[NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    NSMutableArray *fields4Entry3 = [[NSMutableArray alloc] init];
    for (Field *tField in mutableFetchresultsForFields) {
        if ([tField.name isEqualToString:@"Name"]) {
            [fields4Entry3 addObject:tField];
            tField.order = [NSNumber numberWithInt:0];
            [tField addTemplateObject:templateSAAlbum];
        }else if ([tField.name isEqualToString:@"Album"]) {
            [fields4Entry3 addObject:tField];
            tField.order = [NSNumber numberWithInt:1];
            [tField addTemplateObject:templateSAAlbum];
        }else if ([tField.name isEqualToString:@"Note"]) {
            [fields4Entry3 addObject:tField];
            tField.order = [NSNumber numberWithInt:20];
            [tField addTemplateObject:templateSAAlbum];
        }
    }
    NSLog(@"count %d",[fields4Entry3 count]);
    
    [templateSAAlbum setName:@"com.surroundapps.album"];
    [templateSAAlbum setCreatedBy:[@"admin" uppercaseString]];
    [templateSAAlbum setUpdatedBy:[@"admin" uppercaseString]];
    [templateSAAlbum setCreatedDate:[NSDate date]];
    [templateSAAlbum setUpdatedDate:[NSDate date]];
    NSSet *sett = [[NSSet alloc] initWithArray:fields4Entry3];
    [templateSAAlbum addField:sett];
    [sett release];
    [templateSAAlbum setTemplateType:_templateTypeAlbum];
    [fields4Entry3 release];
    
    if (![self.managedObjectContext save:&error]) {
        //Handle Error
        NSLog(@"Handle Error");
    }else{
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    request = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    
    NSMutableArray *mutableFetchresultss = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    NSLog(@"%@",[mutableFetchresultss description]);
    for (Template *t in mutableFetchresultss) {
        NSLog(@"%d",[t.field count]);
    }
}
@end

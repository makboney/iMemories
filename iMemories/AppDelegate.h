//
//  AppDelegate.h
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplateType.h"
#import "Field.h"
#import "Template.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{

    TemplateType *_templateTypePassword;
    TemplateType *_templateTypeAlbum;
    TemplateType *_templateTypeBankAccount;
    Field *fieldTitileTextField;
    Field *fieldUserNameTextField;
    Field *fieldUserPassTextField;
    Field *fieldWebSiteTextField;
    Field *fieldPinTextField;
    Field *fieldbankNameTextField;
    Field *fieldAcountTypeTextField;
    Field *fieldAcountNOTextField;
    Field *fieldRoutingNOTextField;
    Field *fieldAccContctNoTextField;
    Field *fieldAttachment;
    Field *fieldAlbum;
    Field *fieldNote;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)saveTemplateType;
- (void)saveField;
- (void)saveTemplate;
- (NSURL *)applicationDocumentsDirectory;
- (void)logedInSuccesfully;
@end

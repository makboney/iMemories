//
//  CategoryViewController.h
//  iMemories
//
//  Created by Lion Boney on 2/15/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import "TemplateType.h"
#import "AppDelegate.h"
@protocol PassTypeTomemoryVaultEntry <NSObject>
-(void)valueHasChosen:(id)selectedValue;
@end
@interface CategoryViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (retain) id <PassTypeTomemoryVaultEntry> passValueDelegate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

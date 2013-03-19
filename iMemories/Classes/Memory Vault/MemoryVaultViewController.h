//
//  MemoryVaultViewController.h
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "CategoryViewController.h"
#import <CoreData/CoreData.h>

@interface MemoryVaultViewController : UIViewController<PassTypeTomemoryVaultEntry,WEPopoverControllerDelegate, UIPopoverControllerDelegate,NSFetchedResultsControllerDelegate>
{
    Class popoverClass;
    CategoryViewController *contentViewController;
}
@property (nonatomic, retain) WEPopoverController *popoverController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *memoryVaultTblView;
- (void)reloadView;
@end

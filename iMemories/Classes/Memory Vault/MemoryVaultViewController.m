//
//  MemoryVaultViewController.m
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "MemoryVaultViewController.h"

#import "AddMemoryVaultController.h"

#import "UIBarButtonItem+WEPopover.h"

#import "CategoryViewController.h"

@interface MemoryVaultViewController ()

@end

@implementation MemoryVaultViewController

@synthesize popoverController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize memoryVaultTblView = _memoryVaultTblView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Memory Vault", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"notepad"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.106 green:0.169 blue:0.204 alpha:1.000]];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItems:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    popoverClass = [WEPopoverController class];
    
    //[self saveTemplate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchresults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    for (Template *t in mutableFetchresults) {
        NSLog(@"%d",[t.field count]);
    }
}

-(void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _memoryVaultTblView = nil;
}

#pragma mark -
#pragma mark - Event Handler
- (void)addItems:(UIBarButtonItem *)addButton{
    
    if (!self.popoverController) {
		
		contentViewController = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
        contentViewController.passValueDelegate = self;
		self.popoverController = [[[popoverClass alloc] initWithContentViewController:contentViewController] autorelease];
		self.popoverController.delegate = self;
		self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		contentViewController.managedObjectContext = _managedObjectContext;
		[self.popoverController presentPopoverFromBarButtonItem:addButton
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
													   animated:YES];
        
		[contentViewController release];
        /*contentViewController = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
        contentViewController.managedObjectContext = _managedObjectContext;
        contentViewController.passValueDelegate = self;
        [self presentViewController:contentViewController animated:YES completion:nil];*/
	} else {
		[self.popoverController dismissPopoverAnimated:YES];
		self.popoverController = nil;
	}
}

#pragma mark -
#pragma mark - Class Methods
- (void)reloadView{

    NSLog(@"Reloaded");
}
#pragma mark -
#pragma mark - WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}
#pragma mark -
#pragma mark - PassTypeTomemoryVaultEntry Delegate implementation
-(void)valueHasChosen:(id)selectedValue{
    WEPopoverController *controller = (WEPopoverController*)contentViewController;
    [self popoverControllerDidDismissPopover:controller];
    
    TemplateType *model = selectedValue;
    NSLog(@"%@ type",model.name);
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Template" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(templateType = %@)", model];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    // You need to have imported the interface for your actor entity somewhere
    // before here...
    NSError *error = nil;
    Template *templateModel = (Template*) [[self.managedObjectContext executeFetchRequest:request error:&error]objectAtIndex:0];
    
    AddMemoryVaultController *addcontroller = [[AddMemoryVaultController alloc]initWithNibName:@"AddMemoryVaultController" bundle:nil];
    addcontroller.selectedTemplate = templateModel;
    addcontroller.selectedFieldValue = nil;
    addcontroller.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:addcontroller animated:YES];
     [addcontroller release];
}

#pragma mark - 
#pragma mark temp
- (void)saveTemplate{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
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
    
    NSEntityDescription *entityForFields = [NSEntityDescription entityForName:@"Field" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityForFields];
    
    NSMutableArray *mutableFetchresultsForFields = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchresultsForFields == nil) {
        //Handle Error
        NSLog(@"Handle Fetch error");
    }
    
    NSEntityDescription *entityForTempletTypes = [NSEntityDescription entityForName:@"TemplateType" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entityForTempletTypes];
    
    NSMutableArray *mutableFetchresultsForTemplateTypes = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchresultsForTemplateTypes == nil) {
        //Handle Error
        NSLog(@"Handle Fetch error");
    }
    TemplateType *albumTempType = nil, *passwordTempType = nil, *accountTempType = nil;
    for (TemplateType *tempTemType in mutableFetchresultsForTemplateTypes) {
        if ([tempTemType.name isEqualToString:@"Album"]) {
            albumTempType = tempTemType;
        }
        if ([tempTemType.name isEqualToString:@"Bank Account"]) {
            accountTempType = tempTemType;
        }
        if ([tempTemType.name isEqualToString:@"Password"]) {
            passwordTempType = tempTemType;
        }
    }
    NSMutableArray *fields4EntryAccount = [[NSMutableArray alloc] init];
    NSMutableArray *fields4EntryPassword = [[NSMutableArray alloc] init];
    NSMutableArray *fields4EntryAlbum = [[NSMutableArray alloc] init];
    for (Field *tField in mutableFetchresultsForFields) {
        
        if ([tField.name isEqualToString:@"User Name"]) {
            [fields4EntryPassword addObject:tField];
        }else if ([tField.name isEqualToString:@"Website Address"]) {
            [fields4EntryPassword addObject:tField];
        }else if ([tField.name isEqualToString:@"Password"]) {
            [fields4EntryPassword addObject:tField];
        }else if ([tField.name isEqualToString:@"Pin Code"]) {
            [fields4EntryPassword addObject:tField];
        }else if ([tField.name isEqualToString:@"Note"]) {
            [fields4EntryPassword addObject:tField];
            [fields4EntryAccount addObject:tField];
            [fields4EntryAlbum addObject:tField];
        }else if ([tField.name isEqualToString:@"Title"]) {
            [fields4EntryPassword addObject:tField];
            [fields4EntryAccount addObject:tField];
            [fields4EntryAlbum addObject:tField];
        }else if ([tField.name isEqualToString:@"Attachment"]) {
            [fields4EntryAccount addObject:tField];
            [fields4EntryPassword addObject:tField];
        }else if ([tField.name isEqualToString:@"Account Number"]) {
            [fields4EntryAccount addObject:tField];
        }else if ([tField.name isEqualToString:@"Account Type"]) {
            [fields4EntryAccount addObject:tField];
        }else if ([tField.name isEqualToString:@"Bank Name"]) {
            [fields4EntryAccount addObject:tField];
        }else if ([tField.name isEqualToString:@"Routing Number"]) {
            [fields4EntryAccount addObject:tField];
        }else if ([tField.name isEqualToString:@"Album"]) {
            [fields4EntryAlbum addObject:tField];
        }
    }
    NSLog(@"count %d",[fields4EntryPassword count]);
    Template *templateSAPassWord = (Template *)[NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    [templateSAPassWord setName:@"com.surroundapps.password"];
    [templateSAPassWord setCreatedBy:[@"admin" uppercaseString]];
    [templateSAPassWord setUpdatedBy:[@"admin" uppercaseString]];
    [templateSAPassWord setCreatedDate:[NSDate date]];
    [templateSAPassWord setUpdatedDate:[NSDate date]];
    NSSet *setttt = [[NSSet alloc] initWithArray:fields4EntryPassword];
    NSLog(@"count %d",[setttt count]);
    [templateSAPassWord setField:setttt];
    [setttt release];
    [templateSAPassWord setTemplateType:accountTempType];
    [fields4EntryPassword release];
    
    
    Template *templateSABankAccount = (Template *)[NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    [templateSABankAccount setName:@"com.surroundapps.bankaccount"];
    [templateSABankAccount setCreatedBy:[@"admin" uppercaseString]];
    [templateSABankAccount setUpdatedBy:[@"admin" uppercaseString]];
    [templateSABankAccount setCreatedDate:[NSDate date]];
    [templateSABankAccount setUpdatedDate:[NSDate date]];
    [templateSABankAccount setField:[[NSSet alloc] initWithArray:fields4EntryAccount]];
    [templateSABankAccount setTemplateType:accountTempType];
    
    
    
    Template *templateSAAlbum = (Template *)[NSEntityDescription insertNewObjectForEntityForName:@"Template" inManagedObjectContext:self.managedObjectContext];
    [templateSAAlbum setName:@"com.surroundapps.album"];
    [templateSAAlbum setCreatedBy:[@"admin" uppercaseString]];
    [templateSAAlbum setUpdatedBy:[@"admin" uppercaseString]];
    [templateSAAlbum setCreatedDate:[NSDate date]];
    [templateSAAlbum setUpdatedDate:[NSDate date]];
    NSSet *sett = [[NSSet alloc] initWithArray:fields4EntryAlbum];
    [templateSAAlbum setField:sett];
    [sett release];
    [templateSAAlbum setTemplateType:albumTempType];
    
    
    if (![self.managedObjectContext save:&error]) {
        //Handle Error
        NSLog(@"Handle Error");
    }else{
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -
#pragma mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FieldValue *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    Template *template = info.template;
    NSLog(@"%@",template.templateType.name);
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:info.value];
    cell.detailTextLabel.text = template.templateType.name;
    cell.textLabel.text = [dic objectForKey:@"Name"];
    cell.imageView.image = [UIImage imageWithData:template.templateType.icon];
//    if ([template.templateType.name isEqualToString:@"Album"]) {
//        NSMutableArray *images = [dic objectForKey:@"IMAGES"];
//        cell.imageView.image = [images objectAtIndex:0];
//    }
    cell.detailTextLabel.numberOfLines = 5;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        TemplateType *info = [_fetchedResultsController objectAtIndexPath:indexPath];
        [_managedObjectContext deleteObject:info];
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
            //Handle Error
            NSLog(@"Handle Delete Error");
        }
        
    }
    //    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    //        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 47.0f;
}
#pragma mark -
#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    FieldValue *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    AddMemoryVaultController *addcontroller = [[AddMemoryVaultController alloc]initWithNibName:@"AddMemoryVaultController" bundle:nil];
    addcontroller.selectedFieldValue = info;
    addcontroller.selectedTemplate = info.template;
    addcontroller.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:addcontroller animated:YES];
    [addcontroller release];
}
#pragma mark -
#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FieldValue" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"createdDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.memoryVaultTblView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.memoryVaultTblView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.memoryVaultTblView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.memoryVaultTblView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.memoryVaultTblView endUpdates];
}
@end

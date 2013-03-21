//
//  GiftViewController.m
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "GiftViewController.h"

@interface GiftViewController ()

@end

@implementation GiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"My Gift", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"gift"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Feature under construction." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

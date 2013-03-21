//
//  MainScreenViewController.m
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "MainScreenViewController.h"

#import "LoginViewController.h"

#import "RegisterViewController.h"

@interface MainScreenViewController ()

@end

@implementation MainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Event Handler
- (IBAction)loginBtnTapped:(id)sender{

    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
- (IBAction)registerBtnTapped:(id)sender{

    RegisterViewController *controller = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
@end

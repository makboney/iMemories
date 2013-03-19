//
//  LoginViewController.m
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize passTxtField = _passTxtField;
@synthesize emailTxtField = _emailTxtField;
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
    _delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _emailTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_passTxtField release];
    [_emailTxtField release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [_passTxtField resignFirstResponder];
    [_emailTxtField resignFirstResponder];
}
#pragma mark -
#pragma mark - Event Handler
- (IBAction)loginBtnTapped:(id)sender{
    [_delegate logedInSuccesfully];
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)cancelBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [_delegate logedInSuccesfully];
    [self dismissViewControllerAnimated:NO completion:nil];
    return YES;
}
@end

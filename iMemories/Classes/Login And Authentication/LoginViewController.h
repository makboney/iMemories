//
//  LoginViewController.h
//  iMemories
//
//  Created by Lion Boney on 2/14/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>{

    AppDelegate *_delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *emailTxtField;
@property (nonatomic, retain) IBOutlet UITextField *passTxtField;

- (IBAction)loginBtnTapped:(id)sender;
- (IBAction)cancelBtnTapped:(id)sender;
@end

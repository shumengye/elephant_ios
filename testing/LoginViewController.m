//
//  LoginViewController.m
//  Elephant
//
//  Created by Shumeng Ye on 25/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "LoginViewController.h"
#import "PhotoListController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

UITextField *activeField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    
    // User already logged in, proceed to next view
    if (currentUser)
        [self onVerifiedUser];
    
    _username.delegate = self;
    _password.delegate = self;
    [self registerForKeyboardNotifications];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onVerifiedUser {
    [self performSegueWithIdentifier:@"showPhotoList" sender:self];
}


- (IBAction)loginUser:(id)sender {
    [self.view endEditing:YES];
    
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    [PFUser logInWithUsernameInBackground:username password:password
        block:^(PFUser *user, NSError *error) {
        if (user) {
            // Login ok
            [self onVerifiedUser];

        } else {
            // Show error
            _loginMessage.text = [error userInfo][@"error"];
        }
   }];
}

// Keyboard notifications
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    // Scroll so keyboard is not hiding fields
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGRect bkgndRect = activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [activeField.superview setFrame:bkgndRect];
    [_scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Scroll back to top
    [_scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // activeField is used to scroll the view when keyboard is visible
    activeField = textField;
    
    // Reset error message
    _loginMessage.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    // Go to next field or hide keyboard
    if (theTextField == _password)
        [theTextField resignFirstResponder];
    else if (theTextField == _username)
        [_password becomeFirstResponder];

    return YES;
}


@end

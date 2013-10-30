//
//  SignupViewController.m
//  Elephant
//
//  Created by Shumeng Ye on 28/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

UITextField *activeField;

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
    
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    [self registerForKeyboardNotifications];
    
    [self.signupMessage sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupNewUser:(id)sender {
    [self.view endEditing:YES];
    
    PFUser *user = [PFUser user];
    user.username = _usernameField.text;
    user.email = _emailField.text;
    user.password = _passwordField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Sign up ok");
            // Log in user after successful signup
            [self loginUser:user.username withPassword:user.password];
        } else {
            self.signupMessage.text = [error userInfo][@"error"];
        }
    }];
}

- (void)onVerifiedUser {
    [self performSegueWithIdentifier:@"onSignUp" sender:self];
}

- (void)loginUser:(NSString *)username withPassword:(NSString *)password {
    
    // Show spinning activity indicator
    UIActivityIndicatorView *loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loader.center = self.view.center;
    [self.view addSubview:loader];
    [loader startAnimating];
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
       [loader stopAnimating];
                                        
       if (user) {
           NSLog(@"Login ok");
         // Login ok
         [self onVerifiedUser];
                                            
       } else {
         // Show error
         self.signupMessage.text = [error userInfo][@"error"];
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
    [self.scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height+80) animated:YES];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Scroll back to top
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // activeField is used to scroll the view when keyboard is visible
    activeField = self.emailField;
    
    // Reset error message
    self.signupMessage.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    // Go to next field or hide keyboard
    if (theTextField == self.passwordField)
        [theTextField resignFirstResponder];
    else if (theTextField == _emailField)
        [self.passwordField becomeFirstResponder];
    else if (theTextField == _usernameField)
        [self.emailField becomeFirstResponder];
    
    return YES;
}


@end

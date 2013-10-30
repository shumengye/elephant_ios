//
//  PasswordViewController.m
//  Elephant
//
//  Created by Shumeng Ye on 29/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "PasswordViewController.h"
#import <Parse/Parse.h>

@interface PasswordViewController ()

@end

@implementation PasswordViewController

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
	
    self.emailField.delegate = self;
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.scrollView setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    // Scroll back to top
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // activeField is used to scroll the view when keyboard is visible
    activeField = textField;
    
    // Reset error message
    self.resetMessage.text = @"";
   
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    // Hide keyboard
    [theTextField resignFirstResponder];

    return YES;
}

- (IBAction)retrievePassword:(id)sender {
    // Hide keyboard
    [self.emailField resignFirstResponder];
    
    // Send password retrieval email
    [PFUser requestPasswordResetForEmailInBackground:_emailField.text];
    self.resetMessage.text = @"Please follow the instructions sent to your email";
}

@end

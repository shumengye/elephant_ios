//
//  LoginViewController.h
//  Elephant
//
//  Created by Shumeng Ye on 25/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginMessage;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)loginUser:(id)sender;


@end

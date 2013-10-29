//
//  PasswordViewController.h
//  Elephant
//
//  Created by Shumeng Ye on 29/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *resetMessage;

- (IBAction)retrievePassword:(id)sender;

@end

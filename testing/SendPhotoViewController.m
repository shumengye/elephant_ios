//
//  SendPhotoViewController.m
//  testing
//
//  Created by Shumeng Ye on 9.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "SendPhotoViewController.h"

@interface SendPhotoViewController ()

@end

@implementation SendPhotoViewController

@synthesize myDelegate = _myDelegate;
@synthesize photoQuestion = _photoQuestion;
@synthesize imageData = _imageData;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postPhoto:(id)sender {

    _photoQuestion = self.questionTextField.text;

    // Delegate back image data and question
    [_myDelegate sendPhotoViewControllerDismissed:_imageData withQuestion:_photoQuestion];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.questionTextField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

@end

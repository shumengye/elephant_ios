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
@synthesize imageData;

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
    
    _questionTextField.delegate = self;
    
    self.photoImage.image = [[UIImage alloc] initWithData: imageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postPhoto:(id)sender {

    _photoQuestion = self.questionTextField.text;

    // Delegate back image data and question
    [_myDelegate sendPhotoViewControllerDismissed:imageData withQuestion:_photoQuestion];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)close:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    //CGPoint originPoint = postAnswerView.frame.origin;
    NSLog(@"Text field focus");
    
    CGRect frame = _postQuestionView.frame;
    frame.origin.y = frame.origin.y - 210;
    
    [UIView animateWithDuration:0.25 animations:^{
        _postQuestionView.frame = frame;
    }];
    
    return TRUE;
}

-(void)textFieldDidEndEditing:(UITextField*)textField {
    CGRect frame = _postQuestionView.frame;
    frame.origin.y = frame.origin.y + 210;
    
    [UIView animateWithDuration:0.25 animations:^{
        _postQuestionView.frame = frame;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.view)
        [self setMask:touch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touch view] == self.view)
        [self setMask:touch];
}

- (void)setMask:(UITouch *)touch {
    CGPoint location = [touch locationInView: [UIApplication sharedApplication].keyWindow];
    
    float loc2X = location.x - 20;
    if (loc2X < 23)
        loc2X = 23;
    if (loc2X > 287)
        loc2X = 287;
    
    float loc2Y = location.y - 80;
    if (loc2Y < 60)
        loc2Y = 60;
    if (loc2Y > 430)
        loc2Y = 430;
    
    CGPoint location2 = CGPointMake(loc2X, loc2Y);
    [self.photoMask setCenter: location2];
    
    //NSLog(@"Touching: %@", NSStringFromCGPoint(location2));
}



@end

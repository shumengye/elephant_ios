//
//  SendPhotoViewController.h
//  testing
//
//  Created by Shumeng Ye on 9.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SecondDelegate <NSObject>
-(void) sendPhotoViewControllerDismissed:(NSData *)imageData withQuestion:(NSString *)photoQuestion;
@end

@interface SendPhotoViewController : UIViewController <UITextFieldDelegate> {
    id myDelegate;
}

@property (nonatomic, assign) id<SecondDelegate> myDelegate;
@property (nonatomic, retain) NSData *imageData;
@property (copy, nonatomic) NSString *photoQuestion;
@property (weak, nonatomic) IBOutlet UIView *postQuestionView;

@property (weak, nonatomic) IBOutlet UITextField *questionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIImageView *photoMask;


- (IBAction)postPhoto:(id)sender;

- (IBAction)close:(id)sender;



@end

//
//  PhotoViewController.h
//  testing
//
//  Created by Shumeng Ye on 7.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    
}

@property NSMutableArray *allComments;

@property (nonatomic, retain) NSString *photoId;
@property (nonatomic, retain) NSString *photoQuestion;
@property (nonatomic, retain) NSString *photoSenderName;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;

@property (weak, nonatomic) IBOutlet UIView *commentSubView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;

@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@property (weak, nonatomic) IBOutlet UITableView *commentFeedTableView;
@property (weak, nonatomic) IBOutlet UIView *postAnswerView;

- (IBAction)postAnswer:(id)sender;

- (IBAction)handleTap:(id)sender;

- (IBAction)close:(id)sender;


@end

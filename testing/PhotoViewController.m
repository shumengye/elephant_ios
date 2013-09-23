//
//  PhotoViewController.m
//  testing
//
//  Created by Shumeng Ye on 7.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//
#import <Parse/Parse.h>
#import "PhotoViewController.h"
#import "PhotoComment.h"
#import "CommentTableCell.h"

@interface PhotoViewController () {
    BOOL *commentSubViewIsOpen;
}

@end

@implementation PhotoViewController
@synthesize photoImageView, maskImageView, photo;
@synthesize commentSubView, photoUserLabel, questionLabel, commentFeedTableView, answerTextField, postAnswerView;
@synthesize allComments;

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
    
    // Hide navigation bar
    //[self.navigationController setNavigationBarHidden:YES];
    
    commentSubViewIsOpen = NO;
    
    // Set up mask
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"mask2" ofType:@"png"];
    UIImage *mask = [[UIImage alloc] initWithContentsOfFile:imagePath];
    self.maskImageView.image = mask;
    
    // Selected photo
    self.photoImageView.image = [UIImage imageWithData:photo.imageData];
    
    // Q&A subview
    questionLabel.text = photo.question;
    photoUserLabel.text = photo.senderName;
    
    // Comments
    allComments= [[NSMutableArray alloc] init];
    
    [self getComments];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view sendSubviewToBack:self.maskImageView];
    [self.view sendSubviewToBack:self.photoImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postAnswer:(id)sender {
    [self postComment:answerTextField.text byUser:[[PFUser currentUser] objectId] byUserWithName:[[PFUser currentUser] username]];
    answerTextField.text = @"";    
}

- (IBAction)handleTap:(id)sender {
    [self showCommentSubView];
}


- (void)showCommentSubView {
    CGPoint originPoint = commentSubView.frame.origin;
    NSLog(@"Y is %@", NSStringFromCGPoint(originPoint));
    
    CGRect frame = commentSubView.frame;
    if (commentSubViewIsOpen == NO) {
        frame.origin.y = frame.origin.y - 270;
        commentSubViewIsOpen = YES;
    }
    else {
        frame.origin.y = frame.origin.y + 270;
        commentSubViewIsOpen = NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        commentSubView.frame = frame;
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [allComments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    CommentTableCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"commentItemCell"];
    if (cell == nil) {
        cell = [[CommentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PhotoComment *photoComment = (PhotoComment *)[allComments objectAtIndex:indexPath.row];
    cell.userNameLabel.text = photoComment.userName;
    cell.commentLabel.text = photoComment.comment;
    
    return cell;
}

- (IBAction)close:(id)sender {
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
    if (loc2X < 28)
        loc2X = 28;
    if (loc2X > 287)
        loc2X = 287;
    
    float loc2Y = location.y - 135;
    if (loc2Y < 5)
        loc2Y = 5;
    if (loc2Y > 368)
        loc2Y = 368;
    
    CGPoint location2 = CGPointMake(loc2X, loc2Y);
    [self.maskImageView setCenter: location2];
    
    NSLog(@"Touching: %@", NSStringFromCGPoint(location2));
}

- (void)getComments {
    allComments = [[NSMutableArray alloc] init];;
    
    PFQuery *query = [PFQuery queryWithClassName:@"PhotoComment"];
    [query whereKey:@"parent" equalTo:[PFObject objectWithoutDataWithClassName:@"UserPhoto" objectId:photo.ID]];
    
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d comments.", objects.count);
            
            for (PFObject *eachObject in objects){
                
                PFUser *user = (PFUser *)[eachObject objectForKey:@"user"];
                PFObject *aPhoto = (PFObject *)[eachObject objectForKey:@"parent"];
                PhotoComment *newComment = [[PhotoComment alloc] initWithCommentID:eachObject.objectId commentText:[eachObject objectForKey:@"comment"]
                    commentSenderID:user.objectId
                    commentSenderName:[eachObject objectForKey:@"username"]
                    commentPhotoID:aPhoto.objectId];
               
                [allComments insertObject:newComment atIndex:0];
            }
        }
        NSLog(@"Comments array %d", allComments.count);
        [self.commentFeedTableView reloadData];
    }];
}

- (void)postComment:(NSString *)comment byUser:(NSString *)userID byUserWithName:(NSString *)userName {
    PFObject *newComment = [PFObject objectWithClassName:@"PhotoComment"];
    
    [newComment setObject:[PFObject objectWithoutDataWithClassName:@"UserPhoto" objectId:photo.ID]
                   forKey:@"parent"];
    
    [newComment setObject:[PFObject objectWithoutDataWithClassName:@"User" objectId:userID] forKey:@"user"];
    
    [newComment setObject:comment forKey:@"comment"];
    [newComment setObject:userName forKey:@"username"];
    
    [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Comment upload ok");
            [self getComments];
        }
        else 
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.answerTextField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField {
    //CGPoint originPoint = postAnswerView.frame.origin;
    NSLog(@"Text field focus");
    
    CGRect frame = postAnswerView.frame;
    frame.origin.y = frame.origin.y - 210;
    
    [UIView animateWithDuration:0.25 animations:^{
        postAnswerView.frame = frame;
    }];

}

-(BOOL)textFieldDidEndEditing:(UITextField*)textField {
    CGRect frame = postAnswerView.frame;
    frame.origin.y = frame.origin.y + 210;
    
    [UIView animateWithDuration:0.25 animations:^{
        postAnswerView.frame = frame;
    }];
}


- (void)viewDidUnload {
    [self setPhotoImageView:nil];
    [self setMaskImageView:nil];
    [self setTitle:nil];
    [self setCommentSubView:nil];
    [self setQuestionLabel:nil];
    [self setAnswerTextField:nil];
    [self setCommentFeedTableView:nil];
    [self setPostAnswerView:nil];
    [self setPhotoUserLabel:nil];
    [super viewDidUnload];
}

@end

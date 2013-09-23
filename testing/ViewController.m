//
//  ViewController.m
//  testing
//
//  Created by Shumeng Ye on 31.8.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//
#import <Parse/Parse.h>
#import "ViewController.h"
#import "PhotoViewController.h"
#import "SendPhotoViewController.h"
#import "PhotoItem.h"
#import "PhotoTableCell.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize photoFeedTableView, navBar;

#define PADDING_TOP 0 // For placing the images nicely in the grid
#define PADDING 4
#define THUMBNAIL_COLS 4
#define THUMBNAIL_WIDTH 75
#define THUMBNAIL_HEIGHT 75

- (void)viewDidLoad
{
    [super viewDidLoad];

    allImages = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        NSLog(@"View appeared");
        [self refreshPhotos:nil];
    } else {
        
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }

}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [self refreshPhotos:nil];
}

- (IBAction)refreshPhotos:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    //[query whereKey:@"recipient" equalTo:user.username];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            // Retrieve existing objectIDs in photo list
            NSMutableArray *existingObjectIDs = [NSMutableArray array];
            if (allImages.count > 0) {
                for (PhotoItem *eachPhoto in allImages) {
                    [existingObjectIDs addObject:eachPhoto.ID];
                }
            }
            
            // Add photo if it isn't already in list
            for (PFObject *eachObject in objects){
                BOOL photoExists = NO;
                
                for (NSString *objectID in existingObjectIDs){
                    if ([eachObject.objectId isEqualToString:objectID]) {
                        photoExists = YES;
                    }
                }
                
                if (photoExists == NO) {
                    
                    PhotoItem *newPhoto = [[PhotoItem alloc] init];
                    
                    newPhoto.ID = eachObject.objectId;

                    newPhoto.imageData = [(PFFile *)[eachObject objectForKey:@"imageFile"] getData];                   
                    newPhoto.thumbData = [(PFFile *)[eachObject objectForKey:@"imageThumb"] getData];
                    
                    newPhoto.question = [eachObject objectForKey:@"question"];
                    newPhoto.senderName = [eachObject objectForKey:@"senderName"];
                    newPhoto.senderID = [eachObject objectForKey:@"sender"];
                    
     
                    // Create thumb if missing
                    if (newPhoto.thumbData == nil) {
                        UIImage *origImage = [UIImage imageWithData:newPhoto.imageData];
                        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
                        [origImage drawInRect: CGRectMake(0, 0, 640, 960)];
                        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        UIImage *thumb = [self createThumb:UIImageJPEGRepresentation(smallImage, 0.8)];
                        NSLog(@"Thumb for %@", newPhoto.ID);
                        newPhoto.thumbData = UIImagePNGRepresentation(thumb);
                        
                        
                        
                        PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
                        
                        // Retrieve the object by id
                        [query getObjectInBackgroundWithId:newPhoto.ID block:^(PFObject *userPhoto, NSError *error) {
                            
                            PFFile *thumbFile = [PFFile fileWithName:@"thumb.png" data:newPhoto.thumbData];
                            [userPhoto setObject:thumbFile forKey:@"imageThumb"];
                            [userPhoto saveInBackground];
                            
                        }];
                        
                    }
                    
                    
                   
                    
                    NSLog(@"NEW PHOTO %@", newPhoto.senderName);
                    
                    [allImages insertObject:newPhoto atIndex:0];
                }
            }
            
            // Sync view, remove deleted photos
            int i = 0;
            NSMutableArray *allImagesCopy = [NSMutableArray arrayWithArray:allImages];
            for(PhotoItem *photoInList in allImagesCopy) {
                BOOL photoExists = NO;
                
                for (PFObject *eachObject in objects){
                    //NSLog(@"Comparing %@ with %@", photoInList.ID, eachObject.objectId );
                    if ([photoInList.ID  isEqualToString:eachObject.objectId])
                       photoExists = YES;
                }
                
                if (photoExists == NO) {
                    [allImages removeObjectAtIndex:i];
                }
                i++;
            }
            
            
            [self.photoFeedTableView reloadData];
            
        } else {
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [allImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    static NSString *CellIdentifier = @"Cell";
    PhotoTableCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"photoItemCell"];
    if (cell == nil) {
        cell = [[PhotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    //NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //[df setDateFormat:@"MM/dd/yyyy"];
    //cell.textLabel.text = [df stringFromDate:[theObject objectForKey:@"createdAt"]];
    
    PhotoItem *cellPhoto = (PhotoItem *)[allImages objectAtIndex:indexPath.row];

    cell.userNameLabel.text = [cellPhoto.senderName capitalizedString];
    cell.questionLabel.text = [cellPhoto.question capitalizedString];
    cell.thumbImageView.image = [UIImage imageWithData:cellPhoto.thumbData];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotoView"]) {
        
        PhotoViewController *pdvc = segue.destinationViewController;
        
        NSIndexPath *indexPath = [self.photoFeedTableView indexPathForSelectedRow];
        
        PhotoItem *currentPhoto = (PhotoItem *)[allImages objectAtIndex:indexPath.row];

        pdvc.photo = currentPhoto;
        [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    }
    
}


- (IBAction)takePhoto:(id)sender {

    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;

                
        // Show image picker
        [self.navigationController presentViewController:imagePicker animated:NO completion:NULL];
    }

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Show image picker
    SendPhotoViewController *sendPhoto = [[SendPhotoViewController alloc] init];
    sendPhoto.imageData = UIImageJPEGRepresentation(smallImage, 0.8);
    sendPhoto.myDelegate = self;
    [self.navigationController presentViewController:sendPhoto animated:YES completion:NULL];
}

- (void)sendPhotoViewControllerDismissed:(NSData *)imageData withQuestion:(NSString *)photoQuestion
{
    [self uploadImage:imageData withQuestion:photoQuestion];
}

- (UIImage *) maskImage:(UIImage *)image
              withMask:(UIImage *)maskImage
{
    CGImageRef imageRef = image.CGImage;
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef),
                                        NULL, // decode should be NULL
                                        FALSE // shouldInterpolate
                                        );
    
    CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    CGImageRelease(mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return maskedImage;
}

- (UIImage *)createThumb:(NSData *)originalData {
    UIImage *origImage = [UIImage imageWithData:originalData];
    CGRect rect = CGRectMake(270, 430, 100, 100);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(origImage.CGImage, rect);
    UIImage *imgs = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return imgs;
}


- (void)uploadImage:(NSData *)imageData withQuestion:(NSString *)photoQuestion {
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //UIImage *thumb = [self createThumb:imageData];
    UIImage *thumb = [self createThumb:imageData];
    PFFile *imageThumb = [PFFile fileWithName:@"thumb.png" data:UIImagePNGRepresentation(thumb)];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            [userPhoto setObject:imageThumb forKey:@"imageThumb"];
            
            // Set the access control list to current user for security purposes
            PFACL *photoACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [photoACL setPublicReadAccess:YES];
            userPhoto.ACL = photoACL;
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"sender"];
            [userPhoto setObject:user.username forKey:@"senderName"];
            [userPhoto setObject:photoQuestion forKey:@"question"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self refreshPhotos:nil];
                    NSLog(@"Upload ok");
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {

    }];
}


- (void)viewDidUnload {
    [self setPhotoFeedTableView:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end

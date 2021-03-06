//
//  ViewController.m
//  testing
//
//  Created by Shumeng Ye on 31.8.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PhotoListController.h"
#import "PhotoTableCell.h"
#import "SendPhotoViewController.h"
#import "PhotoViewController.h"

@implementation PhotoListController

// Storing image data returned from camera
NSData *imageData;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        // Parse class settings
        self.parseClassName = @"UserPhoto";
        
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (!currentUser) {
        NSLog(@"log out");
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Navigation bar style 
    self.navigationItem.backBarButtonItem = nil;
    
    UIImage *navBackgroundImage = [UIImage imageNamed:@"navbar"];
    [self.navigationController.navigationBar setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    // Background image
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"blur2.jpg"]];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logoutUser:(id)sender {
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

/*
 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
 PFQuery *query = [PFQuery queryWithClassName:self.className];
 
 // If Pull To Refresh is enabled, query against the network by default.
 if (self.pullToRefreshEnabled) {
 query.cachePolicy = kPFCachePolicyNetworkOnly;
 }
 
 // If no objects are loaded in memory, we look to the cache first to fill the table
 // and then subsequently do a query against the network.
 if (self.objects.count == 0) {
 query.cachePolicy = kPFCachePolicyCacheThenNetwork;
 }
 
 [query orderByDescending:@"createdAt"];
 
 return query;
 }
 */


// Tabel cell for elephant photo
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     static NSString *CellIdentifier = @"photoItemCell";
     PhotoTableCell *cell;
     
     cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[PhotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
 
     // Photo thumbnail
     PFFile *thumbnail = object[@"imageThumb"];
     cell.thumbImageView.file = thumbnail;
     [cell.thumbImageView loadInBackground];
     // Round corners
     cell.thumbImageView.layer.cornerRadius = 50;
     cell.thumbImageView.layer.masksToBounds = YES;
     
     cell.questionLabel.text = object[@"question"];
     cell.usernameLabel.text = [object[@"senderName"]  capitalizedString];
     
     NSDateFormatter* df = [[NSDateFormatter alloc]init];
     [df setDateFormat:@"MM/dd/yyyy"];     
     cell.dateLabel.text = [df stringFromDate: object.createdAt];
     
     cell.objectId.text = object.objectId;
     
     [cell setBackgroundColor:[UIColor clearColor]];
     
     return cell;
 }


// Segue for displaying detail view for photos
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPhotoView"]) {
        
        PhotoViewController *pdvc = segue.destinationViewController;
        
        // Pass photo id to detail view controller
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PhotoTableCell *selectedCell =  (PhotoTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        // Set some photo variables
        pdvc.photoId = selectedCell.objectId.text;
        pdvc.photoQuestion = selectedCell.questionLabel.text;
        pdvc.photoSenderName = selectedCell.usernameLabel.text;        
    }
    
    if ([segue.identifier isEqualToString:@"showCamera"]) {
    
        UIImagePickerController *imagePicker = [segue destinationViewController];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"showSendPhoto"]) {
        SendPhotoViewController *controller = [segue destinationViewController];
        controller.imageData = imageData;
        controller.myDelegate = self;
    }
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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
    imageData = UIImageJPEGRepresentation(smallImage, 0.8);
    
    // Show final view for posting photo
    [self performSegueWithIdentifier:@"showSendPhoto" sender:self];
}

- (void)sendPhotoViewControllerDismissed:(NSData *)imageData withQuestion:(NSString *)photoQuestion
{
    [self uploadImage:imageData withQuestion:photoQuestion];
}

- (UIImage *)createThumb:(NSData *)originalData {
    UIImage *origImage = [UIImage imageWithData:originalData];
    
    CGRect rect = CGRectMake(270, 430, 100, 100);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(origImage.CGImage, rect);
    UIImage *imgs = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return imgs;
}

//  UIImage *thumb = [self maskImage:[UIImage imageNamed:@"elephant"] withMask:[UIImage imageNamed:@"heartmask.jpg"]];


- (void)uploadImage:(NSData *)imageData withQuestion:(NSString *)photoQuestion {
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    UIImage *thumb = [self createThumb:imageData];
   
    PFFile *imageThumb = [PFFile fileWithName:@"thumb.png" data:UIImagePNGRepresentation(thumb) ];
    
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
                    //[self refreshPhotos:nil];
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



@end
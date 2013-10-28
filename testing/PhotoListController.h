//
//  ViewController.h
//  testing
//
//  Created by Shumeng Ye on 31.8.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "SendPhotoViewController.h"

@interface PhotoListController : PFQueryTableViewController <SecondDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {

}

//@property (weak, nonatomic) IBOutlet UITableView *photoFeedTableView;
//@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
/*
- (IBAction)takePhoto:(id)sender;
- (IBAction)refreshPhotos:(id)sender;
*/

- (IBAction)takePhoto:(id)sender;

@end



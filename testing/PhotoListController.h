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

- (IBAction)logoutUser:(id)sender;

- (IBAction)takePhoto:(id)sender;

@end



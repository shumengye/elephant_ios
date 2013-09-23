//
//  ViewController.h
//  testing
//
//  Created by Shumeng Ye on 31.8.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#include <stdlib.h>
#import "SendPhotoViewController.h"
#import "PhotoTableCell.h"

@interface ViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, SecondDelegate, UITableViewDataSource, UITableViewDelegate> {
   NSMutableArray *allImages;
}


@property (weak, nonatomic) IBOutlet UITableView *photoFeedTableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

- (IBAction)takePhoto:(id)sender;

- (IBAction)refreshPhotos:(id)sender;


- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (void)buttonTouched:(id)sender;

@end



//
//  PhotoTableCell.h
//  elephant
//
//  Created by Shumeng Ye on 15.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PhotoTableCell : PFTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *objectId;

@property (weak, nonatomic) IBOutlet PFImageView *thumbImageView;

@end

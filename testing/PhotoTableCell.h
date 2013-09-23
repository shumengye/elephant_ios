//
//  PhotoTableCell.h
//  elephant
//
//  Created by Shumeng Ye on 15.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbImageView;

@end

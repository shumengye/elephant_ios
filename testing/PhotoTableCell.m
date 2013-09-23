//
//  PhotoTableCell.m
//  elephant
//
//  Created by Shumeng Ye on 15.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "PhotoTableCell.h"

@implementation PhotoTableCell

@synthesize userNameLabel, questionLabel, thumbImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

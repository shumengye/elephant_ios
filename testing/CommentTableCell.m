//
//  CommentTableCell.m
//  elephant
//
//  Created by Shumeng Ye on 16.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "CommentTableCell.h"

@implementation CommentTableCell

@synthesize userNameLabel, commentLabel;

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

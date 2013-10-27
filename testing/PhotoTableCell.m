//
//  PhotoTableCell.m
//  elephant
//
//  Created by Shumeng Ye on 15.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "PhotoTableCell.h"

@implementation PhotoTableCell

@synthesize dateLabel, thumbImageView, questionLabel, usernameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}

@end

//
//  CommentTableCell.h
//  elephant
//
//  Created by Shumeng Ye on 16.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentLabel;

@end

//
//  PhotoComment.m
//  elephant
//
//  Created by Shumeng Ye on 13.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "PhotoComment.h"

@implementation PhotoComment

@synthesize ID, comment, userID, userName, photoID;

- (id)initWithCommentID:(NSString *)commentID commentText:(NSString *)commentText commentSenderID:(NSString *)senderID commentSenderName:(NSString *)senderName commentPhotoID:(NSString *)commentPhotoID {
    self = [super init];
    if (self) {
        self.ID = commentID;
        self.comment = commentText;
        self.userID = senderID;
        self.userName = senderName;
        
    }
    
    return self;
}

@end

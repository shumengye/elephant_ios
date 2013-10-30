//
//  PhotoComment.h
//  elephant
//
//  Created by Shumeng Ye on 13.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoComment : NSObject

@property NSString *ID;
@property NSString *comment;
@property NSString *userID;
@property NSString *userName;
@property NSString *photoID;

- (id)initWithCommentID:(NSString *)commentID commentText:(NSString *)commentText commentSenderID:(NSString *)senderID commentSenderName:(NSString *)senderName commentPhotoID:(NSString *)commentPhotoID;

@end

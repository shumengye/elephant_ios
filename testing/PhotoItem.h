//
//  ElephantPhoto.h
//  elephant
//
//  Created by Shumeng Ye on 11.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoItem : NSObject {
   
}

@property NSString *ID;
@property NSData *imageData;
@property NSData *thumbData;
@property NSString *question;
@property NSString *senderID;
@property NSString *senderName;

- (id)initWithPhotoID:(NSString *)photoID imageData:(NSData *)fileData photoQuestion:(NSString *)question photoSenderID:(NSString *)senderID photoSenderName:(NSString *)senderName;

@end

//
//  ElephantPhoto.m
//  elephant
//
//  Created by Shumeng Ye on 11.9.2013.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <Parse/Parse.h>
#import "PhotoItem.h"


@implementation PhotoItem

@synthesize ID, question, imageData, thumbData, senderName, senderID;

- (id)initWithPhotoID:(NSString *)photoID imageData:(NSData *)fileData photoQuestion:(NSString *)question photoSenderID:(NSString *)photoSenderID photoSenderName:(NSString *)photoSenderName {
    self = [super init];
    if (self) {
        self.ID = photoID;
        self.imageData = fileData;
        self.senderID = photoSenderID;
        self.senderName = photoSenderName;
    }
    
    return self;
}

@end

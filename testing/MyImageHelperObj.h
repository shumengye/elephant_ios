//
//  MyImageHelperObj.h
//  Elephant
//
//  Created by Shumeng Ye on 27/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyImageHelperObj : NSObject

+ (UIImage *) createGrayScaleImage:(UIImage*)originalImage;
+ (UIImage *) createMaskedImageWithSize:(CGSize)newSize sourceImage:(UIImage *)sourceImage maskImage:(UIImage *)maskImage;

@end

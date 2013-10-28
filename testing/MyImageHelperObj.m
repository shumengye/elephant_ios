//
//  MyImageHelperObj.m
//  Elephant
//
//  Created by Shumeng Ye on 27/10/13.
//  Copyright (c) 2013 Shumeng Ye. All rights reserved.
//

#import "MyImageHelperObj.h"

@implementation MyImageHelperObj

+ (UIImage *) createMaskedImageWithSize:(CGSize)newSize sourceImage:(UIImage *)sourceImage maskImage:(UIImage *)maskImage;
{
    // create image size rect
    CGRect newRect = CGRectZero;
    newRect.size = newSize;
    
    // draw source image
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0f);
    [sourceImage drawInRect:newRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // draw mask image
    [maskImage drawInRect:newRect blendMode:kCGBlendModeNormal alpha:1.0f];
    maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // create grayscale version of mask image to make the "image mask"
    UIImage *grayScaleMaskImage = [MyImageHelperObj createGrayScaleImage:maskImage];
    CGFloat width = CGImageGetWidth(grayScaleMaskImage.CGImage);
    CGFloat height = CGImageGetHeight(grayScaleMaskImage.CGImage);
    CGFloat bitsPerPixel = CGImageGetBitsPerPixel(grayScaleMaskImage.CGImage);
    CGFloat bytesPerRow = CGImageGetBytesPerRow(grayScaleMaskImage.CGImage);
    CGDataProviderRef providerRef = CGImageGetDataProvider(grayScaleMaskImage.CGImage);
    CGImageRef imageMask = CGImageMaskCreate(width, height, 8, bitsPerPixel, bytesPerRow, providerRef, NULL, false);
    
    CGImageRef maskedImage = CGImageCreateWithMask(newImage.CGImage, imageMask);
    CGImageRelease(imageMask);
    newImage = [UIImage imageWithCGImage:maskedImage];
    CGImageRelease(maskedImage);
    return [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
}

+ (UIImage *) createGrayScaleImage:(UIImage*)originalImage;
{
    //create gray device colorspace.
    CGColorSpaceRef space = CGColorSpaceCreateDeviceGray();
    //create 8-bit bimap context without alpha channel.
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, originalImage.size.width, originalImage.size.height, 8, 0, space, kCGImageAlphaNone);
    CGColorSpaceRelease(space);
    //Draw image.
    CGRect bounds = CGRectMake(0.0, 0.0, originalImage.size.width, originalImage.size.height);
    CGContextDrawImage(bitmapContext, bounds, originalImage.CGImage);
    //Get image from bimap context.
    CGImageRef grayScaleImage = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    //image is inverted. UIImage inverts orientation while converting CGImage to UIImage.
    UIImage* image = [UIImage imageWithCGImage:grayScaleImage];
    CGImageRelease(grayScaleImage);
    return image;
}

@end

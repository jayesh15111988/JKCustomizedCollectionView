//
//  UIImage+Utilities.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/11/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

- (UIImage *)imageWithImageScaledToDimension:(CGFloat)imageToScaleParameter
                                 isWidth:(BOOL)isScalingWidth {

    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.width;

    CGFloat scaleFactor = 1.0;


    if (isScalingWidth) {
        if (self.size.width > imageToScaleParameter) {
        scaleFactor = imageToScaleParameter / oldWidth;
        }
        else{
            return self;
        }

    } else {
        if (self.size.height > imageToScaleParameter) {
        scaleFactor = imageToScaleParameter / oldHeight;
        }
        else{
            return self;
        }

    }


    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

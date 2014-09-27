//
//  UIImage+Utilities.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/11/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage (Utilities)

- (UIImage *)imageWithImageScaledToWidth:(CGFloat)imageWidth {
    
    if(self.size.width<imageWidth){
        imageWidth=self.size.width;
    }
    
    CGFloat oldWidth = self.size.width;
    CGFloat scaleFactor = imageWidth / oldWidth;

    
    
    CGFloat newHeight = self.size.height * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

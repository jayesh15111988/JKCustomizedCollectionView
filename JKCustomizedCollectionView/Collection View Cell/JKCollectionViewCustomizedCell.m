//
//  JKCollectionViewCustomizedCell.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKCollectionViewCustomizedCell.h"
#import <SDWebImage/SDWebImageManager.h>
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "JKImageObjectModel.h"
#import "JKConstantsCollection.h"

@interface JKCollectionViewCustomizedCell ()

@property(strong, nonatomic) SDWebImageManager *manager;
@property(strong, nonatomic) NSURL *individualImageURL;



@end

@implementation JKCollectionViewCustomizedCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)customizeCellWithPhotoDetails{

    DLog(@"%@ %@ %@ %f",self.individualImageProperties.imageName,self.individualImageProperties.takenOn,self.individualImageProperties.imageDescription,self.individualImageProperties.heightToIncrementForCell);




    self.imageName.text = self.individualImageProperties.imageName;
    self.dateAdded.text = self.individualImageProperties.takenOn;


    self.imageDescription.text = self.individualImageProperties.imageDescription;

    self.imageDescription.numberOfLines = self.individualImageProperties.heightToIncrementForCell;

    CGRect imageDescriptionFrame = self.imageDescription.frame;
    imageDescriptionFrame.size.height =
        stepIncrementForCellHeight * self.individualImageProperties.heightToIncrementForCell;
    self.imageDescription.frame = imageDescriptionFrame;

    DLog(@"Height %f and number of lines %d",
         self.imageDescription.frame.size.height,
         self.imageDescription.numberOfLines);


    __block CGFloat imageWidthToAdjust = 200;

    __weak typeof(self) weakSelf = self;

    self.imageView.alpha = 0;

    [[SDWebImageManager sharedManager]
        downloadImageWithURL:self.individualImageProperties.iconImageURL
        options:0
        progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                    BOOL finished, NSURL *imageURL) {

            __strong __typeof(weakSelf) strongSelf = weakSelf;

            if (image.size.width < imageWidthToAdjust) {
                imageWidthToAdjust = image.size.width;
            }


            if (image) {

                image = [image imageWithImageScaledToDimension:imageWidthToAdjust isWidth:YES];
                [strongSelf.imageView setImage:image];
            } else {
                [strongSelf.imageView
                    setImage:[UIImage imageNamed:@"noImage.png"]];
            }

            [UIView animateWithDuration:1
                delay:0.0f
                options:UIViewAnimationOptionCurveLinear
                animations:^{ strongSelf.imageView.alpha = 1; }
                completion:^(BOOL finished) {}];
        }];
}





@end

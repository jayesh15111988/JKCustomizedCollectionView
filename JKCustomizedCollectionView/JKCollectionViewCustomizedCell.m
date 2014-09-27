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

@interface JKCollectionViewCustomizedCell ()

@property(strong, nonatomic) SDWebImageManager *manager;
@property(strong, nonatomic) NSURL *individualImageURL;
@property(strong, nonatomic) JKImageObjectModel *individualImageProperties;
- (IBAction)imageInfoButtonClicked:(id)sender;
- (IBAction)authorInfoButtonClicked:(id)sender;

@end

@implementation JKCollectionViewCustomizedCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)customizeCellWithPhotoDetails:(JKImageObjectModel *)photoDetails {


    self.individualImageProperties = photoDetails;


    self.imageName.text = photoDetails.imageName;
    self.dateAdded.text = photoDetails.takenOn;


    self.imageDescription.text = photoDetails.imageDescription;


    __block CGFloat imageWidthToAdjust = 200;

    [[SDWebImageManager sharedManager]
        downloadImageWithURL:photoDetails.iconImageURL
        options:0
        progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                    BOOL finished, NSURL *imageURL) {

            if (image.size.width < imageWidthToAdjust) {
                imageWidthToAdjust = image.size.width;
            }

            if (image) {

                image = [image imageWithImageScaledToWidth:imageWidthToAdjust];
                [self.imageView setImage:image];
            } else {
                [self.imageView setImage:[UIImage imageNamed:@"fed.jpg"]];
            }
        }];
}


- (IBAction)imageInfoButtonClicked:(id)sender {
    // Show extra image information if this button is pressed
    if (self.getImageInfo) {
        self.getImageInfo(self.individualImageProperties);
    }
}

- (IBAction)authorInfoButtonClicked:(id)sender {
    // Show author specific information if this button is pressed
    if (self.getAuthorInfo) {
        self.getAuthorInfo(
            self.individualImageProperties.authorModelForCurrentImage);
    }
}
@end

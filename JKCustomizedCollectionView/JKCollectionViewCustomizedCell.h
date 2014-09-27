//
//  JKCollectionViewCustomizedCell.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageObjectModel.h"
#import "JKImageAuthorObjectModel.h"
@class JKImageAuthorObjectModel;

@interface JKCollectionViewCustomizedCell : UICollectionViewCell
@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UILabel *imageName;
@property(weak, nonatomic) IBOutlet UILabel *dateAdded;
@property(weak, nonatomic) IBOutlet UILabel *imageDescription;
- (void)customizeCellWithPhotoDetails:(NSDictionary *)photoDetails;

@property(strong, nonatomic) JKImageObjectModel *imageModel;
@property(strong, nonatomic) JKImageAuthorObjectModel *imageAuthorModel;

typedef void (^imageInfoBlock)(JKImageObjectModel *imageInfo);
@property(strong, nonatomic) imageInfoBlock getImageInfo;

typedef void (^authorInfoBlock)(JKImageAuthorObjectModel *authorInfo);
@property(strong, nonatomic) authorInfoBlock getAuthorInfo;


@end

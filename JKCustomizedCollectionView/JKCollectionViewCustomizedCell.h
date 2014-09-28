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
@property(weak, nonatomic) IBOutlet UIButton *getImageInfoButton;
@property(weak, nonatomic) IBOutlet UIButton *getAuthorInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *displayFullImageButton;

@property(strong, nonatomic) JKImageObjectModel *individualImageProperties;

- (void)customizeCellWithPhotoDetails;

@property(strong, nonatomic) JKImageObjectModel *imageModel;
@property(strong, nonatomic) JKImageAuthorObjectModel *imageAuthorModel;


@end

//
//  JKCollectionViewCustomizedCell.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKCollectionViewCustomizedCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageName;
@property (weak, nonatomic) IBOutlet UILabel *dateAdded;
@property (weak, nonatomic) IBOutlet UILabel *description;
-(void)customizeCellWithPhotoDetails:(NSDictionary*)photoDetails;

typedef void(^imageInfoBlock)(NSDictionary* imageInfo);
@property (strong, nonatomic) imageInfoBlock getImageInfo;

typedef void(^authorInfoBlock)(NSDictionary* authorInfo);
@property (strong, nonatomic) authorInfoBlock getAuthorInfo;


@end

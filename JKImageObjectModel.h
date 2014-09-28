//
//  JKImageObjectModel.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/23/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKImageAuthorObjectModel.h"

@interface JKImageObjectModel : NSObject

+ (NSArray *)getObjectModelsFromImageInfoDictionary:
        (NSArray *)originalImageInfo;

@property(nonatomic, strong) NSURL *iconImageURL;
@property(nonatomic, strong) NSURL *iconImageBigURL;
@property(nonatomic, strong) NSString *apertureSize;
@property(nonatomic, strong) NSString *camera;
@property(nonatomic, strong) NSString *createdOn;
@property(nonatomic, strong) NSString *imageDescription;
@property(nonatomic, strong) NSString *favoritesCount;
@property(nonatomic, strong) NSString *focalLength;
@property(nonatomic, strong) NSString *ISO;
@property(nonatomic, strong) NSString *locations;
@property(nonatomic, strong) NSString *latitude;
@property(nonatomic, strong) NSString *longitude;
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, strong) NSString *shutterSpeed;
@property(nonatomic, strong) NSString *takenOn;
@property(nonatomic, strong) NSString *views;
@property (nonatomic,assign) CGFloat heightToIncrementForCell;
@property (nonatomic,strong) JKImageAuthorObjectModel* authorModelForCurrentImage;

@end

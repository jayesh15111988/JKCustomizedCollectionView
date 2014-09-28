//
//  JKImageAuthorObjectModel.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/23/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKImageAuthorObjectModel : NSObject

+ (JKImageAuthorObjectModel *)getObjectModelsFromImageAuthorInfoDictionary:
        (NSDictionary *)originalImageAuthorInfo;

@property(nonatomic, strong) NSURL *authorIconURL;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *lastName;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, assign) BOOL accountUpgradeFlag;
@property(nonatomic, strong) NSString *affectionCount;
@property(nonatomic, strong) NSString *followers;
@property(nonatomic, strong) UIImage *authorImage;

@end
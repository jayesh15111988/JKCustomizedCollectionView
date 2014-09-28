//
//  JKImageAuthorObjectModel.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/23/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKImageAuthorObjectModel.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation JKImageAuthorObjectModel

+ (JKImageAuthorObjectModel *)getObjectModelsFromImageAuthorInfoDictionary:
                                  (NSDictionary *)originalImageAuthorInfo {


    JKImageAuthorObjectModel *authorModel = [JKImageAuthorObjectModel new];

    authorModel.authorIconURL =
        [NSURL URLWithString:originalImageAuthorInfo[@"userpic_url"] ?: @""];
    authorModel.username = originalImageAuthorInfo[@"username"];
    authorModel.firstName = originalImageAuthorInfo[@"firstname"];
    authorModel.lastName = originalImageAuthorInfo[@"lastname"];
    authorModel.city = originalImageAuthorInfo[@"city"];
    authorModel.country = originalImageAuthorInfo[@"country"];
    authorModel.accountUpgradeFlag =
        [originalImageAuthorInfo[@"upgrade_status"] boolValue];
    authorModel.affectionCount = [NSString
        stringWithFormat:@"%@", originalImageAuthorInfo[@"affection"]];
    authorModel.followers = [NSString
        stringWithFormat:@"%@", originalImageAuthorInfo[@"followers_count"]];

    return authorModel;
}
@end

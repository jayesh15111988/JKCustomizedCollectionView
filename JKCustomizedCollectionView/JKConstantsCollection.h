//
//  JKConstantsCollection.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/11/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONSUMER_KEY @"71Oq2GyVY7EmE9vmjEowj6a99aWqXW9uOYUVe9AN"
static CGFloat const stepIncrementForCellHeight = 22;
static NSString *notSpecifiedDisplayString = @"Not Specified";

static CGFloat currentViewWidth = 500;
static CGFloat currentViewHeight = 600;
static CGFloat defaultAnimationDuration = 1.5;

typedef NS_ENUM(NSUInteger, ExtraImageInformationType) {
    ExtraImageInformation,
    ExtraImageAuthorInformation
};

@interface JKConstantsCollection : NSObject

@end

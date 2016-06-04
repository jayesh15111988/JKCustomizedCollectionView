//
//  JKImageObjectModel.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/23/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKImageObjectModel.h"
#import "JKImageAuthorObjectModel.h"
#import "NSString+Utilities.h"
#import "UIImage+Utilities.h"
#import "JKConstantsCollection.h"
#import <SDWebImage/SDWebImageManager.h>

@interface JKImageObjectModel () {
}

@end

@implementation JKImageObjectModel

+ (NSArray *)getObjectModelsFromImageInfoDictionary:
                 (NSArray *)originalImageInfo {

    NSMutableArray *fullImageModelCollection = [NSMutableArray new];

    for (NSDictionary *individualImageInfoDictionary in originalImageInfo) {
        JKImageObjectModel *imageModel = [JKImageObjectModel new];

        imageModel.iconImageURL = [NSURL
            URLWithString:[individualImageInfoDictionary[@"image_url"] isNull]
                              ? @""
                              : individualImageInfoDictionary[@"image_url"]];
        
        imageModel.iconImageBigURL=[self replaceWithBigURLWithOriginalString:[imageModel.iconImageURL absoluteString]];
        imageModel.apertureSize = individualImageInfoDictionary[@"aperture"];
        imageModel.camera = individualImageInfoDictionary[@"camera"];
        if (![individualImageInfoDictionary[@"created_at"] isNull]) {

            imageModel.createdOn = [individualImageInfoDictionary[
                @"created_at"] convertmySQLStringToDateFormattedString];
        } else {
            imageModel.createdOn = @"Not Available";
        }

        if (individualImageInfoDictionary[@"description"] == (id)[NSNull null]) {
            imageModel.imageDescription = notSpecifiedDisplayString;
        } else {
            imageModel.imageDescription = individualImageInfoDictionary[@"description"];
        }
        
        imageModel.imageDescription =
            [imageModel.imageDescription stripWhiteSpacesAndNewlinesFromString];
        imageModel.favoritesCount = [NSString
            stringWithFormat:@"%@",
                             individualImageInfoDictionary[@"favorites_count"]];
        imageModel.focalLength = individualImageInfoDictionary[@"focal_length"];
        imageModel.ISO = individualImageInfoDictionary[@"iso"];
        imageModel.locations =
            individualImageInfoDictionary[@"locations"] ?: @"Not Specified";
        imageModel.latitude = [NSString
            stringWithFormat:@"%@",
                             individualImageInfoDictionary[@"latitude"]
                                 ? notSpecifiedDisplayString
                                 : individualImageInfoDictionary[@"latitude"]];
        imageModel.longitude = [NSString
            stringWithFormat:
                @"%@", individualImageInfoDictionary[@"longitude"]
                           ? notSpecifiedDisplayString
                           : individualImageInfoDictionary[@"longitude"]];
        imageModel.imageName = individualImageInfoDictionary[@"name"];
        imageModel.shutterSpeed =
            individualImageInfoDictionary[@"shutter_speed"];
        if (!individualImageInfoDictionary[@"taken_at"]) {
            imageModel.takenOn = [individualImageInfoDictionary[
                @"taken_at"] convertmySQLStringToDateFormattedString];

        } else {
            imageModel.takenOn = @"Not Available";
        }
        imageModel.views = [NSString
            stringWithFormat:@"%@",
                             individualImageInfoDictionary[@"times_viewed"]];
        imageModel.heightToIncrementForCell = [self
            getNumberOfLinesForGivenDescription:imageModel.imageDescription];

       
        imageModel.authorModelForCurrentImage = [JKImageAuthorObjectModel
            getObjectModelsFromImageAuthorInfoDictionary:
                individualImageInfoDictionary[@"user"]];


        [fullImageModelCollection addObject:imageModel];
    }
    return fullImageModelCollection;
}


+ (NSInteger)getNumberOfLinesForGivenDescription:(NSString *)imageDescription {

    NSInteger lengthOfDescription =
        [imageDescription isNull] ? 0 : [imageDescription length];

    NSInteger finalLengthOfLabel = 0;

    finalLengthOfLabel = ceil(lengthOfDescription / 38.0);


    return (finalLengthOfLabel == 0) ? 1 : finalLengthOfLabel;
}

+(NSURL*)replaceWithBigURLWithOriginalString:(NSString*)originalString{
    
    
NSString* finalBigURLValue=@"";
    
    if(originalString){
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"/[0-9]*.(jpg|png|jpeg)"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    
    __block NSString *replacementString = @"";
    
    [regex enumerateMatchesInString:originalString
                            options:0
                              range:NSMakeRange(0, [originalString length])
                         usingBlock:^(NSTextCheckingResult *match,
                                      NSMatchingFlags flags, BOOL *stop) {
                             
                             // detect
                             NSString *insideString = [originalString
                                                       substringWithRange:[match rangeAtIndex:1]];
                             
                             // print
                             replacementString = [NSString
                                                  stringWithFormat:@"/4.%@", insideString];
                         }];
    
    
    NSString *stringURLWithBigImage = [regex
                                stringByReplacingMatchesInString:originalString
                                options:0
                                range:NSMakeRange(0, [originalString length])
                                       withTemplate:replacementString];
    
        finalBigURLValue=stringURLWithBigImage?:@"";
        
    }
return [NSURL URLWithString:finalBigURLValue];
    
}

@end
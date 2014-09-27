//
//  NSString+Utilities.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "NSString+Utilities.h"

static NSDateFormatter *dateFormatter;

@implementation NSString (Utilities)

- (BOOL)containsSubstringWithString:(NSString *)needle {
    return (
        [self rangeOfString:needle options:NSCaseInsensitiveSearch].location !=
        NSNotFound);
}


- (NSString *)replaceSpaceWithSymbol {

    // First check if string indeed contains some spaces
    NSRange whiteSpaceRange =
        [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];

    if (whiteSpaceRange.location == NSNotFound) {
        return self;
    }


    return [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (NSString *)convertmySQLStringToDateFormattedString {

    dateFormatter = [[NSDateFormatter alloc] init];

    if (!self || ([self class] == [NSNull null])) {
        [dateFormatter setDateFormat:@"EEEE MMM d, yyyy"];
        return [dateFormatter stringFromDate:[NSDate date]];
    }

    NSMutableString *originalString =
        [[self stringByReplacingOccurrencesOfString:@"T"
                                         withString:@" "] mutableCopy];


    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];


    NSDate *temporaryDate = [dateFormatter
        dateFromString:[originalString
                           substringToIndex:(originalString.length - 6)]];

    [dateFormatter setDateFormat:@"EEEE MMM d, yyyy"];

    NSString *desiredDateInFinalFormat =
        [dateFormatter stringFromDate:temporaryDate];
    return desiredDateInFinalFormat;
}
@end

//
//  NSString+Utilities.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

-(BOOL)containsSubstringWithString:(NSString*)needle{
    return ([self rangeOfString:needle options:NSCaseInsensitiveSearch].location != NSNotFound);
}
@end

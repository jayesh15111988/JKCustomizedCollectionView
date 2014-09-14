//
//  JKImageInfoViewController.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKConstantsCollection.h"


@interface JKImageInfoViewController : UIViewController
@property (nonatomic,assign) ExtraImageInformationType extraInformationType;


@property (nonatomic,strong) NSDictionary* imageInformation;
@end

//
//  JKCollectionViewFlowLayout.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPinterestCollectionViewController.h"

@interface JKCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic, strong) NSArray* listOfKids;
@property (nonatomic,strong) JKPinterestCollectionViewController* collectionViewMainController;
- (id)init;

@end

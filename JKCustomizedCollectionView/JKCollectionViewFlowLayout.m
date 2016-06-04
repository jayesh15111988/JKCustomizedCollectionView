//
//  JKCollectionViewFlowLayout.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKCollectionViewFlowLayout.h"
#import "JKImageObjectModel.h"
#import "JKPinterestCollectionViewController.h"
#import "JKConstantsCollection.h"

// Source : http://skeuo.com/uicollectionview-custom-layout-tutorial

static CGFloat const defaultCellHeight = 310.0f;
static CGFloat const defaultCellWidth = 305.0f;
static CGFloat const defaultContentInsetsTop = 20.0f;
static CGFloat const defaultContentInsetsBottom = 0.0f;
static CGFloat const defaultContentInsetsLeftRight = 20.0f;
// static NSInteger const cellMinimumHeight = 320;
// static NSInteger const cellMaximumHeight = 600;

static NSString *const customLayoutCell =
    @"customizedCollectionViewCellIdentifier";

@interface JKCollectionViewFlowLayout ()

@property(nonatomic, strong) NSDictionary *layoutInfo;
@property(strong, nonatomic) NSMutableArray *itemAttributes;
@property(nonatomic, assign) CGSize contentSize;
@property(nonatomic, strong) NSMutableDictionary *cellLayoutInfo;
@property(nonatomic, assign) CGFloat totalContentHeightOfCollectionView;
@property(nonatomic, assign) CGFloat maxHeightForGivenRow;
@property(nonatomic, assign) BOOL isContentSizeFinalized;
@property(nonatomic, strong) JKImageObjectModel *imageModel;
@end

@implementation JKCollectionViewFlowLayout

- (void)setup {
    self.itemInsets = UIEdgeInsetsMake(
        defaultContentInsetsTop, defaultContentInsetsLeftRight,
        defaultContentInsetsBottom, defaultContentInsetsLeftRight);

    self.totalContentHeightOfCollectionView = 20;
    self.maxHeightForGivenRow = -100;
    self.itemSizeOfImage = CGSizeMake(defaultCellWidth, defaultCellHeight);
    self.interItemSpacingY = defaultContentInsetsTop;
    self.numberOfColumns = 3;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (void)prepareLayout {
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    self.cellLayoutInfo = [NSMutableDictionary dictionary];

    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];

    for (NSInteger section = 0; section < sectionCount; section++) {


        NSInteger itemCount =
            [self.collectionView numberOfItemsInSection:section];

        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];

            UICollectionViewLayoutAttributes *itemAttributes =
                [UICollectionViewLayoutAttributes
                    layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame =
                [self frameForAlbumPhotoAtIndexPath:indexPath];

            self.cellLayoutInfo[indexPath] = itemAttributes;
        }
    }

    newLayoutInfo[customLayoutCell] = self.cellLayoutInfo;

    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;


    CGFloat spacingX = self.collectionView.bounds.size.width -
                       self.itemInsets.left - self.itemInsets.right -
                       (self.numberOfColumns * self.itemSize.width);

    self.imageModel =
        (JKImageObjectModel *)self.listOfPhotos[indexPath.section];

    DLog(@"Section number %ld and height increment %f", (long)indexPath.section,
         self.imageModel.heightToIncrementForCell);

    CGFloat randomHeightOfCurrentCell =
        self.itemSize.height +
        stepIncrementForCellHeight *
            (self.imageModel.heightToIncrementForCell - 1);

    if (!self.isContentSizeFinalized) {
        if (randomHeightOfCurrentCell > self.maxHeightForGivenRow) {
            self.maxHeightForGivenRow = randomHeightOfCurrentCell;
        }

        if ((indexPath.section + 1) % 3 == 0 ||
            ((indexPath.section + 1) ==
             [self.collectionView numberOfSections])) {

            self.totalContentHeightOfCollectionView +=
                self.maxHeightForGivenRow + 20;
            self.maxHeightForGivenRow = -100;
        }
    }

    DLog(@"%f", self.totalContentHeightOfCollectionView);

    if (self.numberOfColumns > 1) {

        spacingX = spacingX / (self.numberOfColumns - 1);
    }

    CGFloat originX = floorf(self.itemInsets.left +
                             (self.itemSize.width + spacingX) * column);

    CGFloat originY =
        floor(self.itemInsets.top +
              (self.itemSize.height + self.interItemSpacingY) * row);

    CGFloat YValueForCurrentCell = originY;

    // Now check height of cell right above our current cell only if cell does
    // not follow in the first row
    if (indexPath.section >= self.numberOfColumns) {

        // Grabbing the size parameters for the cell right above the current one
        UICollectionViewLayoutAttributes *itemAttributes = [self.cellLayoutInfo
            objectForKey:[NSIndexPath indexPathForRow:0
                                            inSection:indexPath.section - 3]];

        DLog(@"%f height of elemtns above it",
             itemAttributes.frame.size.height);

        YValueForCurrentCell = itemAttributes.frame.origin.y +
                               itemAttributes.frame.size.height +
                               defaultContentInsetsTop;
    }


    return CGRectMake(originX, YValueForCurrentCell, self.itemSize.width,
                      randomHeightOfCurrentCell);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes =
        [NSMutableArray arrayWithCapacity:self.layoutInfo.count];

    [self.layoutInfo
        enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                            NSDictionary *elementsInfo,
                                            BOOL *stop) {
            [elementsInfo enumerateKeysAndObjectsUsingBlock:
                              ^(NSIndexPath *indexPath,
                                UICollectionViewLayoutAttributes *attributes,
                                BOOL *innerStop) {
                                  if (CGRectIntersectsRect(rect,
                                                           attributes.frame)) {
                                      [allAttributes addObject:attributes];
                                  }
                              }];
        }];

    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:
                                          (NSIndexPath *)indexPath {
    return self.layoutInfo[customLayoutCell][indexPath];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width,
                      self.totalContentHeightOfCollectionView);
}

@end

//
//  JKCollectionViewFlowLayout.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKCollectionViewFlowLayout.h"

//Source : http://skeuo.com/uicollectionview-custom-layout-tutorial

static float const defaultCellHeight = 250.0f;
static float const defaultCellWidth = 310.0f;
static float const defaultContentInsetsTopBottom = 20.0f;
static float const defaultContentInsetsLeftRight = 20.0f;


static NSString* const customLayoutCell = @"customizedCollectionViewCellIdentifier";

@interface JKCollectionViewFlowLayout ()

@property (nonatomic, strong) NSDictionary* layoutInfo;
@property (strong, nonatomic) NSMutableArray* itemAttributes;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSMutableDictionary* cellLayoutInfo;
@property (nonatomic,assign) float totalContentHeightOfCollectionView;
@property (nonatomic,assign) float maxHeightForGivenRow;
@end

@implementation JKCollectionViewFlowLayout

- (void)setup {
    self.itemInsets = UIEdgeInsetsMake (defaultContentInsetsTopBottom, defaultContentInsetsLeftRight, defaultContentInsetsTopBottom, defaultContentInsetsLeftRight);
    self.totalContentHeightOfCollectionView=0;
    self.maxHeightForGivenRow=-100;
    self.itemSize = CGSizeMake (defaultCellWidth, defaultCellHeight);
    self.interItemSpacingY = defaultContentInsetsTopBottom;
    self.numberOfColumns = 3;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)prepareLayout {
    NSMutableDictionary* newLayoutInfo = [NSMutableDictionary dictionary];
    self.cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes* itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];

            self.cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[customLayoutCell] = self.cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath*)indexPath {
    
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    
    CGFloat spacingX = self.collectionView.bounds.size.width -
    self.itemInsets.left -
    self.itemInsets.right -
    (self.numberOfColumns * self.itemSize.width);
    
    
    float randomHeightOfCurrentCell=300 + arc4random() % (600 - 300);
    
    if(randomHeightOfCurrentCell>self.maxHeightForGivenRow){
        self.maxHeightForGivenRow=randomHeightOfCurrentCell;
    }
    

    
    if((indexPath.section+1)%3==0 || ((indexPath.section+1)==[self.collectionView numberOfSections])){

        self.totalContentHeightOfCollectionView+=self.maxHeightForGivenRow;
        self.maxHeightForGivenRow=-100;
    }

    DLog(@"%f",self.totalContentHeightOfCollectionView);
    
    if (self.numberOfColumns > 1)
    {
        
        spacingX = spacingX / (self.numberOfColumns - 1);
    }
    
    CGFloat originX = floorf (self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor (self.itemInsets.top +
                             (self.itemSize.height + self.interItemSpacingY) * row);
    
    float YValueForCurrentCell = originY;
    
    //Now check height of cell right above our current cell only if cell does not follow in the first row
    if (indexPath.section >= self.numberOfColumns) {
        
        //Grabbing the size parameters for the cell right above the current one
        UICollectionViewLayoutAttributes* itemAttributes =
        [self.cellLayoutInfo objectForKey:[NSIndexPath indexPathForRow:0 inSection:indexPath.section - 3]];
        
        DLog(@"%f height of elemtns above it",itemAttributes.frame.size.height);
        
        YValueForCurrentCell=itemAttributes.frame.origin.y+itemAttributes.frame.size.height+defaultContentInsetsTopBottom;
        
    }
    
    

    

    
    return CGRectMake (originX, YValueForCurrentCell, self.itemSize.width, randomHeightOfCurrentCell);
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString* elementIdentifier,
                                                         NSDictionary* elementsInfo,
                                                         BOOL* stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
    return self.layoutInfo[customLayoutCell][indexPath];
}

- (CGSize)collectionViewContentSize {
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    // make sure we count another row if one is only partially filled
    if ([self.collectionView numberOfSections] % self.numberOfColumns) rowCount++;
    
    DLog(@"%f value is",self.totalContentHeightOfCollectionView);
//    self.collectionView.frame=CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.totalContentHeightOfCollectionView)
    return CGSizeMake (self.collectionView.bounds.size.width, self.totalContentHeightOfCollectionView);
}

@end

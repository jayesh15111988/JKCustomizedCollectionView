//
//  JKPinterestCollectionViewController.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKPinterestCollectionViewController.h"
#import "JKCollectionViewCustomizedCell.h"
#import "JKCollectionViewFlowLayout.h"

static NSString* cellIdentifier = @"customizedCollectionViewCellIdentifier";

@interface JKPinterestCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet JKCollectionViewFlowLayout *mainCollectionViewLayout;


@end

@implementation JKPinterestCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainCollectionViewLayout.collectionViewMainController=self;
    [self.mainCollectionView reloadData];

}

#pragma mark delegate Collection view methods
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    
    JKCollectionViewCustomizedCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageView.clipsToBounds=YES;
    [cell setBackgroundColor:[UIColor redColor]];
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
    DLog(@"Item selected in collection view at section number %d",indexPath.section);
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 20;
}


@end

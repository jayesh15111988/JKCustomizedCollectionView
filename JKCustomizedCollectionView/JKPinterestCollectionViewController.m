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
#import "JKConstantsCollection.h"

//Popup view controller for custom animation
#import "UIViewController+MJPopupViewController.h"

//Showing some extra information for selected image sets
#import "JKImageInfoViewController.h"

#import <SDWebImage/SDWebImageManager.h>
#import  <JKEasyAFNetworking/JKNetworkActivity.h>

static NSString* cellIdentifier = @"customizedCollectionViewCellIdentifier";

@interface JKPinterestCollectionViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet JKCollectionViewFlowLayout *mainCollectionViewLayout;

@property (strong,nonatomic) NSArray* listOfPhotos;

@property (weak, nonatomic) IBOutlet UITextField *pageNumber;
@property (weak, nonatomic) IBOutlet UITextField *searchTerm;
@property (weak, nonatomic) IBOutlet UITextField *numberOfResultsPerPage;
- (IBAction)getImagesButtonPressed:(UIButton*)sender;
@end

@implementation JKPinterestCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainCollectionViewLayout.collectionViewMainController=self;
}

#pragma mark delegate Collection view methods
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    
    JKCollectionViewCustomizedCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell customizeCellWithPhotoDetails:self.listOfPhotos[indexPath.section]];
    
    
    
    cell.getImageInfo=^(NSDictionary* imageInfoForSelectedItem){
    
        JKImageInfoViewController* imageInformationController=(JKImageInfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"imageinfo"];
        imageInformationController.imageInformation=imageInfoForSelectedItem;
        [self presentPopupViewController:imageInformationController animationType:4];
        
    };
    
    cell.getAuthorInfo=^(NSDictionary* authorInfoForSelectedItem){
        
        JKImageInfoViewController* authorInformationController=(JKImageInfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"imageinfo"];
        authorInformationController.imageInformation=authorInfoForSelectedItem;
        [self presentPopupViewController:authorInformationController animationType:4];
        
    };
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
    DLog(@"Item selected in collection view at section number %d",indexPath.section);
    JKCollectionViewCustomizedCell* selectedCell=(JKCollectionViewCustomizedCell*)[self.mainCollectionView cellForItemAtIndexPath:indexPath];
    DLog(@"Cell properties are %f and %f",selectedCell.frame.origin.x,selectedCell.frame.origin.y);
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return [self.listOfPhotos count];
}


- (IBAction)getImagesButtonPressed:(UIButton*)sender {
    
    JKNetworkActivity* getImagesNetworkRequest=[[JKNetworkActivity alloc] initWithData:nil andAuthorizationToken:nil];
    
    
    [getImagesNetworkRequest communicateWithServerWithMethod:0 andIsFullURL:NO andPathToAPI:[NSString stringWithFormat:@"photos/search?term=%@&page=%@&rpp=%@&consumer_key=%@",self.searchTerm.text,self.pageNumber.text,self.numberOfResultsPerPage.text,CONSUMER_KEY] andParameters:nil completion:^(id successResponse) {

        self.listOfPhotos=successResponse[@"photos"];
        [self.mainCollectionView reloadData];
        
    }
                                                     failure:^(NSError* errorResponse) {
                                                         
                                                         
                                                         DLog(@"api request failed with error %@",[errorResponse description]);
                                                     }];
    
    
}
@end

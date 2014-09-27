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
#import "JKImageObjectModel.h"
#import "NSString+Utilities.h"

// Popup view controller for custom animation
#import "UIViewController+MJPopupViewController.h"

// Showing some extra information for selected image sets
#import "JKImageInfoViewController.h"

#import <JKEasyAFNetworking/JKNetworkActivity.h>

static NSString *cellIdentifier = @"customizedCollectionViewCellIdentifier";

@interface JKPinterestCollectionViewController ()
@property(weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property(weak, nonatomic)
    IBOutlet JKCollectionViewFlowLayout *mainCollectionViewLayout;

@property(strong, nonatomic) NSArray *listOfPhotos;


@property(weak, nonatomic) IBOutlet UITextField *pageNumber;
@property(weak, nonatomic) IBOutlet UITextField *searchTerm;
@property(weak, nonatomic) IBOutlet UITextField *numberOfResultsPerPage;
@property(weak, nonatomic) IBOutlet UIView *initialWelcomeView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)getImagesButtonPressed:(UIButton *)sender;
@end

@implementation JKPinterestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainCollectionViewLayout.collectionViewMainController = self;
}

#pragma mark delegate Collection view methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    JKCollectionViewCustomizedCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                  forIndexPath:indexPath];

    [cell customizeCellWithPhotoDetails:self.listOfPhotos[indexPath.section]];


    __weak typeof(JKCollectionViewCustomizedCell *)weakCell = cell;
    cell.getImageInfo = ^(JKImageObjectModel *imageInfoForSelectedItem) {

        __strong __typeof(JKCollectionViewCustomizedCell *)strongCell =
            weakCell;

        JKImageInfoViewController *imageInformationController =
            (JKImageInfoViewController *)[self.storyboard
                instantiateViewControllerWithIdentifier:@"imageinfo"];
        imageInformationController.imageInformation = imageInfoForSelectedItem;
        imageInformationController.extraInformationType = ExtraImageInformation;

        imageInformationController.view.frame = CGRectMake(
            strongCell.frame.origin.x - 190, strongCell.frame.origin.y + 50,
            currentViewWidth, currentViewHeight);


        [self showExtraInformationViewWithViewController:
                  imageInformationController];
    };

    cell.getAuthorInfo =
        ^(JKImageAuthorObjectModel *authorInfoForSelectedItem) {

        __strong __typeof(JKCollectionViewCustomizedCell *)strongCell =
            weakCell;

        JKImageInfoViewController *authorInformationController =
            (JKImageInfoViewController *)[self.storyboard
                instantiateViewControllerWithIdentifier:@"imageinfo"];
        authorInformationController.imageAuthorInformation =
            authorInfoForSelectedItem;
        authorInformationController.extraInformationType =
            ExtraImageAuthorInformation;

        authorInformationController.view.frame = CGRectMake(
            strongCell.frame.origin.x - 80, strongCell.frame.origin.y + 50,
            currentViewWidth, currentViewHeight);


        [self showExtraInformationViewWithViewController:
                  authorInformationController];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"Item selected in collection view at section number %d",
         indexPath.section);
    JKCollectionViewCustomizedCell *selectedCell =
        (JKCollectionViewCustomizedCell *)
        [self.mainCollectionView cellForItemAtIndexPath:indexPath];
    DLog(@"Cell properties are %f and %f", selectedCell.frame.origin.x,
         selectedCell.frame.origin.y);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:
                 (UICollectionView *)collectionView {
    return [self.listOfPhotos count];
}


- (IBAction)getImagesButtonPressed:(UIButton *)sender {


    [self.mainCollectionViewLayout setup];
    [self.activityIndicator startAnimating];

    NSString *stringWithStrippedSpaces =
        [self.searchTerm.text replaceSpaceWithSymbol];

    [UIView animateWithDuration:2.0f
                     animations:^{
                         [self.mainCollectionView setAlpha:1.0];
                         [self.initialWelcomeView setAlpha:0.0];
                     }
                     completion:nil];


    JKNetworkActivity *getImagesNetworkRequest =
        [[JKNetworkActivity alloc] initWithData:nil andAuthorizationToken:nil];


    [getImagesNetworkRequest communicateWithServerWithMethod:0
        andIsFullURL:NO
        andPathToAPI:
            [NSString
                stringWithFormat:
                    @"photos/search?term=%@&page=%@&rpp=%@&consumer_key=%@",
                    stringWithStrippedSpaces, self.pageNumber.text,
                    self.numberOfResultsPerPage.text, CONSUMER_KEY]
        andParameters:nil
        completion:^(id successResponse) {

            self.listOfPhotos = [JKImageObjectModel
                getObjectModelsFromImageInfoDictionary:successResponse[
                                                           @"photos"]];

            self.mainCollectionViewLayout.listOfPhotos = self.listOfPhotos;
            [self.mainCollectionView reloadData];
            [self.activityIndicator stopAnimating];
        }
        failure:^(NSError *errorResponse) {


            DLog(@"api request failed with error %@",
                 [errorResponse description]);
        }];
}

- (void)showExtraInformationViewWithViewController:
            (JKImageInfoViewController *)extraImageInformationController {
    extraImageInformationController.view.transform =
        CGAffineTransformMakeScale(0.1, 0.1);

    [self addChildViewController:extraImageInformationController];
    [self.view addSubview:extraImageInformationController.view];
    [extraImageInformationController didMoveToParentViewController:self];


    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:defaultAnimationDuration
        delay:0.0
        usingSpringWithDamping:0.3
        initialSpringVelocity:10
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{

            __strong __typeof(weakSelf) strongSelf = weakSelf;
            extraImageInformationController.view.frame = CGRectMake(
                strongSelf.view.center.x, 400,
                extraImageInformationController.view.frame.size.width,
                extraImageInformationController.view.frame.size.height);


            extraImageInformationController.view.transform =
                CGAffineTransformMakeScale(1, 1);
        }
        completion:^(BOOL finished) { DLog(@"Finished"); }];
}
@end

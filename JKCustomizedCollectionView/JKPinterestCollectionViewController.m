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
#import "JKFullImageDisplayControllerViewController.h"

// Popup view controller for custom animation
#import "UIViewController+MJPopupViewController.h"

// Showing some extra information for selected image sets
#import "JKImageInfoViewController.h"

#import <JKEasyAFNetworking/JKNetworkActivity.h>

static NSString *cellIdentifier = @"customizedCollectionViewCellIdentifier";

@interface CustomTapGestureRecognizer : UITapGestureRecognizer

@property(nonatomic, strong) JKImageAuthorObjectModel *imageAuthorModel;
@property(nonatomic, strong) JKImageObjectModel *imageModel;
@property(nonatomic, strong) NSURL *remoteImageURL;

@end


@implementation CustomTapGestureRecognizer

@end

@interface JKPinterestCollectionViewController () <UIGestureRecognizerDelegate>
@property(weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property(weak, nonatomic)
    IBOutlet JKCollectionViewFlowLayout *mainCollectionViewLayout;

@property(strong, nonatomic) NSArray *listOfPhotos;


@property(weak, nonatomic) IBOutlet UITextField *pageNumber;
@property(weak, nonatomic) IBOutlet UITextField *searchTerm;
@property(weak, nonatomic) IBOutlet UITextField *numberOfResultsPerPage;
@property(weak, nonatomic) IBOutlet UIView *initialWelcomeView;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic, strong)
    JKImageInfoViewController *previousSelectedImageInfoViewController;

// Error Message view elements
@property(weak, nonatomic) IBOutlet UIView *errorMessageView;
@property(weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
- (IBAction)closeErrorMessageViewButtonPressed:(id)sender;

- (IBAction)getImagesButtonPressed:(UIButton *)sender;
@end

@implementation JKPinterestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainCollectionViewLayout.collectionViewMainController = self;
    self.mainCollectionViewLayout.itemSize = CGSizeMake(310, 305);
}

#pragma mark delegate Collection view methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    JKCollectionViewCustomizedCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                  forIndexPath:indexPath];


    cell.individualImageProperties = self.listOfPhotos[indexPath.section];
    [cell customizeCellWithPhotoDetails];


    CustomTapGestureRecognizer *imageInfoButtonTapRecognizer =
        [[CustomTapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(imageInformationButtonTapped:)];

    imageInfoButtonTapRecognizer.imageModel = cell.individualImageProperties;


    CustomTapGestureRecognizer *authorInfoButtonTapRecognizer =
        [[CustomTapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(authorInformationButtonTapped:)];
    authorInfoButtonTapRecognizer.imageAuthorModel =
        cell.individualImageProperties.authorModelForCurrentImage;


    CustomTapGestureRecognizer *displayFullImageButtonTapRecognizer =
        [[CustomTapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(displayFullImageButtonTapped:)];

    displayFullImageButtonTapRecognizer.remoteImageURL =
        cell.individualImageProperties.iconImageBigURL;


    [imageInfoButtonTapRecognizer setDelegate:self];
    [authorInfoButtonTapRecognizer setDelegate:self];

    [cell.getImageInfoButton addGestureRecognizer:imageInfoButtonTapRecognizer];
    [cell.getAuthorInfoButton
        addGestureRecognizer:authorInfoButtonTapRecognizer];
    [cell.displayFullImageButton
        addGestureRecognizer:displayFullImageButtonTapRecognizer];


    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:
                 (UICollectionView *)collectionView {
    return [self.listOfPhotos count];
}


- (IBAction)closeErrorMessageViewButtonPressed:(id)sender {

    self.errorMessageLabel.text = @"No Errors";

    [UIView animateWithDuration:1
        delay:0
        usingSpringWithDamping:0.7
        initialSpringVelocity:5
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.errorMessageView.frame = CGRectMake(330, -300, 375, 270);
        }
        completion:^(BOOL finished) {}];
}

- (IBAction)getImagesButtonPressed:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (![self.numberOfResultsPerPage.text isThisStringNumeric] ||
        ![self.pageNumber.text isThisStringNumeric]) {

        [self
            showAlertWithErrorMessage:@"Please Enter valid search parameters"];
        return;
    }

    sender.enabled = NO;

    if ([self.numberOfResultsPerPage.text integerValue] > 100) {
        self.numberOfResultsPerPage.text = @"100";
    }


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
                    @"photos/search?term=%@&page=%@&rpp=%@&image_size=4&consumer_key=%@",
                    stringWithStrippedSpaces, self.pageNumber.text,
                    self.numberOfResultsPerPage.text, CONSUMER_KEY]
        andParameters:nil
        completion:^(id successResponse) {

            sender.enabled = YES;

            self.listOfPhotos = [JKImageObjectModel
                getObjectModelsFromImageInfoDictionary:successResponse[
                                                           @"photos"]];

            self.mainCollectionViewLayout.listOfPhotos = self.listOfPhotos;
            [self.mainCollectionView reloadData];
            [self.activityIndicator stopAnimating];
        }
        failure:^(NSError *errorResponse) {

            sender.enabled = YES;
            [self
                showAlertWithErrorMessage:
                    [NSString
                        stringWithFormat:@"Error occurred with description %@",
                                         [errorResponse localizedDescription]]];
            DLog(@"api request failed with error %@",
                 [errorResponse description]);
        }];
}

- (void)showExtraInformationViewWithViewController:
            (UIViewController *)extraImageInformationController
                               andPositionOnScreen:
                                   (CGPoint)positionOnScreenForNewView {

    extraImageInformationController.view.transform =
        CGAffineTransformMakeScale(0.1, 0.1);

    [self addChildViewController:extraImageInformationController];
    [self.view addSubview:extraImageInformationController.view];
    [extraImageInformationController didMoveToParentViewController:self];

    
    [UIView animateWithDuration:defaultAnimationDuration
        delay:0.0
        usingSpringWithDamping:0.7
        initialSpringVelocity:5
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{

            extraImageInformationController.view.frame = CGRectMake(
                positionOnScreenForNewView.x,
                positionOnScreenForNewView.y,
                extraImageInformationController.view.frame.size.width,
                extraImageInformationController.view.frame.size.height);


            extraImageInformationController.view.transform =
                CGAffineTransformMakeScale(1, 1);
        }
        completion:^(BOOL finished) { DLog(@"Finished"); }];
}

#pragma mark touch gesture recognizer delegate methods

- (void)imageInformationButtonTapped:(CustomTapGestureRecognizer *)sender {

    // User cannot open multiple popup for given image information
    if (self.previousSelectedImageInfoViewController) {
        [self.previousSelectedImageInfoViewController
                removeCurrentViewControllerFromParent];
    }

    __weak typeof(self) weakSelf = self;

    CGFloat originatingXCoordinate = [sender locationInView:self.view].x - 250;
    CGFloat originatingYCoordinate = [sender locationInView:self.view].y - 300;

    JKImageInfoViewController *imageInformationController =
        (JKImageInfoViewController *)
        [self.storyboard instantiateViewControllerWithIdentifier:@"imageinfo"];
    imageInformationController.imageInformation = sender.imageModel;
    imageInformationController.extraInformationType = ExtraImageInformation;


    imageInformationController.fullImageClosePopup = ^() {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf nullifyPreviousViewController];
    };

    self.previousSelectedImageInfoViewController = imageInformationController;

    imageInformationController.view.frame =
        CGRectMake(originatingXCoordinate, originatingYCoordinate,
                   currentViewWidth, currentViewHeight);
    imageInformationController.endingCoordinateOnScreen =
        CGPointMake(originatingXCoordinate, originatingYCoordinate);


    [self showExtraInformationViewWithViewController:imageInformationController
                                 andPositionOnScreen:CGPointMake(self.view.center.x, 400)];
}

- (void)authorInformationButtonTapped:(CustomTapGestureRecognizer *)sender {


    // User cannot open multiple popup for given photographer information
    if (self.previousSelectedImageInfoViewController) {
        [self.previousSelectedImageInfoViewController
                removeCurrentViewControllerFromParent];
    }

    __weak typeof(self) weakSelf = self;
    CGFloat originatingXCoordinate = [sender locationInView:self.view].x - 250;
    CGFloat originatingYCoordinate = [sender locationInView:self.view].y - 300;


    JKImageInfoViewController *authorInformationController =
        (JKImageInfoViewController *)
        [self.storyboard instantiateViewControllerWithIdentifier:@"imageinfo"];
    authorInformationController.imageAuthorInformation =
        sender.imageAuthorModel;
    authorInformationController.extraInformationType =
        ExtraImageAuthorInformation;

    authorInformationController.fullImageClosePopup = ^() {

        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf nullifyPreviousViewController];
    };

    self.previousSelectedImageInfoViewController = authorInformationController;

    authorInformationController.view.frame =
        CGRectMake(originatingXCoordinate, originatingYCoordinate,
                   currentViewWidth, currentViewHeight);
    authorInformationController.endingCoordinateOnScreen =
        CGPointMake(originatingXCoordinate, originatingYCoordinate);

    [self showExtraInformationViewWithViewController:authorInformationController
                                 andPositionOnScreen:CGPointMake(self.view.center.x, 400)];
}

- (void)displayFullImageButtonTapped:(CustomTapGestureRecognizer *)sender {
    

    // 1024 1024/2 - 1024/8
    // 768 768/2 - 768/8
    CGFloat originatingXCoordinate = [sender locationInView:self.view].x - 384;
    CGFloat originatingYCoordinate = [sender locationInView:self.view].y - 512;

    JKFullImageDisplayControllerViewController *fullImageDisplayController =
        (JKFullImageDisplayControllerViewController *)[self.storyboard
            instantiateViewControllerWithIdentifier:@"fullimagedisplay"];
    fullImageDisplayController.remoteImageFullURL = sender.remoteImageURL;
    
    fullImageDisplayController.endingCoordinateOnScreen =
        CGPointMake(originatingXCoordinate, originatingYCoordinate);

    fullImageDisplayController.view.frame =
        CGRectMake(originatingXCoordinate, originatingYCoordinate,
                   fullImageDisplayController.view.frame.size.width,
                   self.view.frame.size.height - 65);
    [self showExtraInformationViewWithViewController:fullImageDisplayController
                                     andPositionOnScreen:CGPointMake(self.view.center.x - 55, 440)];
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (void)showAlertWithErrorMessage:(NSString *)errorMessage {
    self.errorMessageLabel.text = errorMessage;

    [UIView animateWithDuration:1
        delay:0
        usingSpringWithDamping:0.7
        initialSpringVelocity:5
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.errorMessageView.frame = CGRectMake(330, 300, 375, 270);
        }
        completion:^(BOOL finished) {}];
}

- (void)nullifyPreviousViewController {
    self.previousSelectedImageInfoViewController = nil;
}
@end

//
//  JKImageInfoViewController.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKImageInfoViewController.h"
#import "JKImageObjectModel.h"
#import "JKConstantsCollection.h"
#import "JKExtraImageInformationTableViewCell.h"
#import "NSString+Utilities.h"
#import <SDWebImage/SDWebImageManager.h>

static NSString *informationCellIdentifier = @"infocell";

@interface JKImageInfoViewController ()
@property(weak, nonatomic) IBOutlet UITableView *imageInfoTableView;
@property(strong, nonatomic) SDWebImageManager *manager;
@property(strong, nonatomic) NSArray *imageInformationAttributesCollection;
@property(weak, nonatomic) IBOutlet UILabel *extraImageInformationLabel;


// Close the current extra information view
- (IBAction)closeViewButtonPressed:(id)sender;

@end

@implementation JKImageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [SDWebImageManager sharedManager];

    // This is delicate, if something changes on server, then we are in big
    // trouble

    self.view.frame =
        CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                   currentViewWidth, currentViewHeight);

    self.imageInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.imageInfoTableView.estimatedRowHeight = 70;
    self.imageInfoTableView.tableFooterView = [[UIView alloc] init];
    
    if (self.extraInformationType == ExtraImageAuthorInformation) {

        self.extraImageInformationLabel.text = @"Photographer Information";
        self.imageInformationAttributesCollection = @[
            @{ @"displayName" : @"Icon",
               @"backgroundName" : @"userpic_url" },
            @{
                @"displayName" : @"User Name",
                @"backgroundName" : @"username"
            },
            @{
                @"displayName" : @"First Name",
                @"backgroundName" : @"firstname"
            },
            @{
                @"displayName" : @"Last Name",
                @"backgroundName" : @"lastname"
            },
            @{ @"displayName" : @"City",
               @"backgroundName" : @"city" },
            @{
                @"displayName" : @"Country of Residence",
                @"backgroundName" : @"country"
            },
            @{
                @"displayName" : @"Account Upgraded?",
                @"backgroundName" : @"upgrade_status"
            },
            @{
                @"displayName" : @"Affection Count",
                @"backgroundName" : @"affection"
            },
            @{
                @"displayName" : @"Followers",
                @"backgroundName" : @"followers_count"
            }
        ];
    } else if (self.extraInformationType == ExtraImageInformation) {

        self.extraImageInformationLabel.text = @"Photograph Information";

        self.imageInformationAttributesCollection = @[
            @{ @"displayName" : @"Icon",
               @"backgroundName" : @"image_url" },
            @{
                @"displayName" : @"Apearature Size",
                @"backgroundName" : @"aperture"
            },
            @{ @"displayName" : @"Camera",
               @"backgroundName" : @"camera" },
            @{
                @"displayName" : @"Created On",
                @"backgroundName" : @"created_at"
            },
            @{
                @"displayName" : @"Description",
                @"backgroundName" : @"description"
            },
            @{
                @"displayName" : @"Favorited Count",
                @"backgroundName" : @"favorites_count"
            },
            @{
                @"displayName" : @"Focal Length",
                @"backgroundName" : @"focal_length"
            },
            @{ @"displayName" : @"ISO",
               @"backgroundName" : @"iso" },
            @{
                @"displayName" : @"Location",
                @"backgroundName" : @"locations"
            },
            @{ @"displayName" : @"Latitude",
               @"backgroundName" : @"latitude" },
            @{
                @"displayName" : @"Longitude",
                @"backgroundName" : @"longitude"
            },
            @{ @"displayName" : @"Name",
               @"backgroundName" : @"name" },
            @{
                @"displayName" : @"Shutter Speed",
                @"backgroundName" : @"shutter_speed"
            },
            @{
                @"displayName" : @"Captured On",
                @"backgroundName" : @"taken_at"
            },
            @{
                @"displayName" : @"Views",
                @"backgroundName" : @"times_viewed"
            }
        ];
    }

    [self.imageInfoTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

    return [self.imageInformationAttributesCollection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JKExtraImageInformationTableViewCell *cell =
        (JKExtraImageInformationTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:informationCellIdentifier
                                        forIndexPath:indexPath];


    NSString *attributeName = self.imageInformationAttributesCollection
                                  [indexPath.row][@"displayName"];
    cell.imageAttributeName.text =
        [NSString stringWithFormat:@"%@", attributeName];


    NSString *attributeValue = @"";

    if (self.extraInformationType == ExtraImageInformation) {
        switch (indexPath.row) {
        case 1:
            attributeValue = self.imageInformation.apertureSize;
            break;
        case 2:
            attributeValue = self.imageInformation.camera;
            break;
        case 3:
            attributeValue = [NSString
                stringWithFormat:@"%@", self.imageInformation.createdOn];
            break;
        case 4:
            attributeValue = self.imageInformation.imageDescription;
            break;
        case 5:
            attributeValue = self.imageInformation.favoritesCount;

            break;
        case 6:
            attributeValue = self.imageInformation.focalLength;
            break;
        case 7:
            attributeValue = self.imageInformation.ISO;
            break;
        case 8:
            attributeValue = self.imageInformation.locations;
            break;
        case 9:
            attributeValue = self.imageInformation.latitude;
            break;
        case 10:
            attributeValue = self.imageInformation.longitude;
            break;
        case 11:
            attributeValue = self.imageInformation.imageName;
            break;
        case 12:
            attributeValue = self.imageInformation.shutterSpeed;
            break;
        case 13:
            attributeValue = [NSString
                stringWithFormat:@"%@", self.imageInformation.takenOn];
            break;
        case 14:
            attributeValue = self.imageInformation.views;
            break;
        default:
            break;
        }

    } else if (self.extraInformationType == ExtraImageAuthorInformation) {
        switch (indexPath.row) {
        case 1:
            attributeValue = self.imageAuthorInformation.username;
            break;
        case 2:
            attributeValue = self.imageAuthorInformation.firstName;
            break;
        case 3:
            attributeValue = self.imageAuthorInformation.lastName;
            break;
        case 4:
            attributeValue = self.imageAuthorInformation.city;
            break;
        case 5:
            attributeValue = self.imageAuthorInformation.country;
            break;
        case 6:
            attributeValue =
                [NSString stringWithFormat:@"%d", self.imageAuthorInformation
                                                      .accountUpgradeFlag];
            break;
        case 7:
            attributeValue = self.imageAuthorInformation.affectionCount;
            break;
        case 8:
            attributeValue = self.imageAuthorInformation.followers;
            break;
        default:
            break;
        }
    }

    cell.imageIcon.hidden = !(indexPath.row == 0);
    cell.imageAttributeValue.hidden = !cell.imageIcon.hidden;

    if (indexPath.row == 0) {


        if (!cell.imageIcon.hidden) {

            NSURL *iconURL;
            if (self.extraInformationType == ExtraImageInformation) {
                iconURL = self.imageInformation.iconImageURL;
            } else {
                iconURL = self.imageAuthorInformation.authorIconURL;
            }

            if (iconURL) {

                [self.manager downloadImageWithURL:iconURL
                    options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {

                        // Do something with image download progress work
                    }
                    completed:^(UIImage *image, NSError *error,
                                SDImageCacheType cacheType, BOOL finished,
                                NSURL *imageURL) {
                        // Once image download is complete stick it to the
                        // storyboard
                        if (image) {
                            [cell.imageIcon setImage:image];
                            cell.accessoryType =
                                UITableViewCellAccessoryCheckmark;
                        } else {
                            [cell.imageIcon
                                setImage:[UIImage imageNamed:@"noImage.png"]];
                            cell.accessoryType = UITableViewCellAccessoryNone;
                        }
                    }];

            } else {
                [cell.imageIcon setImage:[UIImage imageNamed:@"noImage.png"]];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

        } else {

            cell.imageAttributeValue.text = [NSString
                stringWithFormat:@"%@", attributeValue ?: @"Not Available"];
        }
    }

    if (indexPath.row != 0) {
        if ([attributeValue isNull] || ![attributeValue length] ||
            [attributeValue isEqualToString:notSpecifiedDisplayString]) {
            cell.imageAttributeValue.text = notSpecifiedDisplayString;
            cell.accessoryType = UITableViewCellAccessoryNone;

        } else {
            cell.imageAttributeValue.text = attributeValue;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }


    return cell;
}

- (IBAction)closeViewButtonPressed:(id)sender {

    [self removeCurrentViewControllerFromParent];
}

- (void)removeCurrentViewControllerFromParent {

    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:1.0
        delay:0.0
        usingSpringWithDamping:1.0
        initialSpringVelocity:1
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            strongSelf.view.frame =
                CGRectMake(strongSelf.endingCoordinateOnScreen.x,
                           strongSelf.endingCoordinateOnScreen.y,
                           strongSelf.view.frame.size.width,
                           strongSelf.view.frame.size.height);

            strongSelf.view.transform = CGAffineTransformMakeScale(0, 0);
        }
        completion:^(BOOL finished) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;

            // Literally remove the view from current parent view controller's
            // children hierarchy
            [strongSelf willMoveToParentViewController:nil];
            [strongSelf.view removeFromSuperview];
            [strongSelf removeFromParentViewController];

            DLog(@"%@ strong self", self);
            if (strongSelf.fullImageClosePopup) {
                strongSelf.fullImageClosePopup();
            }
        }];
}
@end

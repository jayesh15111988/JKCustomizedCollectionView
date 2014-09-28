//
//  JKFullImageDisplayControllerViewController.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/27/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <SDWebImage/SDWebImageManager.h>
#import "JKFullImageDisplayControllerViewController.h"
#import "JKConstantsCollection.h"
#import "UIImage+Utilities.h"

@interface JKFullImageDisplayControllerViewController ()

- (IBAction)closeButtonPressed:(id)sender;
@property(weak, nonatomic) IBOutlet UIImageView *fullImageDisplayImageView;
@property(weak, nonatomic)
    IBOutlet UIActivityIndicatorView *activityIndicatorForLoadingImage;


@end

@implementation JKFullImageDisplayControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.activityIndicatorForLoadingImage startAnimating];
    __weak typeof(self) weakSelf = self;

    __block CGFloat imageWidthToAdjust = 1020;

    self.fullImageDisplayImageView.alpha = 0;

    [[SDWebImageManager sharedManager]
        downloadImageWithURL:self.remoteImageFullURL
        options:0
        progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                    BOOL finished, NSURL *imageURL) {


            __strong __typeof(weakSelf) strongSelf = weakSelf;

            [strongSelf.activityIndicatorForLoadingImage stopAnimating];

            if (image) {

                image =
                    [image imageWithImageScaledToDimension:imageWidthToAdjust
                                                   isWidth:YES];
                [strongSelf.fullImageDisplayImageView setImage:image];
            } else {
                [strongSelf.fullImageDisplayImageView
                    setImage:[UIImage imageNamed:@"noImage.png"]];
            }

            DLog(@"Full image display frame %f and %f",
                 self.fullImageDisplayImageView.frame.size.width,
                 self.fullImageDisplayImageView.frame.size.height);

            [UIView animateWithDuration:1
                delay:0.0f
                options:UIViewAnimationOptionCurveLinear
                animations:^{ strongSelf.fullImageDisplayImageView.alpha = 1; }
                completion:^(BOOL finished) {}];
        }];
}

- (IBAction)closeButtonPressed:(id)sender {
    [UIView animateWithDuration:defaultAnimationDuration
        delay:0.0
        usingSpringWithDamping:1.0
        initialSpringVelocity:1
        options:UIViewAnimationOptionCurveLinear
        animations:^{

            self.view.frame = CGRectMake(self.endingCoordinateOnScreen.x,
                                         self.endingCoordinateOnScreen.y,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height);

            self.view.transform = CGAffineTransformMakeScale(0, 0);
        }
        completion:^(BOOL finished) {
            // Literally remove the view from current parent view controller's
            // children hierarchy
            [self willMoveToParentViewController:nil];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
}
@end

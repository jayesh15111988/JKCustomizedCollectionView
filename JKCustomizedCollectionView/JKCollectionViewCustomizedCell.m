//
//  JKCollectionViewCustomizedCell.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/10/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKCollectionViewCustomizedCell.h"
#import <SDWebImage/SDWebImageManager.h>

@interface JKCollectionViewCustomizedCell ()

@property (strong,nonatomic) SDWebImageManager* manager;
@property (strong,nonatomic) NSURL* individualImageURL;
@property (strong,nonatomic) NSDictionary* individualImageProperties;
- (IBAction)imageInfoButtonClicked:(id)sender;
- (IBAction)authorInfoButtonClicked:(id)sender;

@end

@implementation JKCollectionViewCustomizedCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self;
}

-(void)customizeCellWithPhotoDetails:(NSDictionary*)photoDetails{
    self.manager=[SDWebImageManager sharedManager];
    self.individualImageProperties=photoDetails;
    self.imageView.clipsToBounds=YES;
    
    self.individualImageURL=[NSURL URLWithString:self.individualImageProperties[@"image_url"]];
    self.imageName.text=[NSString stringWithFormat:@"%@",self.individualImageProperties[@"name"]?:@""];
    self.dateAdded.text=[NSString stringWithFormat:@"%@",self.individualImageProperties[@"taken_at"]?:@""];
    self.description.text=[NSString stringWithFormat:@"%@",self.individualImageProperties[@"description"]?:@""];
    DLog(@"%@ image url is",self.individualImageURL);
    
    
    [self.manager downloadImageWithURL:self.individualImageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
    
    //Do something with image download progress work
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        //Once image download is complete stick it to the storyboard
        if(image){
            [self.imageView setImage:image];
        }
        else{
          //Put some placeholder image in here if image is not found
            //  [self.imageView setImage:nil];
        }
        
    }];
    
    [self setBackgroundColor:[UIColor redColor]];
    
}

- (IBAction)imageInfoButtonClicked:(id)sender {
    //Show extra image information if this button is pressed
    if(self.getImageInfo){
        self.getImageInfo(self.individualImageProperties);
    }
}

- (IBAction)authorInfoButtonClicked:(id)sender {
    //Show author specific information if this button is pressed
    if(self.getAuthorInfo){
        self.getAuthorInfo(self.individualImageProperties[@"user"]);
    }
}
@end

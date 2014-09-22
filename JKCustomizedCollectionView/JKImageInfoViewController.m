//
//  JKImageInfoViewController.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKImageInfoViewController.h"
#import "JKExtraImageInformationTableViewCell.h"
#import "NSString+Utilities.h"
#import <SDWebImage/SDWebImageManager.h>

static NSString* informationCellIdentifier = @"infocell";

static float currentViewWidth=400;
static float currentViewHeight=400;


@interface JKImageInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *imageInfoTableView;
@property (strong,nonatomic) SDWebImageManager *manager;

@property (strong,nonatomic) NSArray* imageInformationAttributesCollection;
@end

@implementation JKImageInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.manager = [SDWebImageManager sharedManager];
    
    //This is delicate, if something changes on server, then we are in big trouble
    
    self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, currentViewWidth, currentViewHeight);
    
    if(self.extraInformationType==ExtraImageAuthorInformation){
        self.imageInformationAttributesCollection=@[@{@"displayName":@"Icon",@"backgroundName":@"userpic_url"},@{@"displayName":@"User Name",@"backgroundName":@"username"},@{@"displayName":@"First Name",@"backgroundName":@"firstname"},@{@"displayName":@"Last Name",@"backgroundName":@"lastname"},@{@"displayName":@"City",@"backgroundName":@"city"},@{@"displayName":@"Country of Residence",@"backgroundName":@"country"},@{@"displayName":@"Account Upgraded?",@"backgroundName":@"upgrade_status"},@{@"displayName":@"Full Name",@"backgroundName":@"fullname"},@{@"displayName":@"Profile Picture",@"backgroundName":@"userpic_url"},@{@"displayName":@"Affection Count",@"backgroundName":@"affection"},@{@"displayName":@"Followers",@"backgroundName":@"followers_count"}];
    }
    else if(self.extraInformationType==ExtraImageInformation){
        self.imageInformationAttributesCollection=@[@{@"displayName":@"Icon",@"backgroundName":@"image_url"},@{@"displayName":@"Apearature Size",@"backgroundName":@"aperture"},@{@"displayName":@"Camera",@"backgroundName":@"camera"},@{@"displayName":@"Created On",@"backgroundName":@"created_at"},@{@"displayName":@"Description",@"backgroundName":@"description"},@{@"displayName":@"Favorited Count",@"backgroundName":@"favorites_count"},@{@"displayName":@"Focal Length",@"backgroundName":@"focal_length"},@{@"displayName":@"ISO",@"backgroundName":@"iso"},@{@"displayName":@"Location",@"backgroundName":@"locations"},@{@"displayName":@"Latitude",@"backgroundName":@"latitude"},@{@"displayName":@"Longitude",@"backgroundName":@"longitude"},@{@"displayName":@"Name",@"backgroundName":@"name"},@{@"displayName":@"Shutter Speed",@"backgroundName":@"shutter_speed"},@{@"displayName":@"Captured On",@"backgroundName":@"taken_at"},@{@"displayName":@"Views",@"backgroundName":@"times_viewed"}];
    }
    
    [self.imageInfoTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return [self.imageInformationAttributesCollection count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JKExtraImageInformationTableViewCell *cell = (JKExtraImageInformationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:informationCellIdentifier forIndexPath:indexPath];
    
    NSString* attributeName=self.imageInformationAttributesCollection[indexPath.row][@"displayName"];
    NSString* attributeValue=self.imageInformation[self.imageInformationAttributesCollection[indexPath.row][@"backgroundName"]];

    cell.imageIcon.hidden=![attributeName isEqualToString:@"Icon"];
    cell.imageAttributeValue.hidden=!cell.imageIcon.hidden;
    
    if(!cell.imageIcon.hidden){
        
        cell.imageAttributeValue.text=@"";
        

        if(attributeValue){
            
            [self.manager downloadImageWithURL:[NSURL URLWithString:attributeValue] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
                
                //Do something with image download progress work
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                //Once image download is complete stick it to the storyboard
                if(image){
                    [cell.imageIcon setImage:image];
                }
                else{
                    //Put some placeholder image in here if image is not found
                      [cell.imageIcon setImage:nil];
                }
                
            }];
            
            
        }
        else{
            [cell.imageIcon setImage:nil];
        }
        
    }
    else{
        
    cell.imageAttributeValue.text=[NSString stringWithFormat:@"%@",attributeValue?:@"Not Available"];
    }
    
    cell.imageAttributeName.text=[NSString stringWithFormat:@"%@",attributeName];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end

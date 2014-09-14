//
//  JKImageInfoViewController.m
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import "JKImageInfoViewController.h"
#import "JKExtraImageInformationTableViewCell.h"

static NSString* informationCellIdentifier = @"infocell";

static float currentViewWidth=400;
static float currentViewHeight=400;


@interface JKImageInfoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *imageInfoTableView;
@property (strong,nonatomic) NSArray* authorInformationAttributesCollection;
@property (strong,nonatomic) NSArray* imageInformationAttributesCollection;
@end

@implementation JKImageInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //This is delicate, if something changes on server, then we are in big trouble
    
    self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, currentViewWidth, currentViewHeight);
    self.authorInformationAttributesCollection=@[@"username",@"firstname",@"lastname",@"city",@"country",@"upgrade_status",@"fullname",@"userpic_url",@"affection",@"followers_count"];
    
    self.imageInformationAttributesCollection=@[];
    [self.imageInfoTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;//[[self.imageInformation allKeys] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JKExtraImageInformationTableViewCell *cell = (JKExtraImageInformationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:informationCellIdentifier forIndexPath:indexPath];
    
    cell.imageAttributeValue.text=[NSString stringWithFormat:@"%@",self.imageInformation[self.authorInformationAttributesCollection[indexPath.row]]];
    DLog(@"%@ info",self.imageInformation[self.authorInformationAttributesCollection[indexPath.row]]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

@end

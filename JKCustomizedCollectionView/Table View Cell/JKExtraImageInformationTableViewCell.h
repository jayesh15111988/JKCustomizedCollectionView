//
//  JKExtraImageInformationTableViewCell.h
//  JKCustomizedCollectionView
//
//  Created by Jayesh Kawli on 9/13/14.
//  Copyright (c) 2014 Jayesh Kawli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKExtraImageInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *imageAttributeName;
@property (weak, nonatomic) IBOutlet UILabel *imageAttributeValue;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;


@end

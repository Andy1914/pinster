//
//  PSPinTableViewCell.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSPinTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgPinType;
@property (weak, nonatomic) IBOutlet PSLabel *lblTime;
@property (weak, nonatomic) IBOutlet PSLabel *lblDate, *lblOwnerName;
@property (weak, nonatomic) IBOutlet PSLabel *lblPinName;

@end

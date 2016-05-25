//
//  PSPinTableViewCell.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSSettingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UISwitch *switchNotification;
@property (weak, nonatomic) IBOutlet PSLabel *lblName;

@end

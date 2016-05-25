//
//  PSNotificationsCell.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSNotificationsCell : UITableViewCell

@property(nonatomic,weak) IBOutlet PSLabel *lblNotificationText,*lblBlack;
@property(nonatomic,weak) IBOutlet PSButton *btnAccept,*btnReject;
@property(nonatomic,weak) IBOutlet UIView *viewButtons;
@property(nonatomic,weak) IBOutlet UIView *viewData;
@property(nonatomic,weak) IBOutlet UIImageView *imgPlace;
@end

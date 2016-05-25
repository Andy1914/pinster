//
//  PSNotificationsViewController.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSNotificationsViewController : PSParentViewController
@property (nonatomic, strong) IBOutlet UIImageView *noNotificationImageView;
@property (nonatomic,weak) IBOutlet UITableView *tblViewNotfications;

@end

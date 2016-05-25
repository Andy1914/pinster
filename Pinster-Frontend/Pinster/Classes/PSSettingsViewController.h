//
//  PSSettingsViewController.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSSettingsViewController : PSParentViewController

@property(nonatomic,retain) IBOutlet UISwitch *switchNotification;
@property(nonatomic,retain) IBOutlet UITableView *tblSettings;
-(IBAction)btnEditMobileClicked:(id)sender;
-(IBAction)btnChangePassClicked:(id)sender;
-(IBAction)btnLogoutClicked:(id)sender;
-(IBAction)btnSwitchClicked:(UISwitch *)sender;

@end

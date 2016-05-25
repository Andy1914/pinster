//
//  PSSettingsViewController.m
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSSettingsViewController.h"
#import "PSNotificationsViewController.h"
#import "PSChangePassViewController.h"
#import "PSMobileNumberViewController.h"
#import "PSMyProfileViewController.h"
#import "PSWelcomeViewController.h"
#import "PSSettingsTableViewCell.h"
@interface PSSettingsViewController ()
@property (nonatomic, strong) NSMutableArray *settingsArray;
@end

@implementation PSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Settings"]];
//    self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"icon-checkbox-unselected-25x25.png" selectedImage:@"icon-checkbox-selected-green-25x25.png" withSelecter:@selector(menuCLicked) withTarget:self];
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if([[objUser objectForKey:kPasswordKey] length] == 0) {
        UIView *passwordBtn = [self.view viewWithTag:1003];
        UIView *logOutBtn = [self.view viewWithTag:1004];
        [passwordBtn setHidden:YES];
        [logOutBtn setFrame:passwordBtn.frame];
        [[self.view viewWithTag:1005] setHidden:YES];
    }

    if([[objUser valueForKey:@"push_notification"] length] == 0) {
        [(UISwitch *)[self.view viewWithTag:1001] setOn:YES];
    } else {
        [(UISwitch *)[self.view viewWithTag:1001] setOn:[PSUtility isTrue:[objUser valueForKey:@"push_notification"]]];
    }
    if([[objUser valueForKey:@"notification"] length] == 0) {
        [(UISwitch *)[self.view viewWithTag:1002] setOn:YES];
    } else {
        [(UISwitch *)[self.view viewWithTag:1002] setOn:[PSUtility isTrue:[objUser valueForKey:@"notification"]]];
    }
    [self.tblSettings registerNib:[UINib nibWithNibName:@"PSSettingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"PSSettingsTableViewCell"];
    self.settingsArray = [NSMutableArray arrayWithArray:[PSUtility loadDataFromLocalJsonfile:@"Settings"]];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
}

- (void)openRightMenu {
    [appDelegate openRightMenu];
}

-(IBAction)btnSwitchClicked:(UISwitch *)sender{
    NSString *type = @"";
    NSString *value = @"";
    if(sender.tag == 1001) {
        type = @"push_notification";
    } else {
        type = @"notification";
    }
    if(sender.isOn) {
        value = @"1";
    } else {
        value = @"0";
    }
    [self notificationsEnable:value withNotificationType:type withTag:sender.tag];
}
- (void)updateSwitch:(NSInteger )tag withVal:(int)value{
    [(UISwitch *)[self.view viewWithTag:tag] setOn:value];
}
- (void)notificationsEnable:(NSString *)value withNotificationType:(NSString *)type withTag:(NSInteger)tagVal{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPutURL:kUpdateProfileApi parmeters:[NSDictionary dictionaryWithObjectsAndKeys:[PSUtility getCurrentUserId],kUser_IdKey,value,type, nil] completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                
            } else {
                [(UISwitch *)[self.view viewWithTag:tagVal] setOn:!(((UISwitch *)[self.view viewWithTag:tagVal]).isOn)];
            }
        } else {
            [(UISwitch *)[self.view viewWithTag:tagVal] setOn:!(((UISwitch *)[self.view viewWithTag:tagVal]).isOn)];
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

-(IBAction)btnNotificationsClicked:(id)sender{
//    PSNotificationsViewController *obj = [PSUtility getViewControllerWithName:@"PSNotificationsViewController"];
//    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)btnEditMobileClicked:(id)sender{
    PSMobileNumberViewController *obj = [PSUtility getViewControllerWithName:@"PSMobileNumberViewController"];
    obj.isEditingNumber = YES;
    [obj.lblInstruction setText:@"Please enter your new mobile number"];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)btnChangePassClicked:(id)sender{
    PSChangePassViewController *obj = [PSUtility getViewControllerWithName:@"PSChangePassViewController"];
    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)btnLogoutClicked:(id)sender{
    PSCustomAlertView *customAlert = [[PSCustomAlertView alloc] initWithTitle:@"Are you sure you want to Log out?" delegate:self isDoubleButton:YES ofOption:1];
    [self.view addSubview:customAlert];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PSCustomAlertView delegates
-(void)customAlertYesButtonPressed:(PSCustomAlertView *)customAlertView {
    [customAlertView removeFromSuperview];
    [PSUtility removeValueFromSessionWithKey:kUserDetailsKey];
    [PSUtility removeValueFromSessionWithKey:@"OLD_LOCATION_DETAILS"];
    [UIView animateWithDuration:0.75
                     animations:^{
//                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[appDelegate navigationController].view cache:NO];
                         [[appDelegate navigationController] popToRootViewControllerAnimated:NO];
                         PSWelcomeViewController *objPSWelcom = [[PSWelcomeViewController alloc] initWithNibName:@"PSWelcomeViewController" bundle:nil];
//                         
//                         [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"homescreen"];
//                         
//                         [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         [[appDelegate navigationController] pushViewController:objPSWelcom animated:NO];
                     }];
//    [[appDelegate navigationController] popToRootViewControllerAnimated:YES];
    
}
-(void)customAlertNoButtonPressed:(PSCustomAlertView *)customAlertView {
    [customAlertView removeFromSuperview];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.settingsArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((NSArray *)[self.settingsArray objectAtIndex:section]) count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSSettingsTableViewCell" forIndexPath:indexPath];
    NSDictionary *setDict = [((NSArray *)[self.settingsArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    cell.lblName.text = [setDict objectForKey:@"name"];
    cell.imgIcon.image = [UIImage imageNamed:[setDict objectForKey:@"image"]];
    switch ([[setDict objectForKey:@"type"] integerValue]) {
        case 0:
        {
            [cell.switchNotification setHidden:NO];
            [self.switchNotification setTag:100+indexPath.row];
            [self.switchNotification addTarget:self action:@selector(btnSwitchClicked:) forControlEvents:UIControlEventValueChanged];
            [cell.imgArrow setHidden:YES];
            if([[setDict objectForKey:@"name"] isEqualToString:@"Push Notification"]) {
                [cell.switchNotification setTag:1001];
            } else if([[setDict objectForKey:@"name"] isEqualToString:@"Notification"]) {
                [cell.switchNotification setTag:1002];
            }
            [cell.switchNotification addTarget:self action:@selector(btnSwitchClicked:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case 1:
        {
            [cell.switchNotification setHidden:YES];
            [cell.imgArrow setHidden:NO];
        }
            break;
        
        default: {
            [cell.switchNotification setHidden:YES];
            [cell.imgArrow setHidden:YES];
        }
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *setDict = [((NSArray *)[self.settingsArray objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
    if([[setDict objectForKey:@"name"] isEqualToString:@"Logout"]) {
        [self btnLogoutClicked:nil];
    } else if([[setDict objectForKey:@"name"] isEqualToString:@"Rate this app"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com"]];
    }
    else if([[setDict objectForKey:@"nibname"] length] > 0) {
        [self.navigationController pushViewController:[PSUtility getViewControllerWithName:[setDict objectForKey:@"nibname"]] animated:YES];
    }
}
@end

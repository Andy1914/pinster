//
//  PSNotificationsViewController.m
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSNotificationsViewController.h"
#import "PSNotificationsCell.h"

@interface PSNotificationsViewController ()
@property (nonatomic, strong) NSMutableArray *notificationsArray;
@end

@implementation PSNotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.noNotificationImageView.hidden = YES;
    [self.tblViewNotfications registerNib:[UINib nibWithNibName:@"PSNotificationsCell" bundle:nil] forCellReuseIdentifier:@"PSNotificationsCell"];
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Notifications"]];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.noNotificationImageView.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
    [self callNotificationsApi];
}

- (void)openRightMenu {
    [appDelegate openRightMenu];
}
#pragma mark - Action methods
-(void)btnAccpetClicked:(UIButton*)sender{
    NSDictionary *notificationData = [self.notificationsArray objectAtIndex:sender.tag];
    [[WSHelper sharedInstance] getArrayFromPutURL:kRequestAcceptOrRejectApi parmeters:@{kUser_IdKey: [PSUtility getCurrentUserId],@"status":@"3",@"friend_id":[notificationData valueForKey:@"notification_from_id"]} completionHandler:^(id result, NSString *url, NSError *error) {
        dLog(@"result: %@",result);
    }];
}

-(void)btnRejectClicked:(UIButton*)sender{
    NSDictionary *notificationData = [self.notificationsArray objectAtIndex:sender.tag];
    [[WSHelper sharedInstance] getArrayFromPutURL:kRequestAcceptOrRejectApi parmeters:@{kUser_IdKey: [PSUtility getCurrentUserId],@"status":@"4",@"friend_id":[notificationData valueForKey:@"notification_from_id"]} completionHandler:^(id result, NSString *url, NSError *error) {
        dLog(@"result: %@",result);
    }];
}

#pragma mark - TableView Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notificationsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSNotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSNotificationsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.btnAccept setTag:indexPath.row];
    [cell.btnReject setTag:indexPath.row];
    [cell.btnAccept addTarget:self action:@selector(btnAccpetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnReject addTarget:self action:@selector(btnRejectClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *notificationData = [self.notificationsArray objectAtIndex:indexPath.row];
    cell.lblNotificationText.text = [notificationData valueForKey:@"notification_message"];
    if ([[notificationData valueForKey:@"notification_type"] integerValue]== 1) {
//        cell.btnAccept.hidden = cell.btnReject.hidden = NO;
        cell.lblBlack.hidden = YES;
        [cell.imgPlace setHidden:YES];
        [cell.viewButtons setHidden:NO];
        [cell.viewData setFrame:CGRectMake(150, 0, 320, 65)];
    } else {
        cell.lblBlack.hidden = NO;
        [cell.imgPlace setHidden:NO];
        [cell.viewButtons setHidden:YES];
        [cell.viewData setFrame:CGRectMake(0, 0, 320, 65)];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Web service call
- (void)callNotificationsApi {
    self.notificationsArray = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];//@{kUser_IdKey: [PSUtility getCurrentUserId]
    [[WSHelper sharedInstance] getArrayFromGetURL:kNotificationsApi parmeters:@{kUser_IdKey: [PSUtility getCurrentUserId]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(error == nil) {
           //if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
            if([(NSArray *)[result valueForKey:KDataKey] count] > 0) {
                for (NSDictionary *objUserDict in [result valueForKey:KDataKey]) {
                    [self.notificationsArray addObject:[[PSPinModel alloc] initWithDictonery:objUserDict]];
                }
                self.notificationsArray = [NSMutableArray arrayWithArray:[result valueForKey:KDataKey]];
                [self.tblViewNotfications reloadData];
                self.noNotificationImageView.hidden = YES;
            } else {
                
                self.noNotificationImageView.hidden = NO;
                [self.view bringSubviewToFront:self.noNotificationImageView];
//                [[PSUtility sharedInstance] showCustomAlertWithMessage:@"You don't have any notifications." onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}
@end

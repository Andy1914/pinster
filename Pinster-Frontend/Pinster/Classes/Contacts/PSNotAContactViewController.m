//
//  PSNotAContactViewController.m
//  Pinster
//
//  Created by CHINAB on 9/22/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSNotAContactViewController.h"

@interface PSNotAContactViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastSeenLabel;
@end

@implementation PSNotAContactViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Profile";
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.layer.masksToBounds = YES;
//    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.profileImageView.layer.borderWidth = 3.0;
}

- (IBAction)sendContactRequestTapped:(id)sender {
    
//    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kCheckUserExistsApi,kCheckUserExists] parmeters:[NSDictionary dictionaryWithObject:@"1" forKey:@"id"] completionHandler:^(id result, NSString *url, NSError *error)
//     {
//        if(!error)
//        {
//            if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [[[result valueForKey:KDataKey] allKeys] count] >0) {
//                
//            }
//            else
//            {
//                //                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
//            }
//        } else {
//            //            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
//        }
//    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[PSUtility getCurrentUserId],kUser_IdKey,_stringPhoneNo,kMobileNumberKey, nil];
    
    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kInviteContactApi,kInviteContact] parmeters:params completionHandler:^(id result, NSString *url, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:self];
                
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        }
    }];
    
}

#pragma mark - PSCustomAlertView Delegates
-(void)customAlertOkButtonPressed:(PSCustomAlertView *)customAlertView {
    //    PSEmailLoginViewController *objVc = []
    [customAlertView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PSLoadingViewController.m
//  Pinster
//
//  Created by Mobiledev on 18/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSLoadingViewController.h"

@interface PSLoadingViewController ()

@end

@implementation PSLoadingViewController

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
    self.navigationController.navigationBarHidden = YES;
    if([[PSUtility getValueFromSession:@"FIRST"] length] == 0) {
        [PSUtility saveSessionValue:@"1" withKey:@"FIRST"];
    } else {
        [self.tagLine setHidden:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
////    if(objUser == nil) {
////    } else {
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(moveToLogin) userInfo:nil repeats:NO];
////    }
}
-(void)moveToLogin{
    PSWelcomeViewController *objPSWelcom = [[PSWelcomeViewController alloc] initWithNibName:@"PSWelcomeViewController" bundle:nil];
    [self.navigationController pushViewController:objPSWelcom animated:NO];

    return;
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    [[WSHelper sharedInstance] getArrayFromPostURL:kLoginWithEmailApi parmeters:@{kEmailKey: [objUser valueForKey:kEmailKey],kPasswordKey:[objUser valueForKey:kPasswordKey]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:[result valueForKey:KDataKey]];
                [userData setValue:[objUser valueForKey:kPasswordKey] forKey:kPasswordKey];
                [PSUtility saveSessionValue:userData withKey:kUserDetailsKey];
                if(![PSUtility isTrue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey]]) {
                    [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSMobileNumberViewController"] animated:YES];
                } else {
                    [appDelegate configureSidePanel];
                }
                
            } else {
                PSWelcomeViewController *objPSWelcom = [[PSWelcomeViewController alloc] initWithNibName:@"PSWelcomeViewController" bundle:nil];
                [self.navigationController pushViewController:objPSWelcom animated:YES];
            }
        } else {
            PSWelcomeViewController *objPSWelcom = [[PSWelcomeViewController alloc] initWithNibName:@"PSWelcomeViewController" bundle:nil];
            [self.navigationController pushViewController:objPSWelcom animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

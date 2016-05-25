//
//  PSPassCodeViewController.m
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSPassCodeViewController.h"
#import "UIView+Shake.h"

#define TEMP_PASS_CODE  @"1234"
@interface PSPassCodeViewController ()

@end

@implementation PSPassCodeViewController

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

//    self.inputViewField.delegate = self;
//    self.inputViewField.errorMessage = @"Invalid Passcode";
//    [self.inputViewField.errorMessageLabel setHidden:YES];
//    [self.inputViewField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.btnResend setAttributedTitle:[[NSAttributedString alloc] initWithString:[self.btnResend titleForState:0]
                                                                            attributes:underlineAttribute] forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self];
//    [self.textFieldPasscode becomeFirstResponder];

    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Verification"]];
}

-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction methods

-(IBAction)buttonSubmitPressed:(id)sender
{
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    [self.textFieldPasscode resignFirstResponder];
    if([self.textFieldPasscode.text isEqualToString:[objUser valueForKey:kMobileVerificationCodeKey]]) {
        NSMutableDictionary *objUser = [NSMutableDictionary dictionaryWithDictionary:[PSUtility getValueFromSession:kUserDetailsKey]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[WSHelper sharedInstance] getArrayFromPutURL:kVerificationStatus parmeters:@{kUser_IdKey: [objUser valueForKey:kUserIdKey], kMobileVerificationCodeKey:self.textFieldPasscode.text} completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error) {
                if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                    [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Mobile Number is verified successfully" onViewController:self withDelegate:self];
                } else {
                    [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                }
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
            }
        }];
    } else {
        // show alert;
        [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Invalid verification code." onViewController:self withDelegate:nil];
    }
}

#pragma mark - PSCustomAlertView Delegates
-(void)customAlertOkButtonPressed:(PSCustomAlertView *)customAlertView {
//    PSEmailLoginViewController *objVc = []
    [customAlertView removeFromSuperview];
    [appDelegate configureSidePanel];
}

-(IBAction)buttonResendPressed:(UIButton *)sender{
    NSMutableDictionary *objUser = [NSMutableDictionary dictionaryWithDictionary:[PSUtility getValueFromSession:kUserDetailsKey]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPutURL:kGenerateVerificationCodeApi parmeters:@{kUser_IdKey: [objUser valueForKey:kUserIdKey], kMobileKey:[objUser objectForKey:kMobileKey]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [PSUtility isValidData:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationCodeKey]] && [PSUtility isValidData:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey]]) {
                [objUser setValue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationCodeKey] forKey:kMobileVerificationCodeKey];
                [objUser setValue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey] forKey:kMobileVerificationStatusKey];
                [PSUtility saveSessionValue:objUser withKey:kUserDetailsKey];
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}
@end

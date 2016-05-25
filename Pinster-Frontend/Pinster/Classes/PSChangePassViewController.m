//
//  PSChangePassViewController.m
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSChangePassViewController.h"

@interface PSChangePassViewController ()

@end

@implementation PSChangePassViewController

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
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Change Password"]];
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self];
    // Do any additional setup after loading the view from its nib.
}
-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark - Action methods
-(IBAction)btnSaveClicked:(id)sender{
    if ([self isValidData]) {
        [self callChangePasswordApi];
    }
}

-(IBAction)btnCancelClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - textfields & keyboard delegats
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.txtOldPass) {
        [self.txtNewPass becomeFirstResponder];
    } else if(textField == self.txtNewPass) {
        [self.txtConfirmPass becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

-(BOOL)isValidData
{
    // TODO: Please change this condition
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    
//    if(![self.txtOldPass.text isEqualToString:[objUser valueForKey:kPasswordKey]])
//    {
//        [PSUtility showAlert:@"Error" withMessage:@"Passwords that you have entered do not match"];
//        [self.txtOldPass becomeFirstResponder];
//        return NO;
//    } else
    if([self.txtNewPass.text isEqualToString:@""])
    {
        [PSUtility showAlert:@"Error" withMessage:@"Please Enter New Password"];
        [self.txtNewPass becomeFirstResponder];
        return NO;
    } else if([self.txtConfirmPass.text isEqualToString:@""])
    {
        [PSUtility showAlert:@"Error" withMessage:@"Please Enter Confirm Password"];
        [self.txtConfirmPass becomeFirstResponder];
        return NO;
    } else  if(![PSUtility comparePasswords:self.txtNewPass.text confirmPassword:self.txtConfirmPass.text])
    {
        [PSUtility showAlert:@"Error" withMessage:@"Password and Confirm password should be same"];
        [self.txtConfirmPass becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)callChangePasswordApi {
    [self.txtNewPass resignFirstResponder];
    [self.txtConfirmPass resignFirstResponder];
    [self.txtOldPass resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPutURL:kChangePasswordApi parmeters:[NSDictionary dictionaryWithObjectsAndKeys:[PSUtility getCurrentUserId],kUser_IdKey,self.txtNewPass.text,kPasswordKey, nil] completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                NSMutableDictionary *objUser = [NSMutableDictionary dictionaryWithDictionary:[PSUtility getValueFromSession:kUserDetailsKey]];
                [objUser setValue:self.txtNewPass.text forKey:kPasswordKey];
                [PSUtility saveSessionValue:objUser withKey:kUserDetailsKey];
            }
            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

@end

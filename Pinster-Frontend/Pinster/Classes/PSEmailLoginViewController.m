//
//  PSEmailLoginViewController.m
//  Pinster
//
//  Created by Mobiledev on 19/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSEmailLoginViewController.h"

@interface PSEmailLoginViewController ()

@end

@implementation PSEmailLoginViewController

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
    self.navigationItem.hidesBackButton = YES;

    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Login"]];
//    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName : [PSUtility appDefaultColor]};
    //[self.btnForgotPass setAttributedTitle:[[NSAttributedString alloc] initWithString:[self.btnForgotPass titleForState:0]
    //                                                                       attributes:underlineAttribute] forState:UIControlStateNormal];
    //[self.btnRegistration setAttributedTitle:[[NSAttributedString alloc] initWithString:[self.btnRegistration titleForState:0]
    //                                                                       attributes:underlineAttribute] forState:UIControlStateNormal];
    [self autoLogin];
}
- (void)autoLogin {
    self.txtEmail.text = @"";
    self.txtPassword.text = @"";
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if([objUser valueForKey:kEmailKey] != nil && [objUser valueForKey:kEmailKey] > 0) {
        self.txtEmail.text = [objUser valueForKey:kEmailKey];
    }
    if([objUser valueForKey:kPasswordKey] != nil && [objUser valueForKey:kPasswordKey] > 0) {
        self.txtPassword.text = [objUser valueForKey:kPasswordKey];
    }
    if([self.txtEmail.text length] > 0 && [self.txtPassword.text length] > 0) {
        [self btnLoginClicked:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;

    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:[PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self], nil]];
    
}
-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Action methods
-(IBAction)btnLoginClicked:(id)sender
{
    if([self isValid])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [[WSHelper sharedInstance] getArrayFromPostURL:kLoginWithEmailApi parmeters:@{kEmailKey: self.txtEmail.text,kPasswordKey:self.txtPassword.text,KpushNotificationToken:[PSUtility getValueFromSession:KpushNotificationToken]} completionHandler:^(id result, NSString *url, NSError *error) {
        [[WSHelper sharedInstance] getArrayFromPostURL:kLoginWithEmailApi parmeters:@{kEmailKey: self.txtEmail.text,kPasswordKey:self.txtPassword.text,KpushNotificationToken:@"eb5f84ce667481a671405b2e5970c1bc90d8ec884c19ef67385c24cd3cbcd3f6"} completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error) {
                if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                    NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:[result valueForKey:KDataKey]];
                    [userData setValue:self.txtPassword.text forKey:kPasswordKey];
                    [PSUtility saveSessionValue:userData withKey:kUserDetailsKey];
                    if(![PSUtility isTrue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey]]) {
                        [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSMobileNumberViewController"] animated:YES];
                    } else {
                        [appDelegate configureSidePanel];
                    }
                    
                } else {
                    [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                }
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Invalid email address or password" onViewController:self withDelegate:nil];
//                [appDelegate configureSidePanel];
            }
        }];
    }
}


- (BOOL)isValid
{
    [self.view endEditing:YES];
    if(![PSUtility isValidData:self.txtEmail.text] || ![PSUtility validateEmail:self.txtEmail.text])
    {
//        [PSUtility showAlert:@"Error" withMessage:@"Please enter Email Id"];
//        PSCustomAlertView *alertView = [[PSCustomAlertView alloc] initWithMessage:@"Invalid Email Id"];
//        [self.view addSubview:alertView];
        [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Invalid Email Id" onViewController:self withDelegate:nil];
        return NO;
    }
    if(![PSUtility isValidData:self.txtPassword.text])
    {
        //[PSUtility showAlert:@"Error" withMessage:@"Please enter Password"];
//        PSCustomAlertView *alertView = [[PSCustomAlertView alloc] initWithMessage:@"Please enter Password"];
//        [self.view addSubview:alertView];
        [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Please enter Password" onViewController:self withDelegate:nil];
        return NO;
    }
    return YES;
}
-(IBAction)btnForgotPassClicked:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forget Password" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];//
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    [textField setPlaceholder:@"Enter Your Email Id"];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if(![PSUtility isValidData:[textField text]])
        {
            //[PSUtility showAlert:@"Error" withMessage:@"Please enter Email Id"];
            PSCustomAlertView *alertView = [[PSCustomAlertView alloc] initWithMessage:@"Please enter Email Id"];
            [self.view addSubview:alertView];
            return;
        }
        else if(![PSUtility validateEmail:[textField text]])
        {
            //[PSUtility showAlert:@"Error" withMessage:@"Invalid Email Id"];
            PSCustomAlertView *alertView = [[PSCustomAlertView alloc] initWithMessage:@"Invalid Email Id"];
            [self.view addSubview:alertView];
            return;
        }
        [self callForgetpassword:[textField text]];
    }

}

-(void)callForgetpassword:(NSString *)email {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPutURL:kForgetPasswordApi parmeters:@{kEmailKey: email} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
               [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Password sent to your email." onViewController:self withDelegate:nil];
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
            //                [appDelegate configureSidePanel];
        }
    }];
}
-(IBAction)btnRegistrationClicked:(id)sender{
    PSRegistrationViewController *objPSReg = [[PSRegistrationViewController alloc] initWithNibName:@"PSRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:objPSReg animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

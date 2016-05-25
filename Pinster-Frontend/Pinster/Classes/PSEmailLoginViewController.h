//
//  PSEmailLoginViewController.h
//  Pinster
//
//  Created by Mobiledev on 19/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSRegistrationViewController.h"
#import "PSCustomAlertView.h"

@interface PSEmailLoginViewController : PSParentViewController

@property(strong,nonatomic) IBOutlet PSTextField *txtEmail,*txtPassword;
@property(strong,nonatomic) IBOutlet PSButton *btnForgotPass,*btnRegistration;

-(IBAction)btnLoginClicked:(id)sender;
-(IBAction)btnForgotPassClicked:(id)sender;
-(IBAction)btnRegistrationClicked:(id)sender;

@end

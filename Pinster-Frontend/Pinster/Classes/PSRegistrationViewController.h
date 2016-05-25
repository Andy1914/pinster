//
//  PSRegistrationViewController.h
//  Pinster
//
//  Created by Mobiledev on 19/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCustomAlertView.h"

@interface PSRegistrationViewController : PSParentViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    UITextField *currentTextField;
}

@property(weak,nonatomic) IBOutlet PSTextField *txtName,*txtMobile,*txtEmail,*txtPassword,*txtConfirmPass;
@property(weak,nonatomic) IBOutlet PSButton *btnDatePicker;
@property(weak,nonatomic) IBOutlet PSButton *btnProfilePic;


-(IBAction)btnSignUpClicked:(id)sender;

@end

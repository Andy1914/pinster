//
//  PSPassCodeViewController.h
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"
#import "BKPasscodeInputView.h"


@interface PSPassCodeViewController : PSParentViewController

@property(strong,nonatomic) IBOutlet PSTextField *textFieldPasscode;
@property(strong,nonatomic) IBOutlet PSButton *btnResend;

-(IBAction)buttonSubmitPressed:(UIButton *)sender;
-(IBAction)buttonResendPressed:(UIButton *)sender;

@end

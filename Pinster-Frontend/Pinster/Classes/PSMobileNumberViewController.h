//
//  PSMobileNumberViewController.h
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSMobileNumberViewController : PSParentViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCoun;
@property (weak, nonatomic) IBOutlet PSButton *btnCountryCode;
@property (weak, nonatomic) IBOutlet PSLabel *lblInstruction;

@property(strong,nonatomic) IBOutlet PSTextField *txtPhoneNumber;
@property(strong,nonatomic) IBOutlet UILabel *lblHelpText, *lblHelptextTwo;
@property(assign,nonatomic) BOOL isEditingNumber;

@end

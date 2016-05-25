//
//  PSRegistrationViewController.m
//  Pinster
//
//  Created by Mobiledev on 19/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSRegistrationViewController.h"
#import "UIDateTimePicker.h"
@interface PSRegistrationViewController ()<BSKeyboardControlsDelegate,CustomDateTimePickerDelegate>
@property (nonatomic, strong)BSKeyboardControls *keyBordController;
@property (strong, nonatomic) UIDateTimePicker *datePicker;
@property (strong, nonatomic) UIImage *imgProfilePic;
@end

@implementation PSRegistrationViewController

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
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backClicked) withTarget:self];
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Registration"]];
    NSArray *textFieldsArray = [NSArray arrayWithObjects:self.txtName,self.txtEmail,self.txtPassword,self.txtConfirmPass, nil];
   // self.keyBordController = [[BSKeyboardControls alloc] initWithFields:textFieldsArray];
   // self.keyBordController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Action methods

-(IBAction)btnSignUpClicked:(id)sende
{
    [self.view endEditing:YES];
    if([self isValidData]) {
        [self.keyBordController.activeField resignFirstResponder];
        NSDictionary *perams = @{kNameKey: [PSUtility checkNil:self.txtName.text],kEmailKey:[PSUtility checkNil:self.txtEmail.text],kDOBKey:[PSUtility checkNil:self.btnDatePicker.titleLabel.text],kPasswordKey:[PSUtility checkNil:self.txtPassword.text],KpushNotificationToken:[PSUtility getValueFromSession:KpushNotificationToken]};
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        
//        if (self.imgProfilePic == nil)
//        {
//            [[WSHelper sharedInstance] uploadFileWithURL:kRegistrationApi withMethod:@"POST" withParmeters:perams mediaData:nil withKey:@"profile_picture" completionHandler:^(id result, NSString *url, NSError *error) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                if(!error) {
//                    if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
//                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[result valueForKey:KDataKey]];
//                        [dict setValue:self.txtPassword.text forKey:kPasswordKey];
//                        [PSUtility saveSessionValue:dict withKey:kUserDetailsKey];
//                        [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSMobileNumberViewController"] animated:YES];
//                    } else {
//                        [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
//                    }
//                } else {
//                    [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
//                }
//            }];
//        }
//        else
//        {
            [[WSHelper sharedInstance] uploadFileWithURL:kRegistrationApi withMethod:@"POST" withParmeters:perams mediaData:UIImageJPEGRepresentation([PSUtility scaleImage:self.imgProfilePic toSize:CGSizeMake(270, 270)], 1.0) withKey:@"profile_picture" completionHandler:^(id result, NSString *url, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(!error) {
                    if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[result valueForKey:KDataKey]];
                        [dict setValue:self.txtPassword.text forKey:kPasswordKey];
                        [PSUtility saveSessionValue:dict withKey:kUserDetailsKey];
                        [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSMobileNumberViewController"] animated:YES];
                    } else {
                        [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                    }
                } else {
                    [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
                }
            }];
//        }
        
//        [[WSHelper sharedInstance] uploadFileWithPutURL:kRegistrationApi parmeters:perams mediaData:[NSDictionary dictionaryWithObjectsAndKeys:UIImageJPEGRepresentation([self scaleImage:self.imgProfilePic toSize:CGSizeMake(270, 270)], 1.0),@"file",[NSString stringWithFormat:@"%@.JPEG",[PSUtility getCurrentUserId]],@"name",[NSString stringWithFormat:@"%@.JPEG",[PSUtility getCurrentUserId]],@"file_name", nil] completionHandler:^(id result, NSString *url, NSError *error) {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            if(!error) {
//                if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
//                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[result valueForKey:KDataKey]];
//                    [dict setValue:self.txtPassword.text forKey:kPasswordKey];
//                    [PSUtility saveSessionValue:dict withKey:kUserDetailsKey];
//                    [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSMobileNumberViewController"] animated:YES];
//                } else {
//                    [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
//                }
//            } else {
//                [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
//            }
//        }];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - textfields & keyboard delegats

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.keyBordController setActiveField:textField];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField returnKeyType] == UIReturnKeyNext)
    {
        [self.keyBordController selectNextField];
    }
    else if(textField.tag == 1001)
    {
        [self openDatePicker:self.btnDatePicker];
    }
    else
        [textField resignFirstResponder];
    
    return YES;
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self.view endEditing:YES];
    [self.keyBordController.activeField resignFirstResponder];
    
    if([(UITextField *)self.keyBordController.activeField isEqual:self.txtEmail])
        [self openDatePicker:self.btnDatePicker];
}

#pragma mark - open datepicker

-(IBAction)openDatePicker:(id)sender
{
    [self.view endEditing:YES];
    [self.keyBordController.activeField resignFirstResponder];
    
    if(!self.datePicker)
    {
        self.datePicker =[[UIDateTimePicker alloc] init];
        [self.datePicker setDelegate:self];
    }
    [self.datePicker initWithDatePicker:CGRectMake(0, 160, 320,258) inView:self.view ContentSize:CGSizeMake(320, 216) pickerSize:CGRectMake(0, 20, 320, 216) pickerMode:UIDatePickerModeDate dateFormat:@"MMMM d, yyyy" minimumDate:nil maxDate:[NSDate date] setCurrentDate:[NSDate date] Recevier:sender barStyle:UIBarStyleBlack toolBartitle:@"Select Date" textColor:[UIColor blackColor]];
}

#pragma mark - DatePicker Delegate Methods

-(void)DateTimePickerDoneClicked
{
    [self.txtPassword becomeFirstResponder];
    [self.keyBordController setActiveField:self.txtPassword];
}

-(void)DateTimePickerCancelClicked
{
    
}

#pragma mark - validate data

-(BOOL)isValidData
{
    if(![PSUtility isValidData:self.txtName.text])
    {
        currentTextField = self.txtName;
        [self showAlertWithMessage:@"Please Enter your Name"];
        return NO;
    }else  if(![PSUtility isValidData:self.txtEmail.text])
    {
        currentTextField = self.txtEmail;
        [self showAlertWithMessage:@"Please Enter Email Id"];
        return NO;
    } else  if(![PSUtility validateEmail:self.txtEmail.text])
    {
        currentTextField = self.txtEmail;
        [self showAlertWithMessage:@"Invalid Email Id"];
        return NO;
    } else
//        if(![PSUtility isValidData:self.txtMobile.text])
//    {
//        currentTextField = self.txtMobile;
//        [self showAlertWithMessage:@"Please Enter your mobile number"];
//        return NO;
//    } else
    if(![PSUtility isValidData:self.btnDatePicker.titleLabel.text])
    {
        currentTextField = nil;
        [self showAlertWithMessage:@"Please select your Date Of Birth"];
        return NO;
    }
    else  if(![PSUtility isValidData:self.txtPassword.text])
    {
        currentTextField = self.txtPassword;
        [self showAlertWithMessage:@"Please Enter Password"];
        return NO;
    }
    else  if(![PSUtility isValidData:self.txtConfirmPass.text])
    {
        currentTextField = self.txtConfirmPass;
        [self showAlertWithMessage:@"Please Enter Confirm Password"];
        return NO;
    }else  if(![PSUtility comparePasswords:self.txtPassword.text confirmPassword:self.txtConfirmPass.text])
    {
        currentTextField = self.txtConfirmPass;
        [self showAlertWithMessage:@"Password and Confirm password mismatch"];
        return NO;
    }
    
    return YES;
}

- (void)showAlertWithMessage:(NSString *)message {
    PSCustomAlertView *customAlert = [[PSCustomAlertView alloc] initWithMessage:message andDelegate:self];
    [self.view addSubview:customAlert];
}
-(void)customAlertOkButtonPressed:(PSCustomAlertView *)customAlertView
{
    [customAlertView removeFromSuperview];
    if(currentTextField)
        [currentTextField becomeFirstResponder];
}

-(void)resetAllFields {
    self.txtName.text = nil;
    self.txtEmail.text = nil;
//    self.txtMobile.text = nil;
    self.txtPassword.text = nil;
    self.txtConfirmPass.text = nil;
    [self.btnDatePicker setTitle:@"" forState:UIControlStateNormal];
}
- (IBAction)tapOnPrifilePic:(id)sender {
    UIActionSheet *objActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Camera",@"Choose Existing", nil];
    objActionSheet.tag = 1001;
    objActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [objActionSheet showInView:self.view];
}
#pragma mark -
#pragma mark - UIActionSheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2) {
        return;
    }
    if(buttonIndex == 0) {
        [self openCamera:UIImagePickerControllerSourceTypeCamera];
    } else {
        [self openCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
}

- (void)openCamera:(UIImagePickerControllerSourceType )type {
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    if(![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        type = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    mediaUI.sourceType = type;
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        self.imgProfilePic = image;
        [self.btnProfilePic setImage:image forState:UIControlStateNormal];
        [self.btnProfilePic.layer setCornerRadius:35.0];
        [self.btnProfilePic.layer setMasksToBounds:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end

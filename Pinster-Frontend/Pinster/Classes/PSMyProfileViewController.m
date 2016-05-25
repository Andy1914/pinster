//
//  PSMyProfileViewController.m
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#define iPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)

#import "PSMyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface PSMyProfileViewController ()
{
    IBOutlet UILabel *labelLineColor;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (IBAction)tapOnPrifilePic:(id)sender;
@property (nonatomic,strong) UIImagePickerController *picker;
@end

@implementation PSMyProfileViewController

- (void) loadView
{
    [super loadView];
    
    if (iPhone5)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PSMyProfileViewController" owner:self options:nil];
    }
    else
    {
        [[NSBundle mainBundle] loadNibNamed:@"PSMyProfileViewController3.5" owner:self options:nil];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if(![[[self.navigationController viewControllers] valueForKeyPath:@"nibName"] containsObject:@"PSSettingsViewController"]) {
        self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
    }
}

- (void)openRightMenu {
    [appDelegate openRightMenu];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
//    NSMutableDictionary *objUser ;//= [PSUtility getValueFromSession:kUserDetailsKey];
//    self.lblPinsTaken.text = [NSString stringWithFormat:@"%@",[objUser valueForKey:@"shared_pins_count"]];
    
//    NSLog(@"Response data = %@", objUser);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromGetURL:kGetContactDetail parmeters:@{kUser_IdKey:[PSUtility getCurrentUserId], @"id": [PSUtility getCurrentUserId]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(error) {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        } else {
            NSMutableDictionary *objUser = result;
            self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2;
            [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"My Profile"]];
            NSString *imageUrl = nil;
            if([[objUser valueForKey:kFacebookIdKey] length] > 0) {
                imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [objUser valueForKey:kFacebookIdKey]];
            }
            if([[[objUser valueForKey:@"user"] valueForKey:kProfileImageKey] length] > 0) {
                imageUrl = [NSString stringWithFormat:@"%@%@",kBaseImageOnlineUrl,[[objUser valueForKey:@"user"] valueForKey:kProfileImageKey]];
            }
            if([imageUrl length] > 0) {
                [self.indicator setHidden:NO];
                [self.indicator startAnimating];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicator stopAnimating];
                        [self.imgProfilePic setImage:[UIImage imageWithData:data]];
                    });
                });
            }
            [self.lblUserName setText:[objUser valueForKey:kNameKey]];
            
            if([[[self.navigationController viewControllers] valueForKeyPath:@"nibName"] containsObject:@"PSSettingsViewController"]) {
                [self performSelector:@selector(tapOnPrifilePic:) withObject:nil afterDelay:0.5];
                [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:[PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self], nil]];
                
                self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
                
            }
            labelLineColor.textColor = [UIColor colorWithRed:155.0f/255.0f green:185.0f/255.0f blue:186.0f/255.0f alpha:1.0f];
        }
    }];
    
    NSLog(@"Pinsaved = %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"pinsaved"]);
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"pinsaved"] == nil)
    {
        self.lblPinsTaken.text = @"0";
    }
    else
    {
        self.lblPinsTaken.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"pinsaved"]];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"snapsaved"] == nil)
    {
        self.lblSnapTaken.text = @"0";
    }
    else
    {
        self.lblSnapTaken.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"snapsaved"]];
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"snapshared"] == nil)
    {
        self.lblSnapShared.text = @"0";
    }
    else
    {
        self.lblSnapShared.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"snapshared"]];
    }
//    self.lblPinsShared.text = [NSString stringWithFormat:@"%@",[objUser valueForKey:@"pins_count"]];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"pinsshared"] == nil)
    {
        self.lblPinsShared.text = @"0";
    }
    else
    {
        self.lblPinsShared.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"pinsshared"]];
    }
    

    
}
-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillDataOnScreen {
    
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
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.imgProfilePic setBackgroundColor:[UIColor clearColor]];
        [self.imgProfilePic setImage:image];
        [self uploadImageToServer:image];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImageToServer:(UIImage *)img {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] uploadFileWithURL:kUpdateProfileApi withMethod:@"PUT" withParmeters:@{kUser_IdKey: [PSUtility getCurrentUserId]} mediaData:UIImageJPEGRepresentation([PSUtility scaleImage:img toSize:CGSizeMake(270, 270)], 1.0) withKey:@"profile_picture" completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(error) {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        } else {
            NSMutableDictionary *objUser = [NSMutableDictionary dictionaryWithDictionary:[PSUtility getValueFromSession:kUserDetailsKey]];
            [objUser setValue:[objUser valueForKey:kProfileImageKey] forKey:kProfileImageKey];
            [PSUtility saveSessionValue:objUser withKey:kUserDetailsKey];
            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        }
    }];
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

//
//  PSHomeViewController.m
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#define iPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)

#import "PSHomeViewController.h"
#import "PSPinDetailesViewController.h"
@interface PSHomeViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property int iTimer;

@property (nonatomic, strong) IBOutlet UILabel *labelTapToPin;

@property (nonatomic, strong) IBOutlet UILabel *pinLabel;
@property (nonatomic, strong) IBOutlet UILabel *snapLabel;

- (IBAction)openNewPinView:(id)sender;
- (IBAction)openRightMenu:(id)sender;

@end

@implementation PSHomeViewController

- (void) loadView
{
    [super loadView];
    
    if (iPhone5)
    {
        [[NSBundle mainBundle] loadNibNamed:@"PSHomeViewController" owner:self options:nil];
    }
    else
    {
        [[NSBundle mainBundle] loadNibNamed:@"PSHomeViewController3.5" owner:self options:nil];
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

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
    
    self.toggleView =  nil;
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    self.toggleView = Nil;
//    
//    [self.toggleView removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.iTimer = 0;
    
    _labelTapToPin.textColor = [UIColor colorWithRed:22.0f/255.0f green:96.0f/255.0f blue:107.0f/255.0f alpha:1.0f];
    
  //  _labelTapToPin.font = [UIFont fontWithName:@"Arial-Bold" size:50];
    
    [PSUtility saveSessionValue:@"1" withKey:@"Selected_row"];
    self.navigationController.navigationItem.hidesBackButton = YES;
    [appDelegate navigationController].navigationBarHidden = YES;
    
    [self.view bringSubviewToFront:self.pinLabel];
    [self.view bringSubviewToFront:self.snapLabel];
    
    
    [self.glowIcon setAnimationImages:@[[UIImage imageNamed:@"blue_circle_glow.png"],[UIImage imageNamed:@"blue_circle.png"]]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(glowImageView) userInfo:nil repeats:YES];
    self.toggleView = [[ToggleView alloc]init];
    
    self.toggleView = [self.toggleView initWithFrame:CGRectMake(17, 80, 286, 37) toggleViewType:ToggleViewTypeWithLabel toggleBaseType:ToggleBaseTypeDefault toggleButtonType:ToggleButtonTypeChangeImage];
    
    self.toggleView.toggleDelegate = self;
    
    [self.view addSubview:self.toggleView];
    
    [self.toggleView setSelectedButton:ToggleButtonSelectedLeft];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Home"]];
    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu:) withTarget:self];
   
//    [self.toggleView removeFromSuperview];
//    self.toggleView = Nil;

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"togglereceived"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.toggleView setSelectedButton:ToggleButtonSelectedLeft];
}

- (void)glowImageView {
    self.iTimer ++;
    [UIView transitionWithView:self.glowIcon
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        if (self.iTimer % 2 == 0) {
                            self.glowIcon.image = [self.glowIcon.animationImages objectAtIndex:0];
                        } else {
                            self.glowIcon.image = [self.glowIcon.animationImages objectAtIndex:1];
                        }
                    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openNewPinView:(id)sender {
    if(sender != nil) {
        [[appDelegate currentPinDetails] removeAllObjects];
    }
    
    self.toggleView = nil;
    [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSAddPinViewController"] animated:YES];
}

- (IBAction)openRightMenu:(id)sender {
    [[appDelegate sideMenuViewController] presentLeftMenuViewController];
}

#pragma mark - handlePush notifications
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
        [self.toggleView setSelectedButton:ToggleButtonSelectedLeft];
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
        [[appDelegate currentPinDetails] setValue:@"1" forKey:@"snap"];
        [[appDelegate currentPinDetails] setValue:image forKey:@"snapImage"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"snapsavedfromhome"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self openNewPinView:nil];
    }];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [self.toggleView setSelectedButton:ToggleButtonSelectedLeft];
}

#pragma mark - ToggleViewDelegate

- (void)selectLeftButton {
    
    [PSUtility saveSessionValue:@"0" withKey:@"snap"];

    self.pinLabel.textColor = [UIColor whiteColor];
    self.snapLabel.textColor = [UIColor blackColor];
}

- (void)selectRightButton {
   
    [PSUtility saveSessionValue:@"1" withKey:@"snap"];
    [self tapOnPrifilePic:nil];

    self.pinLabel.textColor = [UIColor blackColor];
    self.snapLabel.textColor = [UIColor whiteColor];
}

@end

//
//  PSAddPinViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSAddMessageViewController.h"
#import "PSCategoriesViewController.h"
@interface PSAddMessageViewController ()
- (IBAction)btnTapped:(PSButton *)sender;

@end

@implementation PSAddMessageViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    self.navigationItem.titleView = [PSUtility getHeaderLabelWithText:@"Name your Pin"];
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"back_arrow.png" withSelectedImage:@"back_arrow.png" alignmentLeft:NO withSelecter:@selector(backPressed:) withTarget:self];
//    [self.pinTextView becomeFirstResponder];
    if([[appDelegate currentPinDetails] objectForKey:@"snapImage"] != nil) {
         self.navigationItem.titleView = [PSUtility getHeaderLabelWithText:@"Name your Snap"];
    } else {
        self.navigationItem.titleView = [PSUtility getHeaderLabelWithText:@"Name your Pin"];
    }
    [self.pinTextView setTextColor:[UIColor lightGrayColor]];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [textField becomeFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    if([self.pinTextView.text length] == 0) {
        [PSUtility showAlert:@"Error" withMessage:@"Pin message cann't be Empty"];
        return YES;
    }
    [self.pinDataDict setValue:self.pinTextView.text forKey:PIN_MESSAGE];
    PSCategoriesViewController *objCatVC = [[PSCategoriesViewController alloc] initWithNibName:@"PSCategoriesViewController" bundle:nil];
    objCatVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
    [self.navigationController pushViewController:objCatVC animated:YES];
    return YES;
}

- (IBAction)skipSetup:(id)sender {
    PSCategoriesViewController *objCatVC = [[PSCategoriesViewController alloc] initWithNibName:@"PSCategoriesViewController" bundle:nil];
    objCatVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
    [self.navigationController pushViewController:objCatVC animated:YES];
}
@end

//
//  PSAddPinViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSAddPinViewController.h"
#import "PSCategoriesViewController.h"
@interface PSAddPinViewController ()
{
    IBOutlet UIView *viewSaveAgain;
    
    IBOutlet UILabel *labelLine;
}

- (IBAction) buttonSaveAgain:(id)sender;
- (IBAction) buttonCancel:(id)sender;

- (IBAction)btnTapped:(PSButton *)sender;
@property (nonatomic, strong) NSMutableDictionary *pinDataDict;
@property (nonatomic, readwrite) BOOL isDistenceFilterPassed;
@end

@implementation PSAddPinViewController

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
    if([[appDelegate currentPinDetails] objectForKey:@"snapImage"] != nil) {
        [self.pinImage setHidden:NO];
        [self.pinButton setHidden:YES];
        [self.pinImage setImage:[[appDelegate currentPinDetails] objectForKey:@"snapImage"]];
        self.navigationItem.titleView = [PSUtility getHeaderLabelWithText:@"Name your Snap"];
        self.pinTextView.textColor = [UIColor darkGrayColor];
    } else {
        self.navigationItem.titleView = [PSUtility getHeaderLabelWithText:@"Name your Pin"];
        [self.pinImage setHidden:YES];
        [self.pinButton setHidden:NO];
        self.pinTextView.textColor = [UIColor blackColor];
    }
    self.pinTextView.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.pinTextView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.pinDataDict = [NSMutableDictionary new];
    [self.pinDataDict setValue:[PSUtility getCurrentUserId] forKey:kUser_IdKey];
    
    // Do any additional setup after loading the view from its nib.
//    labelLine.textColor = [UIColor colorWithRed:55.0f/255.0f green:185.0f/255.0f blue:186.0f/255.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self CurrentLocationIdentifier];
    if(locationManager != nil && ![CLLocationManager locationServicesEnabled]) {
        [PSUtility showAlert:@"Error" withMessage:@"Please Turn Location Services on From Settings > Privacy > Location Services"];
    }
    if(locationManager != nil)
    {
        [locationManager startUpdatingLocation];
    }
    [PSUtility showProgressHUDWithText:nil onView:self];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"back_arrow.png" withSelectedImage:@"back_arrow.png" alignmentLeft:NO withSelecter:@selector(backPressed:) withTarget:self];
    [self.pinTextView becomeFirstResponder];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(locationManager != nil) {
        [locationManager stopUpdatingLocation];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTapped:(PSButton *)sender {
    switch (sender.tag) {
        case 101: {
            
        }break;
        case 102: {
            if([self.pinTextView.text length] == 0) {
                [PSUtility showAlert:@"Error" withMessage:@"Pin Name cann't be Empaty"];
                return;
            }
            if([[self.pinDataDict objectForKey:PIN_LOCATION] length] == 0) {
                [PSUtility showAlert:@"Error" withMessage:@"You can not add pin with out location So Please check location settings"];
                return;
            }
            [self.pinDataDict setValue:self.pinTextView.text forKey:PIN_NAME];
            PSCategoriesViewController *objCatVC = [[PSCategoriesViewController alloc] initWithNibName:@"PSCategoriesViewController" bundle:nil];
            objCatVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
            [self.navigationController pushViewController:objCatVC animated:YES];
        
        }break;
        case 103: {
            [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSShareConfirmViewController"] animated:YES];
        }break;
        default:
            break;
    }
}

#pragma mark - IBActions

- (IBAction) buttonSaveAgain:(id)sender
{
    [self.pinDataDict setValue:self.pinTextView.text forKey:PIN_NAME];
    PSCategoriesViewController *objCatVC = [[PSCategoriesViewController alloc] initWithNibName:@"PSCategoriesViewController" bundle:nil];
    objCatVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
    [self.navigationController pushViewController:objCatVC animated:YES];
    [viewSaveAgain removeFromSuperview];
}

- (IBAction) buttonCancel:(id)sender
{
    [self performSelector:@selector(backPressed:) withObject:nil afterDelay:0.0f];
    
    [viewSaveAgain removeFromSuperview];
}

#pragma mark - Location Manager
-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    if(locationManager == nil) {
        locationManager = [CLLocationManager new];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations objectAtIndex:0];
    //
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             NSString *address = [[NSString alloc]initWithString:locatedAt];
//             NSString *area = [[NSString alloc]initWithString:placemark.locality];
//             NSString *country = [[NSString alloc]initWithString:placemark.country];
//             NSString *countryArea = [NSString stringWithFormat:@"%@, %@", area,country];
//             NSLog(@"%@ \n %@ \n %@ \n%@",address,area,country,countryArea);
             [self.pinDataDict setValue:address forKey:PIN_LOCATION];
             [self.pinDataDict setValue:[NSString stringWithFormat:@"%f",[placemark location].coordinate.latitude] forKey:PIN_LAT];
             [self.pinDataDict setValue:[NSString stringWithFormat:@"%f",[placemark location].coordinate.longitude] forKey:PIN_LANG];
//             [PSUtility saveSessionValue:[NSMutableDictionary dic] ]
             [PSUtility saveSessionValue:@{@"new_lat": [NSString stringWithFormat:@"%f",[placemark location].coordinate.latitude],@"new_long": [NSString stringWithFormat:@"%f",[placemark location].coordinate.longitude]} withKey:@"NEW_LOCATION_DETAILS"];
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
         }
         [PSUtility hideProgressHUDFromVC:self];
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [PSUtility hideProgressHUDFromVC:self];
//    [PSUtility showAlert:@"Error" withMessage:error.localizedDescription];
    [PSUtility showAlert:@"Error" withMessage:@"Please Turn Location Services On From Settings > Privacy > Location Services"];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [textField becomeFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [textField resignFirstResponder];
    if([self.pinTextView.text length] == 0) {
        [PSUtility showAlert:@"Error" withMessage:@"Pin Name cann't be Empty"];
        return YES;
    }
    if([[self.pinDataDict objectForKey:PIN_LOCATION] length] == 0) {
        [PSUtility showAlert:@"Error" withMessage:@"You can not add pin with out location So Please check location settings"];
        return YES;
    }
    
    NSDictionary *old_dict = [PSUtility getValueFromSession:@"OLD_LOCATION_DETAILS"];
    NSDictionary *new_dict = [PSUtility getValueFromSession:@"NEW_LOCATION_DETAILS"];
    if (old_dict == nil) {
        
    } else {
        CLLocation *oldLocation = [[CLLocation alloc] initWithLatitude:[[old_dict objectForKey:@"old_lat"] floatValue] longitude:[[old_dict objectForKey:@"old_long"] floatValue]];
        
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:[[new_dict objectForKey:@"new_lat"] floatValue] longitude:[[new_dict objectForKey:@"new_long"] floatValue]];
        
        CLLocationDistance distance = [oldLocation distanceFromLocation:newLocation];
        if(distance < 6.096f) {
            [self.view endEditing:YES];
            
//            [[[UIApplication sharedApplication] keyWindow] addSubview:viewSaveAgain];
            
//            [PSUtility showAlert:@"" withMessage:@"You've already saved this location."];
            
          // PSCustomAlertView *customAlert = [[PSCustomAlertView alloc] initWithTitle:@"You've already saved this location." delegate:self isDoubleButton:YES ofOption:1];
            
            [[[UIApplication sharedApplication] keyWindow] addSubview:viewSaveAgain];
            
//            [PSUtility showAlert:@"Error" withMessage:@"You have already saved this location. Move 20 ft. to save another location"];
            return YES;
        }
    }
    [self.pinDataDict setValue:self.pinTextView.text forKey:PIN_NAME];
    PSCategoriesViewController *objCatVC = [[PSCategoriesViewController alloc] initWithNibName:@"PSCategoriesViewController" bundle:nil];
    objCatVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
    [self.navigationController pushViewController:objCatVC animated:YES];
    return YES;
}


@end

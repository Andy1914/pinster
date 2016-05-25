//
//  PSAddPinViewController.h
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"

@interface PSAddPinViewController : PSParentViewController<CLLocationManagerDelegate,UITextFieldDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet PSTextField *pinTextView;
@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIImageView *pinImage;

@end

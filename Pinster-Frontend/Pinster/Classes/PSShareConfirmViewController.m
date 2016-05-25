//
//  PSShareConfirmViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSShareConfirmViewController.h"
#import "PSContactPickerViewController.h"
#import "PSMyPinsViewController.h"
#import "PSPinDetailesViewController.h"

@interface PSShareConfirmViewController ()
{
    NSArray *arrayPinSaved;
    
    int totalPins;
}
- (IBAction)buttonClicked:(PSButton *)sender;

@end

@implementation PSShareConfirmViewController

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(PSButton *)sender {
    switch (sender.tag) {
        case 101: {
            PSContactPickerViewController *objContactVC = [[PSContactPickerViewController alloc] initWithNibName:@"PSContactPickerViewController" bundle:nil];
            objContactVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
            [self.navigationController pushViewController:objContactVC animated:YES];
        }break;
        case 102: {
            [self uploadPinDetailsToServer];
        }break;
            
        default:
            break;
    }
}

- (void)uploadPinDetailsToServer {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if([[appDelegate currentPinDetails] valueForKey:@"snapImage"] != nil) {
        [[WSHelper sharedInstance] uploadFileWithURL:kAddPinApi withMethod:@"POST" withParmeters:self.pinDataDict mediaData:UIImageJPEGRepresentation([PSUtility scaleImage:[[appDelegate currentPinDetails] valueForKey:@"snapImage"] toSize:CGSizeMake(620, 1136)], 1.0) withKey:@"shared_picture" completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
           
            [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"snapsaved"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSUserDefaults *objdefault =[NSUserDefaults standardUserDefaults];
            NSMutableArray *nameArray = [[objdefault objectForKey:@"snapsa"] mutableCopy];
            
            if(!nameArray)
                nameArray = [@[] mutableCopy];
            [nameArray addObject:@"1"];
            
            [objdefault setObject:nameArray forKey:@"snapsa"];
            
            [objdefault synchronize];
            
            totalPins = 0;
            for (int i = 0; i < [nameArray count]; i++)
            {
                totalPins = totalPins + [[nameArray objectAtIndex:i] intValue];
            }
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:totalPins] forKey:@"snapsaved"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self handleCompletionSharing:result withError:error];
        }];
    } else {
        [[WSHelper sharedInstance] getArrayFromPostURL:kAddPinApi parmeters:self.pinDataDict completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"pinsaved"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSUserDefaults *objdefault =[NSUserDefaults standardUserDefaults];
            NSMutableArray *nameArray = [[objdefault objectForKey:@"pinsa"] mutableCopy];
            
            if(!nameArray)
                nameArray = [@[] mutableCopy];
            [nameArray addObject:@"1"];
            
            [objdefault setObject:nameArray forKey:@"pinsa"];
            
            [objdefault synchronize];
            
            totalPins = 0;
            for (int i = 0; i < [nameArray count]; i++)
            {
                totalPins = totalPins + [[nameArray objectAtIndex:i] intValue];
            }
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:totalPins] forKey:@"pinsaved"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self handleCompletionSharing:result withError:error];
        }];
    }
}


- (void)handleCompletionSharing:(id)result withError:(NSError *)error {
    if(!error) {
        if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
            [PSUtility saveSessionValue:@{@"old_lat": [self.pinDataDict objectForKey:PIN_LAT],@"old_long": [self.pinDataDict objectForKey:PIN_LANG]} withKey:@"OLD_LOCATION_DETAILS"];
//            [[appDelegate subNavigationController] popToRootViewControllerAnimated:NO];
            PSPinDetailesViewController *detailVC = [[PSPinDetailesViewController alloc] initWithNibName:@"PSPinDetailesViewController" bundle:nil];
            detailVC.isBookmark = YES;
//            NSDictionary *dict = @{PIN_DATE: [[result objectForKey:@"data"] objectForKey:@"date"], PIN_ID: [[result objectForKey:@"data"] objectForKey:@"id"]};
//            
//            self.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            
            PSPinModel *pinDetails = [[PSPinModel alloc] initWithDictonery:self.pinDataDict];
            
            pinDetails.pinDate = [PSUtility getDateFromString:[[result objectForKey:@"data"] objectForKey:@"date"] withFormate:@"yyyy-MM-dd HH:mm:ss Z"];
            
            NSString *stringImageUrl = [NSString stringWithFormat:@"%@%@", kBaseImageOnlineUrl, [[result objectForKey:@"data"] objectForKey:@"shared_picture"]];
            pinDetails.snapImageUrl =  stringImageUrl;
            
            pinDetails.pinId = [[result objectForKey:@"data"] objectForKey:@"id"];
            detailVC.pinData = pinDetails;
            
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"pushtoview"];
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController pushViewController:detailVC animated:YES];
//            [[appDelegate subNavigationController] setViewControllers:[NSArray arrayWithObject:detailVC]];
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        }
    } else {
        [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
    }
}
@end

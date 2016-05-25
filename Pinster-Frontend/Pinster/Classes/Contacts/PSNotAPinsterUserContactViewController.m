//
//  PSNotAPinsterUserContactViewController.m
//  Pinster
//
//  Created by CHINAB on 9/22/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSNotAPinsterUserContactViewController.h"

@interface PSNotAPinsterUserContactViewController ()
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;

@property (nonatomic, strong) IBOutlet UIButton *buttonInvite;

@end

@implementation PSNotAPinsterUserContactViewController

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
    
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Invite to Pinster"]];
    
    self.nameLabel.text = self.contact.fullName;
    
    self.numberLabel.text = self.contact.phone;
//    self.numberLabel.text = [self.contact.phone stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
//    [UIColor colorWithRed:66.0f/255.0f green:167.0f/255.0f blue:188.0f/255.0f alpha:1.0f]
    [_buttonInvite setTitleColor:[UIColor colorWithRed:22.0f/255.0f green:96.0f/255.0f blue:107.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
}

- (IBAction)sendContactRequest:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[PSUtility getCurrentUserId],kUser_IdKey,self.numberLabel.text,kMobileNumberKey, nil];
    
    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kInviteContactApi,kInviteContact] parmeters:params completionHandler:^(id result, NSString *url, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                int totalPins;
                
                [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"snapshared"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSUserDefaults *objdefault =[NSUserDefaults standardUserDefaults];
                NSMutableArray *nameArray = [[objdefault objectForKey:@"snapsh"] mutableCopy];
                
                if(!nameArray)
                    nameArray = [@[] mutableCopy];
                [nameArray addObject:@"1"];
                
                [objdefault setObject:nameArray forKey:@"snapsh"];
                
                [objdefault synchronize];
                
                totalPins = 0;
                for (int i = 0; i < [nameArray count]; i++)
                {
                    totalPins = totalPins + [[nameArray objectAtIndex:i] intValue];
                }
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:totalPins] forKey:@"snapshared"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

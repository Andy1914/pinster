//
//  PSLoginViewController.m
//  Pinster
//
//  Created by Mobiledev on 19/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSWelcomeViewController.h"

@interface PSWelcomeViewController ()

@end

@implementation PSWelcomeViewController

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
    
    [self.navigationController setViewControllers:[NSArray arrayWithObject:self]];
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if([objUser valueForKey:kEmailKey] != nil && [objUser valueForKey:kEmailKey] > 0) {
        PSEmailLoginViewController *objPSEmailLogin = [[PSEmailLoginViewController alloc] initWithNibName:@"PSEmailLoginViewController" bundle:nil];
        [self.navigationController pushViewController:objPSEmailLogin animated:NO];
    }
    
    [self loadWelcomeScrollViewWithPage:0];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadWelcomeScrollViewWithPage:(int)pageNumber {
    for (UIView *subViews in self.welcomeScrollView.subviews) {
        [subViews removeFromSuperview];
    }
    
    CGFloat cx = 0;
    self.welcomeView.frame = CGRectMake(cx, 0, 320, self.view.frame.size.height);
    cx += 320;
    self.walkThroughFirstView.frame = CGRectMake(cx, 0, 320, self.view.frame.size.height);
    cx += 320;
    self.walkThroughSecondView.frame = CGRectMake(cx, 0, 320, self.view.frame.size.height);
    cx += 320;
    self.walkThroughThirdView.frame = CGRectMake(cx, 0, 320, self.view.frame.size.height);
    cx += 320;
    self.lastWelcomeView.frame = CGRectMake(cx, 0, 320, self.view.frame.size.height);
    
    [self.welcomeScrollView addSubview:self.welcomeView];
    [self.welcomeScrollView addSubview:self.walkThroughFirstView];
    [self.welcomeScrollView addSubview:self.walkThroughSecondView];
    [self.welcomeScrollView addSubview:self.walkThroughThirdView];
    [self.welcomeScrollView addSubview:self.lastWelcomeView];
    
    [self.welcomeScrollView setContentSize:CGSizeMake(cx + 320, self.welcomeScrollView.frame.size.height)];
    
    [self scrollToPageNumber:pageNumber];
}

- (void)scrollToPageNumber:(int)pageNumber {
    if (pageNumber == 0 || pageNumber == 4) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
    
    [self.welcomeScrollView setContentOffset:CGPointMake(pageNumber * 320, 0) animated:YES];
}

-(IBAction)btnRegistrationClicked:(id)sender{
    PSRegistrationViewController *objPSReg = [[PSRegistrationViewController alloc] initWithNibName:@"PSRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:objPSReg animated:YES];
}
#pragma mark - Action methods
-(IBAction)btnFacebookClicked:(id)sender{
    [self loginWithFacebook];
}

-(IBAction)btnEmailClicked:(id)sender{
    PSEmailLoginViewController *objPSEmailLogin = [[PSEmailLoginViewController alloc] initWithNibName:@"PSEmailLoginViewController" bundle:nil];
    [self.navigationController pushViewController:objPSEmailLogin animated:YES];
}

#pragma mark - Memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - facebook
- (void)loginWithFacebook {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile,email,user_birthday,user_about_me"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             // Retrieve the app delegate
             switch (state) {
                 case FBSessionStateOpen: {
                     [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                         if (error) {
                             
                             NSLog(@"error:%@",error);
                             
                             
                         }
                         else
                         {
                             // retrive user's details at here as shown below
                             NSLog(@"FB user first name:%@",user.first_name);
                             NSLog(@"FB user last name:%@",user.last_name);
                             NSLog(@"FB user birthday:%@",user.birthday);
                             NSLog(@"FB user location:%@",user.location);
                             NSLog(@"FB user username:%@",user.username);
                             NSLog(@"FB user gender:%@",[user objectForKey:@"gender"]);
                             NSLog(@"email id:%@",[user objectForKey:@"email"]);
                             NSLog(@"location:%@", [NSString stringWithFormat:@"Location: %@\n\n",
                                                    user.location[@"name"]]);
                             //                             @{kFacebookIdKey: user.id,kNameKey:user.username,kEmailKey:[user objectForKey:@"email"],kDOBKey:user.birthday}
                             NSMutableDictionary *dict = [NSMutableDictionary new];
                             if(user.id) {
                                 [dict setObject:user.id forKey:kFacebookIdKey];
                             }
                             if(user.first_name || user.last_name) {
                                 [dict setObject:[NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name] forKey:kNameKey];
                             }
                             if([user objectForKey:@"email"]) {
                                 [dict setObject:[user objectForKey:@"email"] forKey:kEmailKey];
                             }
                             if(user.birthday) {
                                 [dict setObject:user.birthday forKey:kDOBKey];
                             }
                             [dict setObject:[PSUtility getValueFromSession:KpushNotificationToken] forKey:KpushNotificationToken];
                             
                             [self btnLoginClicked:dict];
                             
                             
                         }
                     }];
                 }
                     break;
                     
                 case FBSessionStateClosed:
                 case FBSessionStateClosedLoginFailed:
                     [FBSession.activeSession closeAndClearTokenInformation];
                     break;
                     
                 default:
                     break;
             }
         }];
    }
}

-(void)btnLoginClicked:(NSDictionary *)user
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPostURL:kLoginWithFacebookApi parmeters:user completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:[result valueForKey:KDataKey]];
                [userData setValue:[user valueForKey:kFacebookIdKey] forKey:kFacebookIdKey];
                [PSUtility saveSessionValue:userData withKey:kUserDetailsKey];
                if(![PSUtility isTrue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey]]) {
                    [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSMobileNumberViewController"] animated:YES];
                } else {
                    [appDelegate configureSidePanel];
                }
                
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

#pragma UIScrollview Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int pageNumberToBeScrolled = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = pageNumberToBeScrolled;
    
    if (pageNumberToBeScrolled == 0 || pageNumberToBeScrolled == 4) {
        self.pageControl.hidden = YES;
    } else {
        self.pageControl.hidden = NO;
    }
}

@end

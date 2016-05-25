//
//  PSAppDelegate.m
//  Pinster
//
//  Created by Mobiledev on 18/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.

// Device Tokem "eb5f84ce667481a671405b2e5970c1bc90d8ec884c19ef67385c24cd3cbcd3f6"


#import "PSAppDelegate.h"
#import "PSHomeViewController.h"
#import "PSRightPanelTableViewController.h"
#import "PSPinDetailesViewController.h"
#import "PSConstatnts.h"


@implementation PSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    application.applicationIconBadgeNumber = 0;
    
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [PSUtility saveSessionValue:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] withKey:KpushNotificationData];
    }
    self.currentPinDetails = [NSMutableDictionary new];
    [self setupInitialSettings];
    
//    [self temp];
    return YES;
}

//- (void)temp {
//    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kCheckUserExistsApi,kCheckUserExists] parmeters:[NSDictionary dictionaryWithObject:@"1" forKey:@"id"] completionHandler:^(id result, NSString *url, NSError *error) {
//        if(!error) {
//            if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [[[result valueForKey:KDataKey] allKeys] count] >0) {
//                
//            } else {
////                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
//            }
//        } else {
////            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
//        }
//    }];
//
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"togglereceived"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)setupInitialSettings {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    //    [self.window setBackgroundColor:[UIColor colorWithRed:245/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    
    //TODO: Need to change the root 
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:[PSUtility getViewControllerWithName:@"PSLoadingViewController"]];//PSLoadingViewController
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kUserDetailsKey])
    {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[PSUtility getViewControllerWithName:@"PSHomeViewController"]];
        
        [self configureSidePanel];
        self.window.rootViewController = self.navigationController;
    }
    else
    {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:[PSUtility getViewControllerWithName:@"PSLoadingViewController"]];
        [self customiseNavigationbar:self.navigationController];
        self.window.rootViewController = self.navigationController;
    }
    
    [self.window makeKeyAndVisible];
    [PSUtility saveSessionValue:@"" withKey:KpushNotificationToken];
}

-(void)customiseNavigationbar :(UINavigationController *)navController {
    navController.navigationItem.hidesBackButton = YES;
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [navController navigationBar].translucent = YES;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"header-inner-commen.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)removeLoadingScreen {

}

- (void)addAlphaImage {
    [self removeAlphaImage];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, self.window.bounds.size.height)];
    [imgView setTag:1000000];
    [imgView setAlpha:0.0];
    [self.window addSubview:imgView];
    [imgView setBackgroundColor:[UIColor blackColor]];
    [UIView animateWithDuration:0.0 animations:^{
        [imgView setAlpha:0.5];
    }];
    
}

- (void)removeAlphaImage {
    UIView *imgView = [self.window viewWithTag:1000000];
    if(imgView == nil) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [imgView setAlpha:0.0];
        [imgView removeFromSuperview];
    }];
    
}
- (void)configureSidePanel {
    self.subNavigationController = [[UINavigationController alloc] initWithRootViewController:[PSUtility getViewControllerWithName:@"PSHomeViewController"]];
    self.subNavigationController.navigationBarHidden = YES;

    PSRightPanelTableViewController *menuViewController = [[PSRightPanelTableViewController alloc] initWithNibName:@"PSRightPanelTableViewController" bundle:nil];
    CGRect rect = [[UIScreen mainScreen] bounds];
    PSButton *menuBtn = [[PSButton alloc] initWithFrame:CGRectMake(rect.size.width-40, rect.size.height-40, 30, 30)];
    [menuBtn setTitle:@"Menu" forState:UIControlStateNormal];
    [menuBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [menuBtn setBackgroundColor:[UIColor greenColor]];
    [menuBtn addTarget:self action:@selector(openRightMenu) forControlEvents:UIControlEventTouchUpInside];

    [self customiseNavigationbar:self.subNavigationController];
    NSMutableDictionary *pushData = [PSUtility getValueFromSession:KpushNotificationData];
    if(pushData != nil) {
        [self openPinDetailsFromPushNotification];
    }
    
    
    self.sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.subNavigationController
                                                                    leftMenuViewController:menuViewController
                                                                   rightMenuViewController:nil];

    [self.sideMenuViewController.view setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:182.0/255.0 blue:198.0/255.0 alpha:1.0]];
    self.sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    self.sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    self.sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    self.sideMenuViewController.contentViewShadowOpacity = 0.6;
    self.sideMenuViewController.contentViewShadowRadius = 12;
    self.sideMenuViewController.contentViewShadowEnabled = YES;

    [UIView animateWithDuration:0.75
                     animations:^{
                         [self.navigationController pushViewController:self.sideMenuViewController animated:YES];
                     }];

}

- (void)openRightMenu {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:
(NSData *)deviceToken {
    NSString *deviceTokenStr = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    dLog(@"Token: %@",deviceTokenStr);
    [PSUtility saveSessionValue:deviceTokenStr withKey:KpushNotificationToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:
(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error);
//    [PSUtility showAlert:@"Error" withMessage:error.localizedDescription];
    [PSUtility saveSessionValue:@"" withKey:KpushNotificationToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
    [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    
    NSLog(@"Badge %d",[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]);
    
    if([[self.subNavigationController viewControllers] count] ==0) {
        return;
    }
    [PSUtility saveSessionValue:userInfo withKey:KpushNotificationData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:
                          [[userInfo valueForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:
                          @"Cancel" otherButtonTitles:@"Open", nil];

    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self openPinDetailsFromPushNotification];
    }else {
        [PSUtility removeValueFromSessionWithKey:KpushNotificationData];
    }
}

- (void)openPinDetailsFromPushNotification {
    PSParentViewController *currentViewController = [[self.subNavigationController viewControllers] lastObject];
    NSMutableDictionary *pushData = [PSUtility getValueFromSession:KpushNotificationData];
    if(pushData == nil) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:currentViewController.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kPinDetailsApi,[[[pushData valueForKey:@"acme2"] objectAtIndex:0] valueForKey:@"pin_id"]] parmeters:nil completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:currentViewController.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [[[result valueForKey:KDataKey] allKeys] count] >0) {
                PSPinModel *pinDetails = [[PSPinModel alloc] initWithDictonery:[result objectForKey:KDataKey]];
                PSPinDetailesViewController *detailVC = [[PSPinDetailesViewController alloc] initWithNibName:@"PSPinDetailesViewController" bundle:nil];
                detailVC.pinData = pinDetails;
                [self.subNavigationController pushViewController:detailVC animated:YES];
                [PSUtility removeValueFromSessionWithKey:KpushNotificationData];
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:currentViewController withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:currentViewController withDelegate:nil];
        }
    }];
}
@end

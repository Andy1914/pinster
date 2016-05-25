//
//  PSAppDelegate.h
//  Pinster
//
//  Created by Mobiledev on 18/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RESideMenu.h"

@interface PSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UINavigationController *subNavigationController;
@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (strong, nonatomic) NSMutableDictionary *currentPinDetails;

- (void)configureSidePanel;
- (void)openRightMenu;
-(void)customiseNavigationbar :(UINavigationController *)navController;
- (void)openPinDetailsFromPushNotification;
- (void)addAlphaImage;
- (void)removeAlphaImage;
@end

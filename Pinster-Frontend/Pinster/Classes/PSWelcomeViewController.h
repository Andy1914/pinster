//
//  PSLoginViewController.h
//  Pinster
//
//  Created by Mobiledev on 19/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSEmailLoginViewController.h"

@interface PSWelcomeViewController : PSParentViewController <UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *welcomeScrollView;

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIView *welcomeView;
@property (nonatomic, strong) IBOutlet UIView *walkThroughFirstView;
@property (nonatomic, strong) IBOutlet UIView *walkThroughSecondView;
@property (nonatomic, strong) IBOutlet UIView *walkThroughThirdView;
@property (nonatomic, strong) IBOutlet UIView *lastWelcomeView;

@property (weak, nonatomic) IBOutlet PSButton *btnRegisration;
-(IBAction)btnFacebookClicked:(id)sender;
-(IBAction)btnEmailClicked:(id)sender;

@end

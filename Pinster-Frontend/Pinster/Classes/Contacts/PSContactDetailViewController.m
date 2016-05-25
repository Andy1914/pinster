//
//  PSContactDetailViewController.m
//  Pinster
//
//  Created by CHINAB on 9/22/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSContactDetailViewController.h"

@interface PSContactDetailViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *lastSeenLabel;
@property (nonatomic, strong) IBOutlet UILabel *pinsTakenValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *snapsTakenValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *pinsSharedValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *snapsSharedValueLabel;

@end

@implementation PSContactDetailViewController

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
    
    self.title = @"Profile";
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.layer.masksToBounds = YES;
//    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.profileImageView.layer.borderWidth = 3.0;

    //Pins Taken Value Label
    self.pinsTakenValueLabel.layer.cornerRadius = self.pinsTakenValueLabel.frame.size.height / 2;
    self.pinsTakenValueLabel.layer.masksToBounds = YES;
    self.pinsTakenValueLabel.layer.borderColor = [UIColor colorWithRed:144.0/255.0 green:207.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.pinsTakenValueLabel.layer.borderWidth = 6.0;

    //Pins Shared Value Label
    self.pinsSharedValueLabel.layer.cornerRadius = self.pinsSharedValueLabel.frame.size.height / 2;
    self.pinsSharedValueLabel.layer.masksToBounds = YES;
    self.pinsSharedValueLabel.layer.borderColor = [UIColor colorWithRed:144.0/255.0 green:207.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.pinsSharedValueLabel.layer.borderWidth = 6.0;

    //Snaps Taken Value Label
    self.snapsTakenValueLabel.layer.cornerRadius = self.snapsTakenValueLabel.frame.size.height / 2;
    self.snapsTakenValueLabel.layer.masksToBounds = YES;
    self.snapsTakenValueLabel.layer.borderColor = [UIColor colorWithRed:144.0/255.0 green:207.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.snapsTakenValueLabel.layer.borderWidth = 6.0;

    //Snaps Shared Value Label
    self.snapsSharedValueLabel.layer.cornerRadius = self.snapsSharedValueLabel.frame.size.height / 2;
    self.snapsSharedValueLabel.layer.masksToBounds = YES;
    self.snapsSharedValueLabel.layer.borderColor = [UIColor colorWithRed:144.0/255.0 green:207.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.snapsSharedValueLabel.layer.borderWidth = 6.0;

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.nameLabel.text = self.stringName;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

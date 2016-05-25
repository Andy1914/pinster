//
//  PSContactTypeViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSContactTypeViewController.h"

@interface PSContactTypeViewController ()
- (IBAction)buttonClicked:(PSButton *)sender;
@end

@implementation PSContactTypeViewController

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
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(PSButton *)sender {
    switch (sender.tag) {
        case 101:
            [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSContactPickerViewController"] animated:YES];
            break;
        case 102:
            
            break;
            
        default:
            break;
    }
}


@end

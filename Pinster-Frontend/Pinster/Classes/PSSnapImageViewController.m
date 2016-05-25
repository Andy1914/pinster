//
//  PSSnapImageViewController.m
//  Pinster
//
//  Created by CHINAB on 9/20/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSSnapImageViewController.h"

@interface PSSnapImageViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *snapImageView;
@end

@implementation PSSnapImageViewController

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
    self.snapImageView.image = self.snapImage;
    self.snapImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

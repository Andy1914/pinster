//
//  PSTermsAndPrivecyViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/08/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSTermsAndPrivecyViewController.h"

@interface PSTermsAndPrivecyViewController ()

@end

@implementation PSTermsAndPrivecyViewController

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
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Terms and Privacy"]];
    
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:[PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self], nil]];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"termsnprivacy" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [self.webViewObject loadHTMLString:htmlString baseURL:nil];

}
-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PSCategoryWisePinsViewController.m
//  Pinster
//
//  Created by Mobiledev on 01/07/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSCategoryWisePinsViewController.h"
#import "PSPinTableViewCell.h"
#import "PSPinModel.h"
#import "PSPinDetailesViewController.h"

static NSString *pinCellIdentifier = @"PSPinTableViewCell";


@interface PSCategoryWisePinsViewController ()

@end

@implementation PSCategoryWisePinsViewController

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
    [self.pinsTableView registerNib:[UINib nibWithNibName:@"PSPinTableViewCell" bundle:nil] forCellReuseIdentifier:pinCellIdentifier];
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self];
    // Do any additional setup after loading the view from its nib.
}
-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    if(self.isMyPinsOnly)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"My Pins"]];
    else
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Received Pins"]];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pinsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    PSPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pinCellIdentifier];
    PSPinModel *pinModel = [self.pinsArray objectAtIndex:indexPath.row];
    cell.lblPinName.text = pinModel.pinName;
    cell.lblDate.text = [pinModel.pinDate timeAgo];
    cell.lblTime.text = pinModel.pinTimeString;
    [cell.imgStatus setImage:[UIImage imageNamed:self.category_image]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PSPinDetailesViewController *detailVC = [[PSPinDetailesViewController alloc] initWithNibName:@"PSPinDetailesViewController" bundle:nil];
    detailVC.pinData = [self.pinsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end

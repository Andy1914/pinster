//
//  PSAccountSettingsViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/08/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSAccountSettingsViewController.h"
#import "PSSettingsTableViewCell.h"


@interface PSAccountSettingsViewController ()
@property (nonatomic, strong) NSMutableArray *optionsArray;
@end
@implementation PSAccountSettingsViewController
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
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Account Settings"]];
    [self.tableviewObj registerNib:[UINib nibWithNibName:@"PSSettingsTableViewCell" bundle:nil] forCellReuseIdentifier:@"PSSettingsTableViewCell"];
    self.optionsArray = [NSMutableArray arrayWithArray:[PSUtility loadDataFromLocalJsonfile:@"accountSettings"]];
    [self.tableviewObj reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:[PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self], nil]];
}

-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openRightMenu {
    [appDelegate openRightMenu];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.optionsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PSSettingsTableViewCell" forIndexPath:indexPath];
    NSDictionary *setDict = [self.optionsArray objectAtIndex:indexPath.row];
    cell.lblName.text = [setDict objectForKey:@"name"];
    cell.imgIcon.image = [UIImage imageNamed:[setDict objectForKey:@"image"]];
    [cell.switchNotification setHidden:YES];
    [cell.imgArrow setHidden:YES];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *setDict = [self.optionsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[PSUtility getViewControllerWithName:[setDict objectForKey:@"nibname"]] animated:YES];
}

@end

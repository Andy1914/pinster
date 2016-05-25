//
//  PSRightPanelTableViewController.m
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSRightPanelTableViewController.h"
#import "PSMenuTableViewCell.h"
#import "PSMyPinsViewController.h"

@interface PSRightPanelTableViewController ()
@property (nonatomic, strong) NSMutableArray *menuArray;

@end
static NSString *menuCellIdentifier = @"PSMenuTableViewCell";
@implementation PSRightPanelTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuArray = [NSMutableArray arrayWithArray:[PSUtility loadDataFromLocalJsonfile:@"Menu"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"PSMenuTableViewCell" bundle:nil] forCellReuseIdentifier:menuCellIdentifier];
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_img.png"]]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];

    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    cell.lblMenuTitle.text = [[self.menuArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.iconView setImage:[UIImage imageNamed:[[self.menuArray objectAtIndex:indexPath.row] objectForKey:@"image"]]];
//    [cell.iconView setHighlightedImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-h.png",[[self.menuArray objectAtIndex:indexPath.row] objectForKey:@"image"]]]];
    if([[[self.menuArray objectAtIndex:indexPath.row] objectForKey:@"name"] length] == 0) {
        [cell.arrowImg setHidden:YES];
        [cell.lineImg setHidden:YES];
        [cell setUserInteractionEnabled:NO];
    } else {
//        [cell.arrowImg setHidden:NO];
        [cell.lineImg setHidden:NO];
        [cell setUserInteractionEnabled:YES];
    }
    CGRect frame = cell.lineImg.frame;
    frame.size.height = 0.1;
//    cell.lineImg.layer.shadowOffset = CGSizeMake(0.1, 0.1);
//    cell.lineImg.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    [cell.lineImg setFrame:frame];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[[PSUtility getValueFromSession:@"Selected_row"] integerValue] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[[self.menuArray objectAtIndex:indexPath.row] objectForKey:@"name"] length] == 0) {
        
        return;
    }
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [PSUtility saveSessionValue:[NSString stringWithFormat:@"%li",(long)indexPath.row] withKey:@"Selected_row"];
    NSDictionary *menuDict = [self.menuArray objectAtIndex:indexPath.row];
    [[appDelegate subNavigationController] popToRootViewControllerAnimated:NO];
    if([[menuDict valueForKey:@"name"] isEqualToString:@"Bookmarks"]) {
        PSMyPinsViewController *pinsVc =  [[PSMyPinsViewController alloc] initWithNibName:@"PSMyPinsViewController" bundle:[NSBundle mainBundle]];
        pinsVc.isMyPinsOnly = YES;
        [[appDelegate subNavigationController] setViewControllers:[NSArray arrayWithObject:pinsVc]];
    } else {
        [[appDelegate subNavigationController] setViewControllers:[NSArray arrayWithObject:[PSUtility getViewControllerWithName:[menuDict valueForKey:@"nibname"]]]];
    }
    
    [[appDelegate sideMenuViewController] hideMenuViewController];
}

@end

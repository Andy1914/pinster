//
//  PSMyPinsViewController.m
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSMyPinsViewController.h"
#import "PSPinTableViewCell.h"
#import "PSPinCategoryTableViewCell.h"
#import "PSPinModel.h"
#import "PSCategoryModel.h"
#import "PSPinDetailesViewController.h"
#import "PSCategoryWisePinsViewController.h"
#import "PSCategoryCell.h"


static NSString *categoryCellIdentifier = @"PSCategoryCell";

@interface PSMyPinsViewController ()
{
    PSPinModel *pinModel;
    
    IBOutlet UICollectionView *collectionViewCategory;
    
    IBOutlet UIView *viewCategories;
    
    IBOutlet UILabel *labelBackground;
    
    NSMutableArray *categoriesArray;
    
    IBOutlet UISearchBar *searchBarTableView;
    
    NSMutableArray *pinsArray;
    
    NSString *pinName;
    
    int seachBarUsed, categorySelected;
}

- (IBAction) buttonCloseCategory:(id)sender;

@property (nonatomic, strong) IBOutlet UILabel *pinLabel, *listLabel;
@property (nonatomic, strong) IBOutlet UILabel *snapLabel, *savedLabel;

@property (nonatomic, strong) NSMutableArray *arraySearch;

@property  (nonatomic, readwrite) BOOL isSnap;

@end
static NSString *pinCellIdentifier = @"PSPinTableViewCell";

@implementation PSMyPinsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) dealloc
{
    self.toggleView = Nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pinsTableView registerNib:[UINib nibWithNibName:@"PSPinTableViewCell" bundle:nil] forCellReuseIdentifier:pinCellIdentifier];
    
//    [self.view bringSubviewToFront:self.pinLabel];
//    [self.view bringSubviewToFront:self.snapLabel];
    seachBarUsed=0;
    categorySelected=0;

   // searchBarTableView.barTintColor = [UIColor colorWithRed:208.0f/255.0f green:229.0f/255.0f blue:232.0f/255.0f alpha:0.0f];
      searchBarTableView.barTintColor = [UIColor whiteColor];
    [searchBarTableView setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_270x44.png"] forState:UIControlStateNormal];
    
    searchBarTableView.frame=CGRectMake(5, 5, 100, 30);
    
//    labelBackground.backgroundColor = [UIColor colorWithRed:208.0f/255.0f green:229.0f/255.0f blue:232.0f/255.0f alpha:0.0f];
//    [searchBarTableView addSubview:labelBackground];
    
// UIImageView *searchBarImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_540x88.png"]];
//  searchBarImage.frame=CGRectMake(5, 10, 50, 20);
//    searchBarImage.tag=555;
//    
//    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 50, 20)];
//    lab.text=@"cvnckvbnkcvb";
//    lab.backgroundColor=[UIColor redColor];
//    
//
//    [searchBarTableView addSubview:searchBarImage];
//    [self.view bringSubviewToFront:searchBarImage];
//    
////    UITextField *searchField;
//    NSUInteger numViews = [searchBarTableView.subviews count];
//    for(int i = 0; i < numViews; i++) {
//  
//       // searchField = [searchBarTableView.subviews objectAtIndex:i];
//        if([[searchBarTableView.subviews objectAtIndex:i] tag]!=555)
//        [searchBarImage bringSubviewToFront:[searchBarTableView.subviews objectAtIndex:i]];
//   
//    }
//    if(!(searchField == nil)) {
//        searchField.textColor = [UIColor whiteColor];
//        [searchField setBackground: [UIImage imageNamed:@"search_540x88.png"]];//just add here gray image which you display in quetion
//        [searchField setBorderStyle:UITextBorderStyleNone];
//    }
    
    
    
 //[searchBarTableView setBackgroundImage:[UIImage imageNamed:@"search_540x88.png"] forBarPosition:0 barMetrics:UIBarMetricsDefault];
    
   // [searchBarTableView setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_540x88.png"] forState:UIControlStateNormal];
   // [searchBarTableView addSubview:searchBarImage];
    
    self.toggleView = [[ToggleView alloc] init];
    
    [collectionViewCategory registerNib:[UINib nibWithNibName:@"PSCategoryCell" bundle:nil] forCellWithReuseIdentifier:categoryCellIdentifier];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"togglereceived"];
//    
//    [[NSUserDefaults standardUserDefaults] synchronize];
    searchBarTableView.hidden = YES;
    pinModel = nil;
    
    [self callPinsListApi];
    
    self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"organize-icon.png" withSelectedImage:@"organize-icon.png" alignmentLeft:NO withSelecter:@selector(openPopUp) withTarget:self];
    
    if(self.isMyPinsOnly)
    {
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Bookmarks"]];
    
        _pinLabel.hidden = NO;
        _snapLabel.hidden = NO;
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"togglereceived"];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        _pinLabel.hidden = NO;
        _snapLabel.hidden = NO;
        
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Received"]];
        
//        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"togglereceived"];
//        
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.toggleView = [self.toggleView initWithFrame:CGRectMake(17, 70, 286, 37) toggleViewType:ToggleViewTypeNoLabel toggleBaseType:ToggleBaseTypeDefault toggleButtonType:ToggleButtonTypeChangeImage];
    
    self.toggleView.toggleDelegate = self;
    
    [self.view addSubview:self.toggleView];
    
    [self.toggleView setSelectedButton:ToggleButtonSelectedLeft];
    
    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
}


- (void) openPopUp
{
    [self.view endEditing:YES];
    
    [self getCategoriesFromOnline];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:viewCategories];
    
    NSLog(@"PIN");
}

- (IBAction) buttonCloseCategory:(id)sender
{
    [viewCategories removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openRightMenu {
    [appDelegate openRightMenu];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[self getSpecificPinsFromPinsList] count];
    if(self.isSnap && count == 0) {
        [self.lnlNoData setText:@"No Snaps found"];
        [tableView setHidden:NO];
        [self.lnlNoData setHidden:NO];
        [self.view bringSubviewToFront:self.lnlNoData];
    } else if(count == 0) {
        [self.lnlNoData setText:@"No Pins found"];
        [tableView setHidden:NO];
        [self.lnlNoData setHidden:NO];
        [self.view bringSubviewToFront:self.lnlNoData];
    } else {
        [tableView setHidden:NO];
        [self.lnlNoData setHidden:YES];
    }
    return [[self getSpecificPinsFromPinsList] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PSPinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pinCellIdentifier];
    pinModel = [[self getSpecificPinsFromPinsList] objectAtIndex:indexPath.row];
//    if ([pinModel.pinCategory isEqualToString:@"5"])
//    {
//        cell.lblPinName.text = pinModel.pinName;
//        cell.lblDate.text = [NSString stringWithFormat:@"%@ by %@", [pinModel.pinDate timeAgo], pinModel.pinOwnerName];
//        cell.lblTime.text = pinModel.pinTimeString;
//        
//        [cell.imgStatus setImage:[PSUtility getCategoryImageWithId:pinModel.pinCategory isSmall:YES]];
//    }
//    else
//    {
        cell.lblPinName.text = pinModel.pinName;
    
    if(self.isMyPinsOnly)
    {
        cell.lblDate.text = [NSString stringWithFormat:@"%@", [pinModel.pinDate timeAgo]];
    }
    else
    {
        cell.lblDate.text = [NSString stringWithFormat:@"%@ by", [pinModel.pinDate timeAgo]];
        
        cell.lblOwnerName.textColor = [UIColor colorWithRed:66.0f/255.0f green:167.0f/255.0f blue:188.0f/255.0f alpha:1.0f];
        
        cell.lblOwnerName.text = [NSString stringWithFormat:@"%@", pinModel.pinOwnerName];
    }
    
        cell.lblTime.text = pinModel.pinTimeString;
        if(self.isSnap) {
            [cell.imgPinType setImage:[UIImage imageNamed:@"snap-icon.png"]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pinModel.snapImageUrl]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                [self.indicator stopAnimating];
                    [cell.imgPinType setImage:[UIImage imageWithData:data]];
                });
            });
            
            /*
             dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             //this will start the image loading in bg
             dispatch_async(concurrentQueue, ^{
             NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:pinModel.snapImageUrl]];
             
             //this will set the image when loading is finished
             dispatch_async(dispatch_get_main_queue(), ^{
             cell.imgPinType.image = [UIImage imageWithData:image];
             });
             });*/
        } else {
            [cell.imgPinType setImage:[UIImage imageNamed:@"pin-icon.png"]];
        }
        
        [cell.imgStatus setImage:[PSUtility getCategoryImageWithId:pinModel.pinCategory isSmall:YES]];
//    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    // NSLog(@"offset: %f", offset.y);
//    // NSLog(@"content.height: %f", size.height);
//    // NSLog(@"bounds.height: %f", bounds.size.height);
//    // NSLog(@"inset.top: %f", inset.top);
//    // NSLog(@"inset.bottom: %f", inset.bottom);
//    // NSLog(@"pos: %f of %f", y, h);
//    
//    float reload_distance = 10;
//    if(y > h + reload_distance) {
   self.pinsTableView.tableHeaderView = searchBarTableView;
    
  //  [self.pinsTableView.tableHeaderView addSubview:searchBarTableView];

//    searchBarTableView.frame = CGRectMake(25, 97, 275, 44);
    
        searchBarTableView.hidden = NO;
//    if (IS_IPHONE5)
//        self.pinsTableView.frame = CGRectMake(0, 115, 320, 453);
//    else
//        self.pinsTableView.frame = CGRectMake(0, 115, 320, 365);
//        NSLog(@"load more rows");
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.toggleView = Nil;
    [self.view endEditing:YES];
    self.pinsTableView.tableHeaderView = nil;
    PSPinDetailesViewController *detailVC = [[PSPinDetailesViewController alloc] initWithNibName:@"PSPinDetailesViewController" bundle:nil];
    detailVC.isBookmark = self.isMyPinsOnly;
    
    detailVC.stringIsSharaeable = [[NSString stringWithFormat:@"%@", pinModel.pinIsShareable] intValue];
    
    detailVC.pinData = [[self getSpecificPinsFromPinsList] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - UISearchField Delegates

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchBarTableView resignFirstResponder];
}
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *) searchText
{
    pinName = searchText;
    seachBarUsed=1;
    [self.pinsTableView reloadData];
}

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBarTableView resignFirstResponder];
    
    return YES;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBarTableView resignFirstResponder];
}
#pragma mark - Web service call
- (void)callPinsListApi {
    self.arraySearch = [NSMutableArray new];
    pinsArray = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlString = kListOfReceivedPins;
    if(self.isMyPinsOnly) {
        urlString = kListOfPinApi;
    }
    [[WSHelper sharedInstance] getArrayFromGetURL:urlString parmeters:@{kUser_IdKey: [PSUtility getCurrentUserId]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error)
        {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]])
            {
                for (NSDictionary *objUserDict in [result valueForKeyPath:kMyPinsKey])
                {
                    [self.arraySearch addObject:[[PSPinModel alloc] initWithDictonery:objUserDict]];
                    
                    pinsArray = [NSArray arrayWithArray:self.arraySearch];
                }
                for (NSDictionary *objUserDict in [result valueForKeyPath:kListOfReceivedPins])
                {
                    [pinsArray addObject:[[PSPinModel alloc] initWithDictonery:objUserDict]];
                }
                [self.pinsTableView reloadData];
            }
            else
            {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        }
        else
        {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

- (NSArray *)getSpecificPinsFromPinsList
{
    NSPredicate *predicate = nil;
    if(self.isSnap)
    {
        predicate = [NSPredicate predicateWithFormat:@"self.snapImageUrl CONTAINS %@",kBaseImageOnlineUrl];
    }
    else
    {
        predicate = [NSPredicate predicateWithFormat:@"NOT (self.snapImageUrl CONTAINS %@)",kBaseImageOnlineUrl];
    }
    NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:[pinsArray filteredArrayUsingPredicate:predicate]];
    if (categorySelected!=0) {
        
        for (pinModel in [pinsArray filteredArrayUsingPredicate:predicate]) {
            
            if(pinModel.pinCategory.intValue != categorySelected)
                [filteredArray removeObject:pinModel];
            //  [arrForCategory addObject:pinModel];
            
        }
    }
    //    if (categorySelected!=0)
    //        filteredArray=arrForCategory;
    
    if(seachBarUsed && ![pinName isEqualToString:@""])
    {
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        for (PSPinModel * pinModell in filteredArray) {
            // NSRange range=    [pinModell.pinName  rangeOfString:pinNamee  options:NSCaseInsensitiveSearch];
            //  if( range.location != NSNotFound)
            if ([[pinModell.pinName lowercaseString] hasPrefix:[pinName lowercaseString] ])
                [arr addObject:pinModell];
            NSLog(@"array = %@", arr);
        }
        return arr;
    }
    return filteredArray;
}

#pragma mark - ToggleViewDelegate

- (void) selectLeftButton
{
    [self.pinsTableView setHidden:NO];
    self.isSnap = NO;
    [self.pinsTableView reloadData];
    
    self.pinLabel.textColor = [UIColor blackColor];
    self.snapLabel.textColor = [UIColor blackColor];
}

- (void) selectRightButton
{
    self.isSnap = YES;
    [self.pinsTableView reloadData];
    
    self.pinLabel.textColor = [UIColor blackColor];
    self.snapLabel.textColor = [UIColor blackColor];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [categoriesArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCellIdentifier forIndexPath:indexPath];
    cell.lblCategoryName.text = [[categoriesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    cell.lblCategoryName.frame = CGRectMake(0, 50, 50, 20);
    
    cell.categoryImage.frame = CGRectMake(0, 0, 130, 130);
    
    [cell.categoryImage setImage:[UIImage imageNamed:[[categoriesArray objectAtIndex:indexPath.row] objectForKey:@"image"]]];
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    return cell;
}

- (void) collectionView:(UICollectionView *) collectionView didSelectItemAtIndexPath:(NSIndexPath *) indexPath
{
    categorySelected = (int)indexPath.row + 1;
    
    if (categorySelected == 1)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Home & Personal"]];
    else if (categorySelected == 2)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Work & Office"]];
    else if (categorySelected == 3)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Food & Restaurant"]];
    else if (categorySelected == 4)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Outdoors"]];
    else if (categorySelected == 5)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"NightLife"]];
    else if (categorySelected == 6)
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Shopping"]];
    
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backFromCategories) withTarget:self];
    
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionPush];
    
    [transitionAnimation setSubtype:kCATransitionFromRight];
    
    [self.navigationController.view.layer addAnimation:transitionAnimation forKey:nil];
    
    [viewCategories removeFromSuperview];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self.pinsTableView reloadData];
}

- (void) backFromCategories
{
    categorySelected=0;
    CATransition *transitionAnimation = [CATransition animation];
    
    [transitionAnimation setType:kCATransitionPush];
    
    [transitionAnimation setSubtype:kCATransitionFromLeft];
    
    [self.navigationController.view.layer addAnimation:transitionAnimation forKey:nil];
    
    if(self.isMyPinsOnly)
    {
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Bookmarks"]];
    }
    else
    {
        [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Received"]];
    }
    
    self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"organize-icon.png" withSelectedImage:@"organize-icon.png" alignmentLeft:NO withSelecter:@selector(openPopUp) withTarget:self];
    
    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
    
    [self.pinsTableView reloadData];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(130, 130);
}

- (void)getCategoriesFromOnline {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromGetURL:kCategoriesApi parmeters:nil completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                categoriesArray = [result valueForKey:KDataKey];
                [collectionViewCategory reloadData];
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

@end


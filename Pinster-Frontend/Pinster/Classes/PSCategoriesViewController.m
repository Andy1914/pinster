//
//  PSCategoriesViewController.m
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSCategoriesViewController.h"
#import "PSCategoryCell.h"
#import "PSShareConfirmViewController.h"

static NSString *categoryCellIdentifier = @"PSCategoryCell";
@interface PSCategoriesViewController ()
{
    
}
@property (nonatomic, strong) NSMutableArray *categoriesArray;
@end

@implementation PSCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.categoriesArray = [NSMutableArray arrayWithArray:[PSUtility loadDataFromLocalJsonfile:@"Categories"]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PSCategoryCell" bundle:nil] forCellWithReuseIdentifier:categoryCellIdentifier];
    [self getCategoriesFromOnline];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.titleView = [PSUtility getHeaderLabelWithText:@"Categories"];
    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"white-close-icon.png" withSelectedImage:@"white-close-icon.png" alignmentLeft:NO withSelecter:@selector(closePressed:) withTarget:self];
    
}
- (void)closePressed:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    PSShareConfirmViewController *objShareVC = [[PSShareConfirmViewController alloc] initWithNibName:@"PSShareConfirmViewController" bundle:nil];
    objShareVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
    [self.navigationController pushViewController:objShareVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIcollectionview Delegates

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.categoriesArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryCellIdentifier forIndexPath:indexPath];
    cell.lblCategoryName.text = [[self.categoriesArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.categoryImage setImage:[UIImage imageNamed:[[self.categoriesArray objectAtIndex:indexPath.row] objectForKey:@"image"]]];
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor lightGrayColor].CGColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.pinDataDict setValue:[[self.categoriesArray objectAtIndex:indexPath.row] objectForKey:CAT_ID] forKey:PIN_CATEGORY];
    PSShareConfirmViewController *objShareVC = [[PSShareConfirmViewController alloc] initWithNibName:@"PSShareConfirmViewController" bundle:nil];
    objShareVC.pinDataDict = [NSMutableDictionary dictionaryWithDictionary:self.pinDataDict];
    [self.navigationController pushViewController:objShareVC animated:YES];
}

- (void)getCategoriesFromOnline {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromGetURL:kCategoriesApi parmeters:nil completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                self.categoriesArray = [result valueForKey:KDataKey];
                [self.collectionView reloadData];
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}
@end

//
//  PSPinDetailesViewController.m
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSPinDetailesViewController.h"
#import "PSContactPickerViewController.h"
#import "PSSnapImageViewController.h"
#import "PSMyPinsViewController.h"


static NSString* const ANNOTATION_SELECTED_DESELECTED = @"mapAnnotationSelectedOrDeselected";

@interface PSPinDetailesViewController ()
{
    IBOutlet UILabel *labelPinName;
    
    IBOutlet UIImageView *imageViewBorder;
    
    NSMutableArray *arrayUsersList;
}
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *trashButton;

- (IBAction)openSharedFriendsList:(id)sender;
- (IBAction)likeButtonCLiked:(id)sender;
- (IBAction)extraActionsClicked:(PSButton *)sender;
@property (nonatomic, strong) NSMutableArray *sharedFriendsListArray;
@property (nonatomic, strong) NSMutableArray *likedFriendsList;
@end

@implementation PSPinDetailesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = NO;
    self.title = self.pinData.pinName;
    
    NSLog(@"Pin Message = %@", self.pinData.pinMessage);
    
    if ([self.pinData.pinMessage isEqualToString:@""])
    {
        imageViewBorder.hidden = YES;
        self.lblPinMessage.frame = CGRectMake(42, 420, 215, 20);
    }
    else if (self.pinData.pinMessage == nil)
    {
        imageViewBorder.hidden = YES;
        self.lblPinMessage.frame = CGRectMake(42, 420, 215, 20);
    }
    else
    {
        labelPinName.text = self.pinData.pinMessage;
        
        imageViewBorder.hidden = NO;
    }
    self.likedFriendsList = [NSMutableArray arrayWithArray:self.pinData.pinLikedUsersList];
//    [self setValueOnFavLabel];
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if([self.likedFriendsList containsObject:[objUser valueForKey:kNameKey]]) {
        self.pinData.pinIsLiked = YES;
        [self.imgFavImage setImage:[UIImage imageNamed:@"heart-icon.png"]];
    }
    
    if (self.isBookmark) {
            self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"pin-header.png" withSelectedImage:@"pin-header.png" alignmentLeft:NO withSelecter:@selector(btnShareCLicked) withTarget:self];
        self.saveButton.hidden = YES;
        self.trashButton.hidden = NO;
    } else {
        if (_stringIsSharaeable == 1)
            self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"pin-header.png" withSelectedImage:@"pin-header.png" alignmentLeft:NO withSelecter:@selector(btnShareCLicked) withTarget:self];
        else
        self.saveButton.hidden = YES;
        self.trashButton.hidden = NO;
    }
    
    [self.sharedFriendsListTableView.layer setCornerRadius:10.0];
}

- (void)removeFromBookmarks {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.isBookmark)
    {
        NSMutableDictionary *pinDict = [NSMutableDictionary new];
        [pinDict setObject:self.pinData.pinId forKey:@"pin_id"];
        //    [pinDict setObject:self.pinData.pinId forKey:@"id"];
        //    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kBookmarkApi,kRemoveBookmark] parmeters:pinDict completionHandler:^(id result, NSString *url, NSError *error) {
        [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@",kRemoveBookmark] parmeters:pinDict completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error) {
                if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [[[result valueForKey:KDataKey] allKeys] count] >0) {
                    
                } else {
                    //                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
            }
        }];
    }
    else
    {
        NSMutableDictionary *pinDict = [NSMutableDictionary new];
        [pinDict setObject:self.pinData.receivedPinID forKey:@"id"];
        //    [pinDict setObject:self.pinData.pinId forKey:@"id"];
        //    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kBookmarkApi,kRemoveBookmark] parmeters:pinDict completionHandler:^(id result, NSString *url, NSError *error) {
        [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@",kRemoveReceivedPin] parmeters:pinDict completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error) {
                if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [[[result valueForKey:KDataKey] allKeys] count] >0) {
                    
                } else {
                    //                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
            }
        }];
    }
}

- (void)setUpPinImageView {
    self.pinImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    CGRect rect = self.pinImageView.frame;
    rect.size.height = 120;
    rect.size.width = 120;
    self.pinImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pinImageView.layer.borderWidth = 4.0;
    self.pinImageView.layer.cornerRadius = 60.0;
    self.pinImageView.layer.masksToBounds = YES;
    self.pinImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.pinImageView.layer.shadowRadius = 2.0;
    self.pinImageView.layer.shadowOpacity = 0.6;
    self.pinImageView.layer.shadowOffset = CGSizeMake(2, 2);
    
    if (self.pinData.snapImageUrl != nil && self.pinData.snapImageUrl.length > 0) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.pinData.snapImageUrl]];
        if (imageData != nil) {
            self.snapImage = [UIImage imageWithData:imageData];
        } else {
            self.snapImage = [UIImage imageNamed:@"pin-map.png"];
        }
    } else {
        self.snapImage = [UIImage imageNamed:@"pin-map.png"];
    }
    
}

- (IBAction)saveButtonTapped:(id)sender {
    if (self.isBookmark) {
        
    } else {
        
    }
}

- (IBAction)trashButtonTapped:(id)sender {
    if (self.isBookmark) {
        UIActionSheet *objActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete This", nil];
        
        objActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        [objActionSheet showInView:self.view];
    } else {
        
        UIActionSheet *objActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete This", nil];
        
        objActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        [objActionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheet Delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        NSLog(@"Delete");
        [[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to delete ?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil] show];
//        [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Are you sure you want to delete ?" onViewController:self withDelegate:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0)
    {
        [self removeFromBookmarks];
    }
}
-(void)customAlertOkButtonPressed:(PSCustomAlertView *)customAlertView
{
    [customAlertView removeFromSuperview];
    [self removeFromBookmarks];
}
- (void)setValueOnFavLabel {
    if([self.likedFriendsList count] > 2) {
        self.lblFavFriendsList.text = [NSString stringWithFormat:@"%@,%@ and %d others like this",[self.likedFriendsList objectAtIndex:0],[self.likedFriendsList objectAtIndex:1],[self.likedFriendsList count]-2];
    } else if([self.likedFriendsList count] == 2) {
        self.lblFavFriendsList.text = [NSString stringWithFormat:@"%@,%@ like this",[self.likedFriendsList objectAtIndex:0],[self.likedFriendsList objectAtIndex:1]];
    } else if([self.likedFriendsList count] == 1) {
        self.lblFavFriendsList.text = [NSString stringWithFormat:@"%@ like this",[self.likedFriendsList objectAtIndex:0]];
    } else {
        self.lblFavFriendsList.text = [NSString stringWithFormat:@"No one like this"];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setValuesOnView];
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:self.pinData.pinName]];
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self];
    self.sharedFriendsListArray = self.pinData.pinSharedUsersList;
    
//    if([self.sharedFriendsListArray count] == 0) {
//    if (_stringIsSharaeable == 1)
//        self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"pin-header.png" withSelectedImage:@"pin-header.png" alignmentLeft:NO withSelecter:@selector(btnShareCLicked) withTarget:self];
//    }
    [self.sharedFriendsListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.pinData.pinLat floatValue];
    coordinate.longitude = [self.pinData.pinLang floatValue];
    self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
    //Initialize annotation
    PSMyAnnotationClass *commuterLotAnnotation=[[PSMyAnnotationClass alloc] initWithCoordinate:coordinate];
    commuterLotAnnotation.name = @"";
    commuterLotAnnotation.description = @"";
    commuterLotAnnotation.title = @"";
    //add array of annotations to map
    [self.mapView addAnnotations:[NSArray arrayWithObjects:commuterLotAnnotation, nil]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self.sharedView addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    
}

-(void)backCLicked {
    if(self.mapView.frame.size.height < [self.mapView superview].frame.size.height) {
        
//        PSMyPinsViewController *objPSWelcom = [[PSMyPinsViewController alloc] initWithNibName:@"PSMyPinsViewController" bundle:nil];
////        [[appDelegate navigationController] popToViewController:objPSWelcom animated:NO];
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pushtoview"])
//        {
//            [[appDelegate subNavigationController] pushViewController:objPSWelcom animated:YES];
//            
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pushtoview"];
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        else
//        {
            [[appDelegate subNavigationController] popToRootViewControllerAnimated:YES];
//        }
        
//        [self.navigationController popViewControllerAnimated:YES];
//        PSMyPinsViewController *objContactVC = [[PSMyPinsViewController alloc] initWithNibName:@"PSMyPinsViewController" bundle:nil];
//        
//        [self.navigationController popToViewController:objContactVC animated:YES];
    } else {
        [self handleMapOperations];
    }
}
-(void)btnShareCLicked {
    NSMutableDictionary *pinDict = [NSMutableDictionary new];
    [pinDict setObject:self.pinData.pinId forKey:@"pin_id"];
    PSContactPickerViewController *objContactVC = [[PSContactPickerViewController alloc] initWithNibName:@"PSContactPickerViewController" bundle:nil];

    objContactVC.stringPinName = self.pinData.pinName;
    
    objContactVC.pinDataDict = pinDict;
    [self.navigationController pushViewController:objContactVC animated:YES];
    
}
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ) {
        [self handleMapOperations];
    }
}
- (void)handleMapOperations {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(self.mapView.frame.size.height < [self.mapView superview].frame.size.height) {
            [self.mapView setFrame:CGRectMake(0, 0, 320, [self.mapView superview].frame.size.height)];
        } else {
            [self.mapView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 170)];
        }
    } completion:^(BOOL finished) {
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setValuesOnView {
    self.lblPinMessage.text = self.pinData.pinMessage;
    self.lblOwner.text = self.pinData.pinOwner;
    self.lblLocation.text = self.pinData.pinLocation;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yy, hh:ss a"];
    
    
    self.lblDate.text = [formatter stringFromDate:self.pinData.pinDate];
    self.lblDate.text = [self.pinData.pinDate timeAgo];
    if(self.pinData.pinIsLiked)
        [self.imgFavImage setImage:[UIImage imageNamed:@"heart-icon.png"]];
    else
        [self.imgFavImage setImage:[UIImage imageNamed:@"heart-icon-h.png"]];
    [self setSharedButtonTitle];
    
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    dispatch_async(myQueue, ^{
        // Perform long running process
        [self setUpPinImageView];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            NSArray *annotations = self.mapView.annotations;
            [self.mapView removeAnnotations:self.mapView.annotations];
            //Re-add
            [self.mapView addAnnotations:annotations];
        });
    });
    
    [self getCategoriesFromOnline];
}

- (void)setSharedButtonTitle {
    if([self.pinData.pinSharedUsersList count] == 0) {
        [self.btnShared setHidden:YES];
//        return;
    }
    NSString *titleText = @"";
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if(![self.pinData.pinOwner isEqualToString:[objUser valueForKey:@"id"]]) {
        if([self.pinData.pinSharedUsersList count] > 1) {
//            titleText  = [NSString stringWithFormat:@"%@, was shared by %@ to you, and to among %lu other(s)",self.pinData.pinName,self.pinData.pinOwnerName,[self.pinData.pinSharedUsersList count]-1];
            titleText  = [NSString stringWithFormat:@"%@, was shared by %@",self.pinData.pinName,self.pinData.pinOwnerName,[self.pinData.pinSharedUsersList count]-1];
            
        } else if([self.pinData.pinSharedUsersList count] == 1) {
            titleText  = [NSString stringWithFormat:@"%@, was shared by %@",self.pinData.pinName,self.pinData.pinOwnerName];
        }
    } else {
        if([self.pinData.pinSharedUsersList count] > 2) {
            titleText  = [NSString stringWithFormat:@"%@ was shared with %@, %@ and %u other(s)",self.pinData.pinName,[self.pinData.pinSharedUsersList objectAtIndex:0],[self.pinData.pinSharedUsersList objectAtIndex:1],[self.pinData.pinSharedUsersList count]-2];
            
//            [self.btnShared setTitle:titleText forState:UIControlStateNormal];
        } else if([self.pinData.pinSharedUsersList count] == 2) {
            titleText = [NSString stringWithFormat:@"%@ was shared with %@, %@",self.pinData.pinName,[self.pinData.pinSharedUsersList objectAtIndex:0],[self.pinData.pinSharedUsersList objectAtIndex:1]];
//            [self.btnShared setTitle:titleText forState:UIControlStateNormal];
        } else if([self.pinData.pinSharedUsersList count] == 1) {
            titleText  = [NSString stringWithFormat:@"%@ was shared with %@",self.pinData.pinName,[self.pinData.pinSharedUsersList objectAtIndex:0]];

        }
    }
//    [self.btnShared setTitle:titleText forState:UIControlStateNormal];
    self.lblPinMessage.text = titleText;
}

- (void)singleTap {
    self.sharedView.hidden = YES;
}
- (IBAction)openSharedFriendsList:(id)sender {
    if([self.sharedFriendsListArray count] == 0) {
        [[PSUtility sharedInstance] showCustomAlertWithMessage:@"Not shared with anyone" onViewController:self withDelegate:nil];
        return;
    }
    if ([self.sharedFriendsListArray count] == 1)
    {
        
    }
    else if ([self.sharedFriendsListArray count] == 2)
    {
        
    }
    else
    {
        self.sharedView.hidden = ! self.sharedView.hidden;
        [self.sharedFriendsListTableView reloadData];
    }
    
}

- (IBAction)likeButtonCLiked:(id)sender {
    if(self.pinData.pinIsLiked) {
        [self callLikeApi:@"0"];
    } else {
        [self callLikeApi:@"1"];
    }
}

- (void)callLikeApi:(NSString *)isLiked
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPutURL:kLikePinApi parmeters:[NSDictionary dictionaryWithObjectsAndKeys:self.pinData.pinId,@"pin_id",[PSUtility getCurrentUserId],kUser_IdKey,isLiked,@"status", nil] completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
                if([PSUtility isTrue:isLiked]) {
                    self.pinData.pinIsLiked = YES;
                    [self.imgFavImage setImage:[UIImage imageNamed:@"heart-icon.png"]];
                    [self.likedFriendsList addObject:[objUser valueForKey:kNameKey]];
                } else {
                    self.pinData.pinIsLiked = NO;
                    [self.imgFavImage setImage:[UIImage imageNamed:@"heart-icon-h.png"]];
                    [self.likedFriendsList removeObject:[objUser valueForKey:kNameKey]];
                }
                [self setValueOnFavLabel];
            }
//            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

- (IBAction)extraActionsClicked:(PSButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            //Location cliked
        }
            break;
        case 102:
        {
            //Fav cliked
        }
            break;
        default:
            break;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation{
    static NSString *parkingAnnotationIdentifier=@"ParkingAnnotationIdentifier";
    
    if([annotation isKindOfClass:[PSMyAnnotationClass class]]){
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView = nil; //[mapView dequeueReusableAnnotationViewWithIdentifier:parkingAnnotationIdentifier];
        //If one isn’t available, create a new one
        if(!annotationView){
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingAnnotationIdentifier];
            //Here’s where the magic happens
            if (self.pinData.snapImageUrl == nil || self.pinData.snapImageUrl.length == 0) {
                annotationView.image=[UIImage imageNamed:@"pin-map.png"];
            } else {
                if (self.snapImage == nil) {
                    annotationView.image=[UIImage imageNamed:@"pin-map.png"];
                } else {
                    self.pinImageView.frame = CGRectMake(0, 0, 120, 120);
                    self.pinImageView.image = self.snapImage;
                    self.pinImageView.contentMode = UIViewContentModeScaleAspectFill;
                    [annotationView addSubview:self.pinImageView];
                    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnAnnotation)];
                    tapGest.numberOfTapsRequired = 1.0;
                    tapGest.numberOfTouchesRequired = 1.0;
                    [self.mapView addGestureRecognizer:tapGest];
                    annotationView.enabled = YES;
                    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                    annotationView.canShowCallout = YES;
                    annotationView.image = [UIImage new];
                }
            }
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	for (MKAnnotationView *anAnnotationView in views) {
		[anAnnotationView setCanShowCallout:YES];
		[anAnnotationView addObserver:self
                           forKeyPath:@"selected"
                              options:NSKeyValueObservingOptionNew
						      context:(__bridge void *)(ANNOTATION_SELECTED_DESELECTED)];
	}
}

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    MKPinAnnotationView *pinView = nil;
//    if(annotation!= self.mapView.userLocation)
//    {
//        static NSString *defaultPin = @"pinIdentifier";
//        pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPin];
//        if(pinView == nil)
//            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:defaultPin];
//        pinView.image=[UIImage imageNamed:@"pin-map.png"];
////        pinView.pinColor = MKPinAnnotationColorPurple; //Optional
////        pinView.canShowCallout = YES; // Optional
//        pinView.animatesDrop = YES;
//    }
//    else
//    {
//        [self.mapView.userLocation setTitle:@"You are Here!"];
//    }
//    return pinView;
//}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self handleMapOperations];
}

- (void)didTapOnAnnotation {
    if (self.snapImage != nil) {
        PSSnapImageViewController *controller = [[PSSnapImageViewController alloc] initWithNibName:@"PSSnapImageViewController" bundle:nil];
        controller.snapImage = self.snapImage;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)getCategoriesFromOnline {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromGetURL:kCategoriesApi parmeters:nil completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                NSArray *tempArray = [result valueForKey:KDataKey];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@",self.pinData.pinCategory];
                NSArray *catArray = [tempArray filteredArrayUsingPredicate:predicate];
                if([catArray count] > 0)
                    self.lblCategory.text = [[catArray objectAtIndex:0] valueForKey:@"name"];
                [self.imgCategory setImage:[UIImage imageNamed:[[[catArray objectAtIndex:0] valueForKey:@"image"] stringByReplacingOccurrencesOfString:@".png" withString:@"_small.png"]]];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sharedFriendsListArray count]-2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //    [PSMenuTableViewCell ]
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [self.sharedFriendsListArray objectAtIndex:indexPath.row+2];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Roboto-Light"  size:9.0f]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setHidden:YES];
}

@end

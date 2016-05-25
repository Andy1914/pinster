//
//  PSPinDetailesViewController.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPinModel.h"
#import "PSMyAnnotationClass.h"
@interface PSPinDetailesViewController : PSParentViewController<MKMapViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet PSButton *btnShared;
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet PSLabel *lblFavFriendsList;
@property (weak, nonatomic) IBOutlet PSLabel *lblDate;
@property (weak, nonatomic) IBOutlet PSLabel *lblLocation;
@property (weak, nonatomic) IBOutlet PSLabel *lblCategory;
@property (weak, nonatomic) IBOutlet PSLabel *lblOwner;
@property (weak, nonatomic) IBOutlet PSLabel *lblPinMessage;
@property (weak, nonatomic) IBOutlet PSView *sharedView;
@property (weak, nonatomic) IBOutlet UITableView *sharedFriendsListTableView;;
@property (assign, readwrite) BOOL isBookmark;
@property (nonatomic, strong) UIImage *snapImage;
@property (nonatomic, strong) UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgFavImage;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) PSPinModel *pinData;
@property (nonatomic, strong)NSMutableArray *categoryDetailsDict;

@property (nonatomic) int stringIsSharaeable;


@end

//
//  PSMyPinsViewController.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"
#import "ToggleView.h"

@interface PSMyPinsViewController : PSParentViewController <UITableViewDataSource,UITableViewDelegate, ToggleViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pinsTableView;
@property (weak, nonatomic) IBOutlet PSLabel *lnlNoData;
@property (nonatomic, strong) ToggleView *toggleView;
@property  (nonatomic, readwrite) BOOL isMyPinsOnly;

@end

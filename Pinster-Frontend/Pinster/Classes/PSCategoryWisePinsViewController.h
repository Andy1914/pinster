//
//  PSCategoryWisePinsViewController.h
//  Pinster
//
//  Created by Mobiledev on 01/07/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"

@interface PSCategoryWisePinsViewController : PSParentViewController
@property (weak, nonatomic) IBOutlet UITableView *pinsTableView;
@property  (nonatomic, readwrite) BOOL isMyPinsOnly;
@property (nonatomic, strong) NSMutableArray *pinsArray;
@property (nonatomic, strong) NSString *category_image;;
@end

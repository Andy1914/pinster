//
//  PSPinCategoryTableViewCell.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSPinCategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PSLabel *lblCategoryCount;
@property (weak, nonatomic) IBOutlet PSLabel *lblCategoryName;

@end

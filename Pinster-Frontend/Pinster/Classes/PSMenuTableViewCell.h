//
//  PSMenuTableViewCell.h
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet PSLabel *lblMenuTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

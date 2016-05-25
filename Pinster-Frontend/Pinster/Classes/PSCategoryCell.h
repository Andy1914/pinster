//
//  PSCategoryCell.h
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCategoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet PSLabel *lblCategoryName;


@end

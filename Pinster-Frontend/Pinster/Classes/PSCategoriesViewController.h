//
//  PSCategoriesViewController.h
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"

@interface PSCategoriesViewController : PSParentViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *pinDataDict;
@end

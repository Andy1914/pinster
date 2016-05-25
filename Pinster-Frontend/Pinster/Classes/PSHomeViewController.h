//
//  PSHomeViewController.h
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"
#import "ToggleView.h"

@interface PSHomeViewController : PSParentViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, ToggleViewDelegate> {
    BOOL isClockWise;
}
@property (nonatomic, strong) ToggleView *toggleView;
@property (nonatomic, strong) IBOutlet UIImageView *glowIcon;
@end

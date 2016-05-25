//
//  PSMyProfileViewController.h
//  Pinster
//
//  Created by Mobiledev on 22/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSMyProfileViewController : PSParentViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,weak) IBOutlet PSLabel *lblPinsTaken,*lblPinsShared;

@property(nonatomic,weak) IBOutlet PSLabel *lblSnapTaken,*lblSnapShared;


@property(nonatomic,weak) IBOutlet PSLabel *lblUserName;
@property(nonatomic,weak) IBOutlet UIImageView *imgProfilePic;

@end

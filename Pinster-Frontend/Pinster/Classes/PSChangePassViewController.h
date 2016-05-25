//
//  PSChangePassViewController.h
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSChangePassViewController : PSParentViewController{
    
}
@property (nonatomic,weak) IBOutlet PSTextField *txtOldPass,*txtNewPass,*txtConfirmPass;

-(IBAction)btnSaveClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;

@end

//
//  PSAddPinViewController.h
//  Pinster
//
//  Created by Mobiledev on 21/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSParentViewController.h"

@interface PSAddMessageViewController : PSParentViewController<UITextFieldDelegate>{

}
- (IBAction)skipSetup:(id)sender;
@property (weak, nonatomic) IBOutlet PSTextField *pinTextView;
@property (nonatomic, strong) NSMutableDictionary *pinDataDict;
@end

//
//  PSCustomAlertView.h
//  Pinster
//
//  Created by Mobiledev on 27/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PSCustomAlertView : UIView
{
    
}

@property(nonatomic, retain) NSString *message;
@property(nonatomic, assign) BOOL isDoubleButtons;
@property(nonatomic, assign) BOOL isPasscode;
@property(nonatomic, assign) NSInteger option;

-(id)initWithTitle:(NSString *)msg delegate:(id)delegate isDoubleButton:(BOOL)isDouble ofOption:(NSInteger)option;
-(id)initWithPasscodeTitle:(NSString *)msg delegate:(id)delegate isDoubleButton:(BOOL)isDouble ofOption:(NSInteger)option;
-(id)initWithMessage:(NSString *)msg andDelegate:(id)delegate;
-(id)initWithMessage:(NSString *)msg;


@end

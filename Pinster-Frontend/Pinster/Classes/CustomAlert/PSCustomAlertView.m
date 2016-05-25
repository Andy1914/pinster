//
//  PSCustomAlertView.m
//  Pinster
//
//  Created by Mobiledev on 27/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSCustomAlertView.h"

@protocol CustomAlertDelegate <NSObject>

@optional

-(void)customAlertOkButtonPressed:(PSCustomAlertView *)customAlertView;
-(void)customAlertYesButtonPressed:(PSCustomAlertView *)customAlertView;
-(void)customAlertNoButtonPressed:(PSCustomAlertView *)customAlertView;

@end

@interface PSCustomAlertView()

@property(nonatomic, retain) id<CustomAlertDelegate> customDelegate;

@end

@implementation PSCustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        
    }
    return self;
}


-(id)initWithMessage:(NSString *)msg
{
    self=[super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        [self setMessage:msg];
        [self setIsDoubleButtons:NO];
        [self setIsPasscode:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(id)initWithMessage:(NSString *)msg andDelegate:(id)delegate
{
    self=[super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        [self setMessage:msg];
        [self setCustomDelegate:delegate];
        [self setIsDoubleButtons:NO];
        [self setIsPasscode:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(id)initWithTitle:(NSString *)msg delegate:(id)delegate isDoubleButton:(BOOL)isDouble ofOption:(NSInteger)option
{
    self=[super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        [self setMessage:msg];
        [self setCustomDelegate:delegate];
        [self setIsDoubleButtons:isDouble];
        [self setOption:option];
        [self setIsPasscode:NO];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(id)initWithPasscodeTitle:(NSString *)msg delegate:(id)delegate isDoubleButton:(BOOL)isDouble ofOption:(NSInteger)option
{
    self=[super initWithFrame:[[UIScreen mainScreen] bounds]];
    if(self)
    {
        [self setMessage:msg];
        [self setCustomDelegate:delegate];
        [self setIsDoubleButtons:isDouble];
        [self setOption:option];
        [self setIsPasscode:YES];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}



#pragma Mark - Instance Methods

-(void)layoutSubviews
{
//    UIImageView *imageViewBackground=[[UIImageView alloc]initWithFrame:self.frame];
//    [imageViewBackground setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
//    [imageViewBackground setImage:[UIImage imageNamed:[AppDelegate getImageName:@"backgroun_3"]]];
//    [self addSubview:imageViewBackground];
    UIImageView *bgImage=[[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [bgImage setBackgroundColor:[UIColor blackColor]];
    [bgImage setAlpha:0.6];
    [self addSubview:bgImage];
    
    UIImage *popupImage = [UIImage imageNamed:@"enter-passcode-popup-recheck-bg.png"];
    UIImageView *popupImageView=[[UIImageView alloc] initWithImage:popupImage];
    [popupImageView setFrame:CGRectMake(0, 0, 290, 125)];
    popupImageView.autoresizingMask=UIViewAutoresizingNone;
    [popupImageView setUserInteractionEnabled:YES];
    [self addSubview:popupImageView];
    [popupImageView setCenter:self.center];//IMPORTANT
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake((popupImageView.frame.size.width-250)/2, 15, 250, 70)];//250 Text width
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setText: self.message];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    titleLabel.autoresizingMask=UIViewAutoresizingNone;
    [popupImageView addSubview:titleLabel];
    
    if(!self.isDoubleButtons)
    {
        UIImage *okImage=[UIImage imageNamed:@"btn-ok.png"];
        UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [okButton setFrame:CGRectMake(0, 125-45, 290, 45)];
        [okButton setImage:okImage forState:UIControlStateNormal];
        [okButton setImage:okImage forState:UIControlStateHighlighted];
        [okButton setImage:okImage forState:UIControlStateSelected];
        //[okButton setTitle:@"OK" forState:UIControlStateNormal];
        [okButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        [okButton.titleLabel setTextColor:[UIColor whiteColor]];
        [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [popupImageView addSubview:okButton];
    }
    else
    {
        if(self.option>0)
        {
            UIImage *imgOk=[UIImage imageNamed:@"btn-yes.png"];
            UIImage *imgCancel=[UIImage imageNamed:@"btn-no.png"];
            CGRect buttonFrame = CGRectMake(0, 125-45, 290/2, 45);
            UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [okButton setFrame:buttonFrame];
            [okButton setImage:imgOk forState:UIControlStateNormal];
            //[okButton setTitle:@"YES" forState:UIControlStateNormal];
            [okButton.titleLabel setTextColor:[UIColor whiteColor]];
            [okButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            [okButton addTarget:self action:@selector(yesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [popupImageView addSubview:okButton];
            
            UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];//149
            [cancelButton setFrame:CGRectMake(290/2, 125-45, 290/2, 45)];
            [cancelButton setImage:imgCancel forState:UIControlStateNormal];
            //[cancelButton setTitle:@"NO" forState:UIControlStateNormal];
            [cancelButton.titleLabel setTextColor:[UIColor blackColor]];
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            [cancelButton addTarget:self action:@selector(noButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [popupImageView addSubview:cancelButton];
        }
        else
        {
            UIImage *imgOk=[UIImage imageNamed:@"btn-yes.png"];
            UIImage *imgCancel=[UIImage imageNamed:@"btn-no.png"];
            CGRect buttonFrame = CGRectMake(0, 125-45, 290/2, 45);
            
            UIButton *okButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [okButton setFrame:buttonFrame];
            [okButton setImage:imgOk forState:UIControlStateNormal];
            //[okButton setTitle:@"OK" forState:UIControlStateNormal];
            [okButton.titleLabel setTextColor:[UIColor whiteColor]];
            [okButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            [okButton addTarget:self action:@selector(yesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [popupImageView addSubview:okButton];
            
            UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];//149
            [cancelButton setFrame:CGRectMake(290/2, 125-45, 290/2, 45)];
            [cancelButton setImage:imgCancel forState:UIControlStateNormal];
            //[cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
            [cancelButton.titleLabel setTextColor:[UIColor blackColor]];
            [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
            [cancelButton addTarget:self action:@selector(noButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [popupImageView addSubview:cancelButton];
        }
    }
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.transform = CGAffineTransformIdentity;
        
    }];
}

-(void)okButtonPressed
{
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        
    } completion:^(BOOL finished) {
        if(self.customDelegate && [self.customDelegate respondsToSelector:@selector(customAlertOkButtonPressed:)])
            [self.customDelegate customAlertOkButtonPressed:self];
        else{
            [self removeFromSuperview];
        }
    }];
}

-(void)yesButtonPressed
{
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } completion:^(BOOL finished) {
        if(self.customDelegate && [self.customDelegate respondsToSelector:@selector(customAlertYesButtonPressed:)])
            [self.customDelegate customAlertYesButtonPressed:self];
        else {
            [self removeFromSuperview];
        }
    }];
    
}

-(void)noButtonPressed
{
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
        
    } completion:^(BOOL finished) {
        if(self.customDelegate && [self.customDelegate respondsToSelector:@selector(customAlertNoButtonPressed:)])
            [self.customDelegate customAlertNoButtonPressed:self];
        else{
            [self removeFromSuperview];
        }
    }];
}


@end

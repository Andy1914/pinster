//
//  UIDateTimePicker.m
//  pickerTest
//
//  Created by HiddenBrains on 20/09/11.
//  Copyright 2011 HiddenBrains. All rights reserved.
//

#import "UIDateTimePicker.h"


#define intrval 5

@implementation UIDateTimePicker
@synthesize delegate;

-(void)initWithDatePicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect  pickerMode:(UIDatePickerMode)datePickerMode dateFormat:(NSString*)dateFormat minimumDate:(NSDate*)minimumDate maxDate:(NSDate*)maxDate setCurrentDate:(NSDate*)setCurrentDate Recevier:(id)Receiver barStyle:(UIBarStyle)barStyle toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor
{
    
	formatString=[[NSString alloc] initWithString:dateFormat];
	senders=Receiver;
	if ([senders isKindOfClass:[UILabel class]])
	{
		tempLable=(UILabel *)senders;
		//pickerDate=[[NSString alloc] initWithFormat:@"%@",tempLable.text];
		pickerDate=tempLable.text ;
	}
	else if ([senders isKindOfClass:[UITextField class]])
	{
		tempText=(UITextField *)senders;
		pickerDate=tempText.text;
		//pickerDate=[[NSString alloc] initWithFormat:@"%@",tempText.text];
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		pickerDate=button_Temp.titleLabel.text ;
	}
    
    CGRect ToolRect;
    actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    actionSheet.backgroundColor=[UIColor clearColor];
    if ([AddView isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabbarController=(UITabBarController*)AddView;
        [actionSheet showInView:tabbarController.tabBar];
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
            [actionSheet setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,260)];
            ToolRect=CGRectMake(rect.origin.x,0,rect.size.width, 44);
        }
        else
        {
            [actionSheet setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,350)];
            ToolRect=CGRectMake(rect.origin.x,0,rect.size.width, 32);
        }
    }
    else
    {
//        ToolRect=CGRectMake(rect.origin.x,0,rect.size.width, 44);
//        [actionSheet showInView:AddView];
//        if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
//        {
//            [actionSheet setFrame:CGRectMake(0,160,320,260)];
//
//        }else
//        {
//            [actionSheet setFrame:CGRectMake(0,80,[UIScreen mainScreen].bounds.size.height,160)];
//        }
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
        {
            ToolRect=CGRectMake(rect.origin.x,0,320, 44);
            [actionSheet showInView:AddView];
            if(isAboveIOS6)
                [actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-236, 320,240)];
            else
                [actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-256, 320,240)];
        }else
        {
            ToolRect=CGRectMake(rect.origin.x,0,[AddView frame].size.width, 32);
            [actionSheet showInView:AddView];
            [actionSheet setFrame:CGRectMake(rect.origin.x, [AddView frame].size.height-190, [AddView frame].size.width,160)];
        }
    }
    [actionSheet addSubview:[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor]];
    [actionSheet addSubview:[self createDatePicker:minimumDate maxDate:maxDate datePickerMode:datePickerMode setCurrentDate:setCurrentDate frame:CGRectMake(pickerRect.origin.x, ToolRect.size.height, pickerRect.size.width,pickerRect.size.height) dateFormat:dateFormat]];
}

-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor
{
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        rect=CGRectMake(0, 0, 320, 44);
    }else
    {
        rect=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, 32);
    }
    UIToolbar *pickerToolbar=[[UIToolbar alloc] initWithFrame:rect];
	pickerToolbar.barStyle = BarStyle;
    pickerToolbar.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:214/255.0 alpha:1.0];
	pickerToolbar.opaque=YES;
	pickerToolbar.translucent=NO;
	[pickerToolbar setItems:[self toolbarItem] animated:YES];
	if ([toolBarTitle length]!=0)
	{
		[pickerToolbar addSubview:[self createTitleLabel:toolBarTitle labelTextColor:textColor width:(rect.size.width-150)]];
	}
	return pickerToolbar;
}

-(UIDatePicker*)createDatePicker:(NSDate*)minDate maxDate:(NSDate*)maxDate datePickerMode:(UIDatePickerMode)datePickerMode setCurrentDate:(NSDate*)setCurrentDate frame:(CGRect)rect dateFormat:(NSString *)dateFormat
{
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        rect=CGRectMake(0, 44, 320, 216);
    }else
    {
        rect=CGRectMake(0, 32, [UIScreen mainScreen].bounds.size.height, 152);
    }
    
	NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init] ;
	[_dateFormatter setDateFormat:dateFormat];
    datePicker=[[UIDatePicker alloc] initWithFrame:rect];
	datePicker.datePickerMode = datePickerMode;
	[datePicker setMinuteInterval:intrval];
	[datePicker setMinimumDate:minDate];
	if ([_dateFormatter dateFromString:pickerDate])
	{
		[datePicker setDate:[_dateFormatter dateFromString:pickerDate]];
	}
	else
    {
		[datePicker setDate:setCurrentDate];
	}
	[datePicker setMaximumDate:maxDate];
	[datePicker addTarget:self action:@selector(Result) forControlEvents:UIControlEventValueChanged];
	return datePicker;
}

-(void)Result
{
	dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",formatString]];
	pickerValue= [dateFormatter stringFromDate:[datePicker date]];
	dateFormatter=nil;
	[self callSenders:pickerValue];
}

-(IBAction)done_clicked:(id)sender
{
	dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:[NSString stringWithFormat:@"%@",formatString]];
	pickerValue= [dateFormatter stringFromDate:[datePicker date]];
	dateFormatter=nil;
    if([(NSObject *)delegate respondsToSelector:@selector(adjustScrolling)])
    {
        	[delegate adjustScrolling];
    }

	[self callSenders:pickerValue];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[popoverController dismissPopoverAnimated:YES];
	}
	else
	{
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
    if(delegate && [(NSObject *)delegate respondsToSelector:@selector(DateTimePickerDoneClicked)])
        [delegate DateTimePickerDoneClicked];
}

-(UILabel*)createTitleLabel:(NSString*)labelTitle labelTextColor:(UIColor*)color width:(NSInteger)width
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		lWidth=4;
		lheight=36;
	}
	else
	{
		if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation==UIInterfaceOrientationPortraitUpsideDown)
		{
			lheight=36;
			lWidth=4;
		}
		else
		{
			lWidth=2;
			lheight=28;
		}
	}
	UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(70,lWidth,width,lheight)];
	label.textColor=color;
	label.backgroundColor=[UIColor clearColor];
//	label.font = [CavelogGlobals font15];
	label.text=labelTitle;
	label.adjustsFontSizeToFitWidth=YES;
	label.font=[UIFont boldSystemFontOfSize:15];
	label.textAlignment=NSTextAlignmentCenter;
	return label ;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self callSenders:pickerDate];
}

-(void)callSenders:(NSString*)pickerString
{
	if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
		tempLable.text=pickerString;
		//senders=(UILabel*)senders;
	}
	else if ([senders isKindOfClass:[UITextField class]])
    {
		tempText=(UITextField *)senders;
		tempText.text=pickerString;
		//senders=(UITextField*)senders;
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		[button_Temp setTitle:pickerString forState:UIControlStateNormal];
		//senders = (UIButton *)senders;
	}
    if([(NSObject *)delegate respondsToSelector:@selector(DateTimePickerValue:)])
    {
        [delegate DateTimePickerValue:senders];
    }
}

-(IBAction)cancel_clicked:(id)sender
{
    if([(NSObject *)delegate respondsToSelector:@selector(adjustScrolling)])
    {
        [delegate adjustScrolling];
    }
	[self callSenders:pickerDate];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		[popoverController dismissPopoverAnimated:YES];
	}
    else
    {
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
    if(delegate && [(NSObject *)delegate respondsToSelector:@selector(DateTimePickerCancelClicked)])
        [delegate DateTimePickerCancelClicked];
}

-(NSMutableArray*)toolbarItem
{
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel_clicked:)];
	[barItems addObject:cancelBtn];
	
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[barItems addObject:flexSpace];
	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done_clicked:)];
	[barItems addObject:doneBtn];
	return barItems ;
}

@end

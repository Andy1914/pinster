//
//  UIDateTimePicker.h
//  pickerTest
//
//  Created by HB17 on 20/09/11.
//  Copyright 2011 HiddenBrains. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomDateTimePickerDelegate
@optional
-(void)DateTimePickerValue:(id)retval;
-(void)DateTimePickerDoneClicked;
-(void)DateTimePickerCancelClicked;
-(void)adjustScrolling;

@end


@interface UIDateTimePicker : UIViewController<UIPopoverControllerDelegate,UIActionSheetDelegate> {
	UIDatePicker *datePicker;
	NSString *formatString;
	NSDateFormatter *dateFormatter;
	UIPopoverController *popoverController;
	UIActionSheet *actionSheet;
	id senders;	
	NSString *pickerValue;
	UILabel *tempLable;
	UITextField *tempText;
	UIButton *button_Temp;
	NSString *pickerDate;
	int lWidth,lheight;
	id<CustomDateTimePickerDelegate>delegate;
}
@property(nonatomic,strong)id<CustomDateTimePickerDelegate>delegate;

-(void)initWithDatePicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect  pickerMode:(UIDatePickerMode)datePickerMode dateFormat:(NSString*)dateFormat minimumDate:(NSDate*)minimumDate maxDate:(NSDate*)maxDate setCurrentDate:(NSDate*)setCurrentDate Recevier:(id)Receiver barStyle:(UIBarStyle)barStyle toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor;

-(void)callSenders:(NSString*)pickerString;
-(UILabel*)createTitleLabel:(NSString*)labelTitle labelTextColor:(UIColor*)color width:(NSInteger)width;
-(UIDatePicker*)createDatePicker:(NSDate*)minDate maxDate:(NSDate*)maxDate datePickerMode:(UIDatePickerMode)datePickerMode setCurrentDate:(NSDate*)setCurrentDate frame:(CGRect)rect dateFormat:(NSString *)dateFormat;
-(NSMutableArray*)toolbarItem;
-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor;
@end

//
//  UICustomPicker.h


#import <UIKit/UIKit.h>
@class UICustomPicker;

@protocol CustomPickerDelegate
@optional
-(void)CustomPickerValue:(id)retval;
-(void)adjustScrolling;
-(void)pickerDoneClicked:(NSString*)doneValue;
-(void)pickerDoneClicked:(NSString*)doneValue  andSelectedInde:(int)index;
-(void)pickerCancelClicked:(NSString*)doneValue;

-(void)picker:(UICustomPicker *)picker andDoneClicked:(NSString*)doneValue  andSelectedInde:(int)index;




@end

@interface UICustomPicker : UIViewController <UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate>
{
	UIPickerView *pickerView;
	UIPopoverController *popoverController;
	id senders;	
	NSString *preValue;
	UILabel *tempLable;
	UITextField *tempText;
	UIButton *button_Temp;
	NSString *pickerValue;
	NSDictionary *pickerDict;
	NSMutableArray *keyArray;
	UIActionSheet *actionSheet;
	int lWidth,lheight;
	id<CustomPickerDelegate>delegate;
     
 }

@property(nonatomic,strong)id<CustomPickerDelegate>delegate;
@property(nonatomic,strong) NSString *pickerMode;

-(void)callSenders:(NSString*)pickerString;
-(NSMutableArray*)toolbarItem;
-(UIPickerView*)createPicker:(CGRect)rect;
-(UILabel*)createTitleLabel:(NSString*)labelTitle labelTextColor:(UIColor*)color width:(NSInteger)width;
-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray  toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort;

-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor;

@end
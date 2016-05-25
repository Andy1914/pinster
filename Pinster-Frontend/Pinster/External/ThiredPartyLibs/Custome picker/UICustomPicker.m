    //
//  UICustomPicker.m
//  pickerTest

#import "UICustomPicker.h"

#define Separator @"--------------------"

@interface UICustomPicker()

@end


@implementation UICustomPicker

@synthesize delegate;

-(void)initWithCustomPicker:(CGRect)rect inView:(id)AddView ContentSize:(CGSize)ContentSize pickerSize:(CGRect)pickerRect barStyle:(UIBarStyle)barStyle Recevier:(id)Receiver componentArray:(NSMutableArray *)componentArray  toolBartitle:(NSString*)toolBartitle textColor:(UIColor*)textColor needToSort:(BOOL)needToSort
{
    if (![componentArray count]) 
    {
//        [[JAlertView Alert_FailedMessage:nil message:@"No data found!"] show];
        return;
    }
    
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
    
    }else
    {
        pickerRect=CGRectMake(0, 100, [AddView frame].size.width, 152);
    }
	senders=Receiver;
	pickerValue=@"";
    self.pickerMode = toolBartitle;
	if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
        preValue=[[NSString alloc] initWithFormat:@"%@",tempLable.text];
	}
	else if ([senders isKindOfClass:[UITextField class]])
    {
		tempText=(UITextField*)senders;
		preValue=[[NSString alloc] initWithFormat:@"%@",tempText.text];
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		preValue=button_Temp.titleLabel.text ;
	}
    if (needToSort)
    {
        keyArray = [[NSMutableArray alloc] initWithArray:[componentArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    }
    else
    {
        keyArray = [[NSMutableArray alloc] initWithArray:[componentArray mutableCopy]];
    }
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		UIView *popoverView = [[UIView alloc] init];
		CGRect ToolRect=CGRectMake(0, 0,pickerRect.size.width, 44);
		popoverView.backgroundColor = [UIColor blackColor];
		UIViewController* popoverContent = [[UIViewController alloc] init];	
		[popoverView addSubview:[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor]];	
		[popoverView addSubview:[self createPicker:CGRectMake(0, 44, pickerRect.size.width,pickerRect.size.height)]];
		popoverContent.view = popoverView;
	
		popoverView=nil;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate=self;
		
		popoverContent=nil;
		[popoverController setPopoverContentSize:ContentSize animated:NO];
		[popoverController presentPopoverFromRect:rect inView:AddView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else
    {
		CGRect ToolRect;
		actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
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
				[actionSheet setFrame:CGRectMake(rect.origin.x, 110, 480,160)];
				ToolRect=CGRectMake(rect.origin.x,0,rect.size.width, 32);
			}
 		}
        else
        {
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

//                if ([UIScreen mainScreen].bounds.size.height == 480)
//                {
//                    [actionSheet setFrame:CGRectMake(rect.origin.x, 80, 480,160)];
//                }
//                else
//                {
//                    [actionSheet setFrame:CGRectMake(rect.origin.x,244,rect.size.width,rect.size.height)];
//                }
            }
			
		}
		actionSheet.backgroundColor=[UIColor clearColor];
		[actionSheet addSubview:[self createToolBar:ToolRect BarStyle:barStyle toolBarTitle:toolBartitle textColor:textColor]];
		[actionSheet addSubview:[self createPicker:CGRectMake(pickerRect.origin.x, ToolRect.size.height, pickerRect.size.width,pickerRect.size.height)]];
	}
}

-(UIPickerView*)createPicker:(CGRect)rect
{
	pickerView=[[UIPickerView alloc] initWithFrame:rect];
	pickerView.delegate  = self;
	pickerView.dataSource = self;
	int x=0;
	pickerView.showsSelectionIndicator = YES;
	if ([preValue length] > 0)
	{
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            if ([keyArray  containsObject:preValue])
                x=[keyArray  indexOfObject:preValue];
            [pickerView selectRow:x inComponent:0 animated:YES];
        }
	}
	return pickerView;
}          

-(UIToolbar*)createToolBar:(CGRect)rect BarStyle:(UIBarStyle)BarStyle toolBarTitle:(NSString*)toolBarTitle textColor:(UIColor*)textColor
{
	UIToolbar *Toolbar=[[UIToolbar alloc] initWithFrame:rect];
	Toolbar.barStyle = BarStyle;
    Toolbar.tintColor = [UIColor colorWithRed:60/255.0 green:165/255.0 blue:214/255.0 alpha:1.0];
	Toolbar.opaque=YES;
	Toolbar.translucent=NO;
	[Toolbar setItems:[self toolbarItem] animated:YES];
	if ([toolBarTitle length]!=0)
    {
		[Toolbar addSubview:[self createTitleLabel:toolBarTitle labelTextColor:[UIColor blackColor] width:(rect.size.width-150)]];
	}
	return Toolbar ;
}

#pragma mark - UIPickerView delegate methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{	
	if ([keyArray count] > 0)
	{
		if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
		{
			return [keyArray count];
		}
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ([keyArray count] > 0)
	{
		if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
		{
			return [keyArray objectAtIndex:row];
		}
	}
	return @"";
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView1 viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [pickerView1 rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    lbl.text = [NSString stringWithFormat:@"  %@",[keyArray objectAtIndex:row]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    lbl.adjustsFontSizeToFitWidth = YES;
    lbl.textAlignment=NSTextAlignmentLeft;
//    lbl.font=[CavelogGlobals font15];
    return lbl;
}


-(void) pickerView:(UIPickerView *)pickerVies didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSString  *pickerLocalValue=@"";
    if ([pickerView numberOfComponents]>1)
    {
        for(int i=0;i<[pickerView numberOfComponents];i++)
        {
            if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
            }
        }
    }
    else {
        if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
            pickerLocalValue=[pickerLocalValue stringByAppendingFormat:@"%@",[keyArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
        }
    }
	pickerValue = pickerLocalValue;
	[self callSenders:pickerValue];
}

-(IBAction)done_clicked:(id)sender
{
    if ([pickerValue length] == 0)
    {
        if ([keyArray count] > 0)
        {
            if ([[keyArray objectAtIndex:0] isKindOfClass:[NSString class]])
            {
                pickerValue = [keyArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            }
        }  
    }
    

    if([(NSObject *)delegate respondsToSelector:@selector(picker:andDoneClicked:andSelectedInde:)])
    {
        [delegate picker:self andDoneClicked:pickerValue andSelectedInde:[pickerView selectedRowInComponent:0]] ;
    }

    if([(NSObject *)delegate respondsToSelector:@selector(pickerDoneClicked:)])
    {
        [delegate pickerDoneClicked:pickerValue];
    }
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
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	[self callSenders:preValue];
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
	label.textColor = color;
	label.backgroundColor=[UIColor clearColor];
//	label.font = [CavelogGlobals font15];
	label.text = labelTitle;
    [label setTextAlignment:NSTextAlignmentCenter];
	return label ;
}

-(void)callSenders:(NSString*)pickerString
{
    if ([senders isKindOfClass:[UILabel class]])
    {
		tempLable=(UILabel *)senders;
		tempLable.text=pickerString;
	}
	else if ([senders isKindOfClass:[UITextField class]]){
		tempText=(UITextField *)senders;
		tempText.text=pickerString;
	}
	else if ([senders isKindOfClass:[UIButton class]])
	{
		button_Temp = (UIButton *)senders;
		[button_Temp setTitle:pickerString forState:UIControlStateNormal];
	}
    if([(NSObject *)delegate respondsToSelector:@selector(CustomPickerValue:)])
    {
        [delegate CustomPickerValue:senders];
    }
}

-(IBAction)cancel_clicked:(id)sender
{
	[self callSenders:preValue];
    if([(NSObject *)delegate respondsToSelector:@selector(adjustScrolling)])
    {
        [delegate adjustScrolling];
    }
    if ([(NSObject *)self.delegate respondsToSelector:@selector(pickerCancelClicked:)])
    {
        [self.delegate pickerCancelClicked:preValue];
    }

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
		[popoverController dismissPopoverAnimated:YES];
	}
    else
    {
		[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	}
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

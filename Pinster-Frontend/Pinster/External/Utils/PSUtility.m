    //
//  PSUtility.m
//  Pinster
//
//  Created by MobileDev on 24/05/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSUtility.h"
#import "PSCustomAlertView.h"


@implementation PSUtility
+(PSUtility *)sharedInstance {
    static PSUtility *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] init];
    });
    return _sharedClient;
}
+ (void)setDefaultFontOnView:(id)view {
    if([view isKindOfClass:[PSButton class]]|| [view isKindOfClass:[UIButton class]]) {
        PSButton *btn = (PSButton *)view;
        [btn.titleLabel setFont:[UIFont fontWithName:PS_DEFAULT_FONT size:btn.titleLabel.font.pointSize]];
    } else if([view respondsToSelector:@selector(setFont:)]) {
        PSLabel *tempView = (PSLabel *)view;
        [tempView setFont:[UIFont fontWithName:PS_DEFAULT_FONT size:tempView.font.pointSize]];
    }
}

+ (void)setCornerRadiousToView:(id)view WithCornerRadious:(CGFloat)radious {
    PSView *tempView = (PSView *)view;
    tempView.layer.cornerRadius = 10.0f;
    [tempView.layer setMasksToBounds:YES];
}

+ (NSArray *)loadDataFromLocalJsonfile:(NSString *)fileName {
    NSError *deserializingError;
    NSString *pathStringToLocalFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSURL *localFileURL = [NSURL fileURLWithPath:pathStringToLocalFile];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    NSArray *arrayOfData = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&deserializingError];
    return arrayOfData;
}

+ (BOOL)isTrue:(id)value {
     if([value isKindOfClass:[NSNull class]]) {
        return NO;
    } else if(![value isKindOfClass:[NSString class]]) {
        return (BOOL)value;
    } else if([value isKindOfClass:[NSString class]]){
        if([[value uppercaseString] isEqualToString:@"YES"] || [[value uppercaseString] isEqualToString:@"TRUE"] || [[value uppercaseString] isEqualToString:@"1"]) {
            return YES;
        }
    }
    return NO;
    
}
+ (void)showAlert:(NSString *)title withMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

+ (void)saveSessionValue:(id)value withKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getValueFromSession:(NSString *)key {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:key] isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Response %@", [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:key]]);
        
        return [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:key]];
    }
   return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)removeValueFromSessionWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
+ (id)getViewControllerWithName:(NSString *)nibName {
    UINib *nib = [UINib nibWithNibName:[NSString stringWithFormat:@"%@",nibName] bundle:[NSBundle mainBundle]];
    if(!IS_IPHONE5 && nib) {
       return [[NSClassFromString(nibName) alloc] initWithNibName:[NSString stringWithFormat:@"%@",nibName] bundle:nil];
    }
    return [[NSClassFromString(nibName) alloc] initWithNibName:nibName bundle:nil];
}
//+ (id)getViewControllerWithName:(NSString *)nibName withIphone4:(BOOL)value {
//    if(value)
//        return [[NSClassFromString(nibName) alloc] initWithNibName:[NSString stringWithFormat:@"%@3.5",nibName] bundle:nil];
//    else
//        return [[NSClassFromString(nibName) alloc] initWithNibName:nibName bundle:nil];
//}

#pragma mark -
#pragma mark Validations

+ (BOOL) isValidData : (NSString*) activeValue
{
	BOOL isValid = NO;
	if (activeValue == nil || [[activeValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
	{
		isValid = NO;
	}
	else
	{
		isValid = YES;
	}
	return isValid;
}
+(BOOL)validateTitleFirstChar:(NSString*)enterdName
{
    NSString * const regularExpression = @"^([a-z][A-Z]{1})";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        dLog(@"error %@", error);
    }
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:enterdName options:0 range:NSMakeRange(0, [enterdName length])];
    return numberOfMatches > 0;
}

+ (BOOL) validatePasswordLength : (NSString*) PasswordValue
{
	BOOL isValid = FALSE;
	if ([PSUtility isValidData:PasswordValue])
	{
        if ( [PasswordValue length]<8 ||[PasswordValue length]>32 ) return NO;  // too long or too short
        NSRange rang;
        rang = [PasswordValue rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
        if ( !rang.length ) return NO;  // no letter
        rang = [PasswordValue rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
        if ( !rang.length )  return NO;  // no number;
        return YES;
	}
	else
	{
		isValid = FALSE;
	}
	return isValid;
}

+ (BOOL) comparePasswords:(NSString*) password confirmPassword:(NSString*)confirmPassword
{
	return [password isEqualToString:confirmPassword];
}

+ (BOOL) validateEmail: (NSString *) myEmail
{
	BOOL isValid = FALSE;
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if (![emailTest evaluateWithObject:myEmail])
    {
        isValid = FALSE;
    }
    else
    {
        isValid = TRUE;
    }
	return isValid;
}
+ (void)setBorderSettings:(id)view {
    PSView *tempView = (PSView *)view;
    [tempView.layer setBorderColor:tempView.psBorderColor.CGColor];
    [tempView.layer setBorderWidth:[tempView.psBorderWidth floatValue]];
    [tempView.layer setCornerRadius:[tempView.psCornerRadious floatValue]];
     tempView.clipsToBounds = YES;
}

+ (UIColor *)appDefaultColor {
    return [UIColor colorWithRed:161.0/255.0 green:53.0/255.0 blue:0.0 alpha:1.0];
}

+ (NSDate *)getDateFromString:(NSString *)dateString withFormate:(NSString *)dateFormate {
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
//    [dateFormat setTimeZone:[NSTimeZone defaultTimeZone]];
//    [dateFormat setDateFormat:dateFormate];
//    
//    NSDate *localDate = [dateFormat dateFromString:dateString];
//    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
//    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
//    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:dateFormate];
    NSDate *date = [dateFormat1 dateFromString:dateString];
    
    return  date;
}


+ (UIBarButtonItem *)getBackBarButtonWithSelecter:(SEL)selecter withTarget:(id)target{
    
    PSButton *barButton = [[PSButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [barButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [barButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [barButton addTarget:target action:selecter forControlEvents:UIControlEventTouchUpInside];
    [barButton setImageEdgeInsets:UIEdgeInsetsMake(7, -7, 7, 21)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

+ (void)showProgressHUDWithText:(NSString *)text onView:(id)vc{
    UIViewController *vcObj = (UIViewController *)vc;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:vcObj.view animated:YES];
    if(!text) {
       hud.labelText = @"Please Wait";
    } else {
        hud.labelText = text;
    }
    [hud hide:YES afterDelay:60.0];
}

+ (void)hideProgressHUDFromVC:(id)vc {
    UIViewController *vcObj = (UIViewController *)vc;
    [MBProgressHUD hideHUDForView:vcObj.view animated:YES];
}

+(BOOL)isValidURL:(NSString *)urlStr
{
    BOOL isValidURL = NO;
    NSURL *candidateURL = [NSURL URLWithString:urlStr];
    if (candidateURL && candidateURL.scheme && candidateURL.host)
        isValidURL = YES;
    return isValidURL;
}

+ (PSLabel *)getHeaderLabelWithText:(NSString *)text{
    PSLabel *label = [[PSLabel alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [label setText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setFont:[UIFont fontWithName:@"Cochin" size:20.0]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
    [label setTextColor:[UIColor whiteColor]];
    return label;
}

+ (UIBarButtonItem *)getBarButtonWithNormalImage:(NSString *)nImage withSelectedImage:(NSString *)sImage  alignmentLeft:(BOOL)value withSelecter:(SEL)selecter withTarget:(id)target{
    UIImage *image = [UIImage imageNamed:nImage];
    PSButton *button = [[PSButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width/2, image.size.height/2)];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button setImage:[UIImage imageNamed:nImage] forState:UIControlStateNormal];
    if(sImage != nil) {
        [button setImage:[UIImage imageNamed:sImage] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:sImage] forState:UIControlStateSelected];
    }
    if(value) {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    } else {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    [button addTarget:target action:selecter forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButton;
}

+ (UIBarButtonItem *)getBarButtonWithTitle:(NSString *)title alignmentLeft:(BOOL)value withSelecter:(SEL)selecter withTarget:(id)target{
    PSButton *button = [[PSButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [[button titleLabel] setText:title];
    if(value) {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [[button titleLabel] setTextAlignment:NSTextAlignmentLeft];
    } else {
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [[button titleLabel] setTextAlignment:NSTextAlignmentRight];
    }
    [[button titleLabel] setFont:[UIFont fontWithName:@"airal" size:13.0]];
    [[button titleLabel] setTextColor:[UIColor whiteColor]];
    [button addTarget:target action:selecter forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButton;
}

+ (id)checkNil:(id)value {
    if([value isKindOfClass:[NSNull class]] || value == nil) {
        return @"";
    }
    return value;
}

- (void)showCustomAlertWithMessage:(NSString *)message onViewController:(PSParentViewController *)viewController withDelegate:(id)delegate {
    PSCustomAlertView *customAlert = [[PSCustomAlertView alloc] initWithMessage:message andDelegate:delegate];
    [[[UIApplication sharedApplication] keyWindow] addSubview:customAlert];
}

+ (NSString *)getCurrentUserId {
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if(objUser != nil) {
        return [objUser valueForKey:kUserIdKey];
    }
    return nil;
}
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize {
    CGSize actSize = image.size;
    float scale = actSize.width/actSize.height;
    
    if (scale < 1) {
        newSize.height = newSize.width/scale;
    } else {
        newSize.width = newSize.height*scale;
    }
    
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)getCategoryImageWithId:(NSString *)catId isSmall:(BOOL)value {
    NSString *imgName= @"";
    switch ([catId intValue]) {
        case 1:
            imgName = @"home-pers-icon";
            break;
        case 2:
            imgName = @"work-office-icon";
            break;
        case 3:
            imgName = @"food-restu-icon";
            break;
        case 4:
            imgName = @"outdoors-icon";
            break;
        case 5:
            imgName = @"night-life-icon";
            break;
        case 6:
            imgName = @"shopping-icon";
            break;
        default:
            break;
    }
    if(value) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@_small.png",imgName]];
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imgName]];
}
@end

//
//  PSUtility.h
//  Pinster
//
//  Created by MobileDev on 24/05/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PS_DEFAULT_FONT @"Hobo"
#import "MBProgressHUD.h"
#import "PSLabel.h"
#import "PSParentViewController.h"

@interface PSUtility : NSObject<MBProgressHUDDelegate>

+(PSUtility *)sharedInstance;
+ (void)setDefaultFontOnView:(id)view;
+ (void)setCornerRadiousToView:(id)view WithCornerRadious:(CGFloat)radious;
+ (NSArray *)loadDataFromLocalJsonfile:(NSString *)fileName;
+ (BOOL)isTrue:(id)value;
+ (void)showAlert:(NSString *)title withMessage:(NSString *)message;
+ (void)saveSessionValue:(id)value withKey:(NSString *)key;
+ (id)getValueFromSession:(NSString *)key ;
+ (void)removeValueFromSessionWithKey:(NSString *)key;
//+ (PSLabel *)getNoPStaFoundLabel:(NSString *)text;
+ (id)getViewControllerWithName:(NSString *)nibName;

+ (BOOL) isValidData : (NSString*) activeValue;
+ (BOOL)validateTitleFirstChar:(NSString*)enterdName;
+ (BOOL) validatePasswordLength : (NSString*) PasswordValue;
+ (BOOL) comparePasswords:(NSString*) password confirmPassword:(NSString*)confirmPassword;
+ (BOOL) validateEmail: (NSString *) myEmail;

+ (void)setBorderSettings:(id)view;
+ (UIColor *)appDefaultColor;
+ (NSDate *)getDateFromString:(NSString *)dateString withFormate:(NSString *)dateFormate;
+ (UIBarButtonItem *)getBackBarButtonWithSelecter:(SEL)selecter withTarget:(id)target;
+ (void)showProgressHUDWithText:(NSString *)text onView:(id)vc;
+ (void)hideProgressHUDFromVC:(id)vc;
+(BOOL)isValidURL:(NSString *)urlStr;

+ (PSLabel *)getHeaderLabelWithText:(NSString *)text;
+ (UIBarButtonItem *)getBarButtonWithNormalImage:(NSString *)nImage withSelectedImage:(NSString *)sImage  alignmentLeft:(BOOL)value withSelecter:(SEL)selecter withTarget:(id)target;
+ (UIBarButtonItem *)getBarButtonWithTitle:(NSString *)title alignmentLeft:(BOOL)value withSelecter:(SEL)selecter withTarget:(id)target;

+ (id)checkNil:(id)value;
- (void)showCustomAlertWithMessage:(NSString *)message onViewController:(PSParentViewController *)viewController withDelegate:(id)delegate;
+ (NSString *)getCurrentUserId;
//+ (id)getViewControllerWithName:(NSString *)nibName withIphone4:(BOOL)value;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

+ (UIImage *)getCategoryImageWithId:(NSString *)catId isSmall:(BOOL)value;
@end

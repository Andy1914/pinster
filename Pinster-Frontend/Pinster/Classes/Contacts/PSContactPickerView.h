//
//  ContactPickerTextView.h
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSContactBubble.h"

@class PSContactPickerView;

@protocol PSContactPickerDelegate <NSObject>

- (void)contactPickerTextViewDidChange:(NSString *)textViewText;
- (void)contactPickerDidRemoveContact:(id)contact;
- (void)contactPickerDidResize:(PSContactPickerView *)contactPickerView;

@end

@interface PSContactPickerView : UIView <UITextViewDelegate, PSContactBubbleDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) PSContactBubble *selectedContactBubble;
@property (nonatomic, assign) IBOutlet id <PSContactPickerDelegate> delegate;
@property (nonatomic, assign) BOOL limitToOne;
@property (nonatomic, assign) CGFloat viewPadding;
@property (nonatomic, strong) UIFont *font;

- (void)addContact:(id)contact withName:(NSString *)name;
- (void)removeContact:(id)contact;
- (void)removeAllContacts;
- (void)setPlaceholderString:(NSString *)placeholderString;
- (void)disableDropShadow;
- (void)resignKeyboard;
- (void)setBubbleColor:(PSBubbleColor *)color selectedColor:(PSBubbleColor *)selectedColor;
    
@end

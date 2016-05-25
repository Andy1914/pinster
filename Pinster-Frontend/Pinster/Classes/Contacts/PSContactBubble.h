//
//  PSContactBubble.h
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PSBubbleColor.h"

@class PSContactBubble;

@protocol PSContactBubbleDelegate <NSObject>

- (void)contactBubbleWasSelected:(PSContactBubble *)contactBubble;
- (void)contactBubbleWasUnSelected:(PSContactBubble *)contactBubble;
- (void)contactBubbleShouldBeRemoved:(PSContactBubble *)contactBubble;

@end

@interface PSContactBubble : UIView <UITextViewDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextView *textView; // used to capture keyboard touches when view is selected
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) id <PSContactBubbleDelegate>delegate;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) PSBubbleColor *color;
@property (nonatomic, strong) PSBubbleColor *selectedColor;

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name
             color:(PSBubbleColor *)color
     selectedColor:(PSBubbleColor *)selectedColor;

- (void)select;
- (void)unSelect;
- (void)setFont:(UIFont *)font;

@end

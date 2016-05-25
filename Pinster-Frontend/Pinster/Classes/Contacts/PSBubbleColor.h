//
//  PSBubbleColor.h
//  ContactPicker
//

//

#import <Foundation/Foundation.h>

@interface PSBubbleColor : NSObject

@property (nonatomic, strong) UIColor *gradientTop;
@property (nonatomic, strong) UIColor *gradientBottom;
@property (nonatomic, strong) UIColor *border;

- (id)initWithGradientTop:(UIColor *)gradientTop gradientBottom:(UIColor *)gradientBottom border:(UIColor *)border;

@end

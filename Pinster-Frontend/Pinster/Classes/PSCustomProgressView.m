//
//  PSCustomProgressView.m
//  Pinster
//
//  Created by Mobiledev on 30/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSCustomProgressView.h"

@implementation PSCustomProgressView
@synthesize current_value;
@synthesize delegate;

- (id)init
{
    CGRect frame;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)
        frame = CGRectMake(0.0, ([[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.height)/2, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.height);
    else
        frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.height)/2, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.height);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        current_value = 0.0;
        new_to_value = 0.0;
        IsAnimationInProgress = NO;
        
        self.alpha = 0.95;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        ProgressLbl = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-200)/2, self.frame.size.height/2-150, 200, 40.0)];
        ProgressLbl.font = [UIFont boldSystemFontOfSize:24.0];
        ProgressLbl.text = @"0%";
        ProgressLbl.backgroundColor = [UIColor clearColor];
        ProgressLbl.textColor = [UIColor whiteColor];
        ProgressLbl.textAlignment = NSTextAlignmentCenter ;
        ProgressLbl.alpha = self.alpha;
        [self addSubview:ProgressLbl];
    }
    return self;
}

-(void)UpdateLabelsWithValue:(NSString*)value
{
    ProgressLbl.text = value;
}

-(void)setProgressValue:(float)to_value withAnimationTime:(float)animation_time
{
    float timer = 0;
    
    float step = 0.1;
    
    float value_step = (to_value-self.current_value)*step/animation_time;
    int final_value = self.current_value*100;
    
    while (timer<animation_time-step) {
        final_value += floor(value_step*100);
        [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%i%%", final_value] afterDelay:timer];
        timer += step;
    }
    [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%.0f%%", to_value*100] afterDelay:animation_time];
}

-(void)SetAnimationDone
{
//    IsAnimationInProgress = NO;
//    if (new_to_value>self.current_value)
//        [self setProgress:[NSNumber numberWithFloat:new_to_value]];
//    if (self.current_value == 0.75 && delegate && [delegate respondsToSelector:@selector(didFinishAnimation:)]) {
//        self.current_value = 0.0;
        [self.circle removeFromSuperlayer];
    [self setProgress:nil];
//        [delegate performSelector:@selector(didFinishAnimation:) withObject:self afterDelay:0.0];
//
//    }
//    [self setProgress:<#(NSNumber *)#>]
}
#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
- (void)setProgress:(NSNumber*)value{
//    [self performSelector:@selector(SetAnimationDone) withObject:Nil afterDelay:1.5];
    float radius = 60.0;
    self.circle = [CAShapeLayer layer];
     CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    if(!isReverse) {
        self.circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                          radius:radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES].CGPath;
        isReverse = YES;
        drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    } else {
        self.circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
                                                          radius:radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES].CGPath;
        isReverse = NO;
        drawAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        drawAnimation.toValue   = [NSNumber numberWithFloat:0.0];
    }
//    drawAnimation.delegate = self;
    // Configure the apperence of the circle
    self.circle.fillColor = [UIColor clearColor].CGColor;
    self.circle.strokeColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"render_image.png"]].CGColor;
    self.circle.lineWidth = 20;
    
    // Add to parent layer
    [self.layer addSublayer:self.circle];
    
    // Configure animation
   
    
    drawAnimation.duration            = 0;
    drawAnimation.repeatCount         = 1;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // Add the animation to the circle
    [self.circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
//    self.current_value = to_value;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.circle removeFromSuperlayer];
    [self setProgress:nil];
}


@end

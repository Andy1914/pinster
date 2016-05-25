//
//  PSCustomProgressView.h
//  Pinster
//
//  Created by Mobiledev on 30/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface PSCustomProgressView : UIView {
    float current_value;
    float new_to_value;
    
    UILabel *ProgressLbl;
    
    id delegate;
    
    BOOL IsAnimationInProgress;
    int isReverse;
}
@property id delegate;
@property float current_value;
@property (nonatomic, strong) CAShapeLayer *circle;
- (id)init;
- (void)setProgress:(NSNumber*)value;

@end

@protocol PSCustomProgressViewDelegate
- (void)didFinishAnimation:(PSCustomProgressView*)progressView;

@end

//
//  ViewController.m
//  GraphicsSmoothTest
//
//  Created by wutian on 06/05/2018.
//  Copyright © 2018 wutian. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (nonatomic, strong) CALayer * backgroundLayer;
@property (nonatomic, strong) CALayer * circleLayer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.wantsLayer = YES;
    [self.view.layer addSublayer:self.backgroundLayer];
    [self.backgroundLayer addSublayer:self.circleLayer];
}

- (void)viewWillLayout
{
    [super viewWillLayout];
    
    [self stopAnimation];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGRect b = self.view.bounds;
    self.backgroundLayer.frame = b;
    CGFloat size = b.size.height / 3;
    self.circleLayer.frame = CGRectMake(0, (b.size.height - size) / 2, size, size);
    
    [CATransaction commit];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopAnimation];
        [self startAnimation];
    });
}

- (void)stopAnimation
{
    [_circleLayer removeAllAnimations];
}

- (void)startAnimation
{
    CGFloat size = _circleLayer.frame.size.width;
    CGRect b = self.view.bounds;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = @(self.circleLayer.position);
    animation.toValue = @(CGPointMake(b.size.width - size/2, b.size.height / 2));
    animation.repeatCount = CGFLOAT_MAX;
    animation.autoreverses = YES;
    animation.duration = 0.4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [_circleLayer addAnimation:animation forKey:@"move"];
}

- (CALayer *)backgroundLayer
{
    if (!_backgroundLayer) {
        _backgroundLayer = [CALayer layer];
        _backgroundLayer.backgroundColor = [NSColor blackColor].CGColor;
    }
    return _backgroundLayer;
}

- (CALayer *)circleLayer
{
    if (!_circleLayer) {
        _circleLayer = [CALayer layer];
        _circleLayer.backgroundColor = [NSColor colorWithWhite:0.8 alpha:1.0].CGColor;
    }
    return _circleLayer;
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

@end

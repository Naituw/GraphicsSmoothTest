//
//  MainViewController.m
//  GraphicsSmoothTest
//
//  Created by wutian on 06/05/2018.
//  Copyright © 2018 wutian. All rights reserved.
//

#import "MainViewController.h"
#import "POPSpringAnimation.h"
#import "POPBasicAnimation.h"
#import "POPAnimatableProperty.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController () <NSWindowDelegate>
@property (weak) IBOutlet NSButton *windowTestButton;
@property (weak) IBOutlet NSButton *stopTestButton;
@property (weak) IBOutlet NSButton *layerTestButton;

@property (strong) NSWindowController * layerTestWindowController;
@property (strong) NSWindowController * windowMoveTestWindowController;
@property (unsafe_unretained) IBOutlet NSTextView *moveTextView;
@property (nonatomic, strong) NSDateFormatter * logDateFormatter;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _stopTestButton.hidden = YES;
    _logDateFormatter = [[NSDateFormatter alloc] init];
    _logDateFormatter.dateFormat = @"HH:mm:ss:SSS";
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    self.view.window.delegate = self;
}

- (IBAction)runWindowMoveTest:(id)sender
{
    [self appendText:@"did run window move test"];

    _windowTestButton.hidden = YES;
    _layerTestButton.hidden = YES;
    _stopTestButton.hidden = NO;
    
    NSStoryboard * storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    _windowMoveTestWindowController = [storyBoard instantiateControllerWithIdentifier:@"windowMoveTest"]; // instantiate your window controller
    [_windowMoveTestWindowController showWindow:self];
    
    [self runWindowMoveAnimation];
}

- (IBAction)layerMoveTest:(id)sender
{
    [self appendText:@"did run layer move test"];

    _windowTestButton.hidden = YES;
    _layerTestButton.hidden = YES;
    _stopTestButton.hidden = NO;
    
    NSStoryboard * storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    _layerTestWindowController = [storyBoard instantiateControllerWithIdentifier:@"layerTestController"]; // instantiate your window controller
    [_layerTestWindowController showWindow:self];
}

- (IBAction)stopTest:(id)sender
{
    [self appendText:@"did stop test"];

    _windowTestButton.hidden = NO;
    _layerTestButton.hidden = NO;
    _stopTestButton.hidden = YES;
    
    [_layerTestWindowController close];
    _layerTestWindowController = nil;
    
    [self stopWindowMoveAnimation];
    [_windowMoveTestWindowController close];
    _windowMoveTestWindowController = nil;
}

- (void)runWindowMoveAnimation
{
    // Move window to same screen as mainWindow
    NSWindow * testWindow = _windowMoveTestWindowController.window;
    NSWindow * mainWindow = self.view.window;
    [testWindow setFrame:mainWindow.frame display:YES];
    
    NSScreen * screen = testWindow.screen;
    NSRect screenFrame = screen.visibleFrame;
    CGSize windowSize = testWindow.frame.size;
    CGFloat windowX = NSMinX(screenFrame) + (screenFrame.size.width - windowSize.width) / 2;
    
    NSRect topOfWindowFrame = NSMakeRect(windowX, NSMaxY(screenFrame) - windowSize.height, windowSize.width, windowSize.height);
    NSRect bottomOfWindowFrame = NSMakeRect(windowX, NSMinY(screenFrame), windowSize.width, windowSize.height);
    
    // Move window to top of screen
    [testWindow setFrame:topOfWindowFrame display:YES];
    
    // Then start the animation loop
//    POPSpringAnimation * animation = [POPSpringAnimation animationWithPropertyNamed:kPOPWindowFrame];
//    animation.springBounciness = 0;
//    animation.springSpeed = 3;

    POPBasicAnimation * animation = [POPBasicAnimation animationWithPropertyNamed:kPOPWindowFrame];
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0 :1 :1 :1];
    
    animation.autoreverses = YES;
    animation.repeatCount = NSIntegerMax;
    animation.fromValue = @(topOfWindowFrame);
    animation.toValue = @(bottomOfWindowFrame);
    
    [testWindow pop_addAnimation:animation forKey:@"movement"];
}

- (void)stopWindowMoveAnimation
{
    [_windowMoveTestWindowController.window pop_removeAllAnimations];
}

- (void)appendText:(NSString *)text
{
    NSString * append = [NSString stringWithFormat:@"[%@] %@\n", [_logDateFormatter stringFromDate:[NSDate date]], text];
    [_moveTextView.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:append]];
    [_moveTextView scrollRangeToVisible: NSMakeRange(_moveTextView.string.length, 0)];
}

- (void)windowDidMove:(NSNotification *)notification
{
    [self appendText:@"window did move"];
}

@end

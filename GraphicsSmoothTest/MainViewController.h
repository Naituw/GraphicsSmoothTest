//
//  MainViewController.h
//  GraphicsSmoothTest
//
//  Created by wutian on 06/05/2018.
//  Copyright © 2018 wutian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController

@end

@interface MainTrackingView : NSView

@property (nonatomic, weak) MainViewController * mainViewController;

@end

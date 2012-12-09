//
//  HFRAppDelegate.h
//  RythmTap
//
//  Created by Holger Frohloff on 09.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFRViewController;

@interface HFRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HFRViewController *viewController;

@end

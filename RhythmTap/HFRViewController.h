//
//  HFRViewController.h
//  RhythmTap
//
//  Created by Holger Frohloff on 09.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFRViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *nextRoundButton;
- (IBAction)newRoundButtonPressed:(id)sender;
@end

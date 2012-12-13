//
//  HFRRectangleView.h
//  RhythmTap
//
//  Created by Holger Frohloff on 09.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFRRectangleView : UIView
@property (nonatomic) NSNumber *startX;
@property (nonatomic) NSNumber *startY;
@property (nonatomic, weak) NSNumber *index;
@property (nonatomic) UIColor *bgColor;
- (void)highlightWithLength:(float)length;
@end

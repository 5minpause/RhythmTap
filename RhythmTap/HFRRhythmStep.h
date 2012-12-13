//
//  HFRRhythmStep.h
//  RhythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFRRectangleView.h"

@interface HFRRhythmStep : NSObject
@property (nonatomic) NSUInteger index;
@property (nonatomic) NSNumber *length;
@property (nonatomic, strong) HFRRectangleView *stepView;
- (BOOL)compareWithRythmStep:(HFRRhythmStep *)step;
@end

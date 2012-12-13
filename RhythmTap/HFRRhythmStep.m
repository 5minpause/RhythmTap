//
//  HFRRythmStep.m
//  RhythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import "HFRRhythmStep.h"

@implementation HFRRhythmStep
- (BOOL)compareWithRythmStep:(HFRRhythmStep *)step;
{
  return (step.index == self.index && step.length.floatValue == self.length.floatValue);
}
@end

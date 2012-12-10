//
//  HFRRythmStep.m
//  RythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import "HFRRythmStep.h"

@implementation HFRRythmStep
- (BOOL)compareWithRythmStep:(HFRRythmStep *)step;
{
  return (step.index == self.index && step.length.floatValue == self.length.floatValue);
}
@end

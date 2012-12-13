//
//  HFRRhythmChain.m
//  RhythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import "HFRRhythmChain.h"
#import "PSYBlockTimer.h"
#import "HFRRhythmStep.h"

@implementation HFRRhythmChain

- (void)startChain;
{
  [self.chain eachWithIndex:^(HFRRhythmStep *step, int index) {
    [NSTimer scheduledTimerWithTimeInterval:(1.0 * (index+1)) repeats:NO usingBlock:^(NSTimer *timer) {
      [step.stepView highlightWithLength:0.2];
    }];
  }];
}

- (BOOL)compareWithChain:(HFRRhythmChain *)otherChain;
{
  __block BOOL result = YES;

  [otherChain.chain eachWithIndex:^(HFRRhythmStep *step, int index) {
    result = result && [[self.chain objectAtIndex:index] compareWithRythmStep:step];
  }];

  return result;
}
- (id)init
{
  self = [super init];
  if (self) {
    _chain = [NSMutableArray new];
  }
  return self;
}
@end

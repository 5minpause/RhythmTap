//
//  HFRRythmChain.m
//  RythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import "HFRRythmChain.h"
#import "PSYBlockTimer.h"
#import "HFRRythmStep.h"

@implementation HFRRythmChain
- (void)startChain;
{
  [self.chain eachWithIndex:^(HFRRythmStep *step, int index) {
    [NSTimer scheduledTimerWithTimeInterval:(1.0 * (index+1)) repeats:NO usingBlock:^(NSTimer *timer) {
      [step.stepView highlightWithLength:0.2];
    }];
  }];
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

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

#define kHFRPlayNextStep  (@"kHFRPlayNextStep")
#define kHFRStepIndex     (@"kHFRStepIndex")

@implementation HFRRhythmChain

- (void)playStepAtIndex:(int)index;
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kHFRPlayNextStep object:nil];
  self.stepToPlay += 1;
  DLog(@"play Step at Index: %d", index);
  @try {
    HFRRhythmStep *step = [self.chain objectAtIndex:index];
    [step.stepView highlightWithLength:step.length.floatValue andPause:step.pauseAfterStep.floatValue];
    [[NSNotificationCenter defaultCenter] addObserverForName:kHFRPlayNextStep
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note)
     {
       DLog(@"Next step note gathered");
       if (self.stepToPlay < self.chain.count) {
         [self playStepAtIndex:self.stepToPlay];
       } else{
         [[NSNotificationCenter defaultCenter] removeObserver:self name:kHFRPlayNextStep object:nil];
       }
     }];
  }
  @catch (NSException *exception) {
    DLog(@"Tried to access object out of bounds! index: %d", index);
  }
  @finally {

  }
}

- (void)startChain;
{
  DLog(@"starting Chain");
  [self playStepAtIndex:0];
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
    _stepToPlay = 0;
  }
  return self;
}
@end

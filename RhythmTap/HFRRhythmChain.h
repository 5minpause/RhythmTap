//
//  HFRRhythmChain.h
//  RhythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFRRhythmChain : NSObject
@property (nonatomic, strong) NSMutableArray *chain;
@property (nonatomic) NSUInteger stepToPlay;
- (void)startChain;
- (BOOL)compareWithChain:(HFRRhythmChain *)otherChain;
@end

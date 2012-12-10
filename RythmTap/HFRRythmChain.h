//
//  HFRRythmChain.h
//  RythmTap
//
//  Created by Holger Frohloff on 10.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFRRythmChain : NSObject
@property (nonatomic, strong) NSMutableArray *chain;

- (void)startChain;
- (BOOL)compareWithChain:(HFRRythmChain *)otherChain;
@end

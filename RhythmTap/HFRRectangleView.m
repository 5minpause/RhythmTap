//
//  HFRRectangleView.m
//  RhythmTap
//
//  Created by Holger Frohloff on 09.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import "HFRRectangleView.h"
#import "Common.h"
#import "PSYBlockTimer.h"

#define kHFRTouchTime      (@"kHFRTouchTime")
#define kHFRTouchLength    (@"kHFRTouchLength")

@interface HFRRectangleView ()
@property (nonatomic, strong) NSDate *touchStarted;
//@property (nonatomic, strong) NSDate *touchEnded;
@end

@implementation HFRRectangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path setLineWidth:1.0];
  [path setLineJoinStyle:kCGLineJoinRound];
  [path setLineCapStyle:kCGLineCapRound];

  CGPoint initalPoint = CGPointMake(self.startX.floatValue, self.startY.floatValue);
  [path moveToPoint:initalPoint];
  [path addLineToPoint:CGPointMake(self.startX.floatValue, self.startY.floatValue + 80.0)];
  [path addLineToPoint:CGPointMake(self.startX.floatValue + 80.0, self.startY.floatValue + 80.0)];
  [path addLineToPoint:CGPointMake(self.startX.floatValue + 80.0, self.startY.floatValue)];
  [path closePath];

  [[UIColor whiteColor] setStroke];
  [path stroke];
  CGContextRestoreGState(context);
}

- (void)highlightWithLength:(float)length;
{
  UIColor *newColor = [self.bgColor colorWithAlphaComponent:0.2];
  [self setBackgroundColor:newColor];
  [self setNeedsDisplay];
//  [NSTimer scheduledTimerWithTimeInterval:length repeats:NO usingBlock:^(NSTimer *timer) {
//    [self setBackgroundColor:oldColor];
//    [self setNeedsDisplay];
//  }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.touchStarted = [NSDate date];
}

- (void)handleTouchEnded;
{
  double time = [self.touchStarted timeIntervalSinceNow] * (-1);
  NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:time] forKey:kHFRTouchLength];
  [[NSNotificationCenter defaultCenter] postNotificationName:kHFRTouchTime
                                                      object:nil
                                                    userInfo:dic];
  [self setBackgroundColor:self.bgColor];
  [self setNeedsDisplay];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self handleTouchEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self handleTouchEnded];
}
@end

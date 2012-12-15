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
#define kHFRPlayNextStep  (@"kHFRPlayNextStep")

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

- (void)highlightWithLength:(float)length andPause:(float)pause;
{
  DLog(@"Highlighting");
  UIColor *newColor = [self.bgColor colorWithAlphaComponent:0.2];
  [self setBackgroundColor:newColor];
  [self setNeedsDisplay];

  double delayInSeconds = length;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self setBackgroundColor:self.bgColor];
    [self setNeedsDisplay];
  });

  double pauseInSeconds = pause + length;
  dispatch_time_t pauseTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(pauseInSeconds * NSEC_PER_SEC));
  dispatch_after(pauseTime, dispatch_get_main_queue(), ^(void){
    DLog(@"Posting next step note");
    [[NSNotificationCenter defaultCenter] postNotificationName:kHFRPlayNextStep
                                                        object:nil
                                                      userInfo:nil];
  });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.touchStarted = [NSDate date];
  UIColor *newColor = [self.bgColor colorWithAlphaComponent:0.2];
  [self setBackgroundColor:newColor];
  [self setNeedsDisplay];
}

- (void)handleTouchEnded;
{
  double time = [self.touchStarted timeIntervalSinceNow] * (-1);
  NSDictionary *dic = @{kHFRTouchLength : [NSNumber numberWithDouble:time]};
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

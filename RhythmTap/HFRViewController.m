//
//  HFRViewController.m
//  RhythmTap
//
//  Created by Holger Frohloff on 09.12.12.
//  Copyright (c) 2012 Holger Frohloff. All rights reserved.
//

#import "HFRViewController.h"
#import "HFRRectangleView.h"
#import "PSYBlockTimer.h"
#import "HFRRhythmStep.h"
#import "HFRRhythmChain.h"
#import "MBProgressHUD.h"

#define kHFRDifficulty     (@"kHFRDifficulty")
#define kHFRTouchLength    (@"kHFRTouchLength")
#define kHFRTouchTime      (@"kHFRTouchTime")

@interface HFRViewController ()
@property (nonatomic, strong) NSArray *rectangleViewsArray;
@property (nonatomic, strong) NSNumber *difficulty;
@property (nonatomic, strong) HFRRhythmChain *rythmChain;
@property (nonatomic, strong) HFRRhythmChain *userChain;
- (void)calculateResult;
@end

@implementation HFRViewController

- (void)touchDetectedAtView:(UITapGestureRecognizer *)tapRec;
{
  [[NSNotificationCenter defaultCenter] addObserverForName:kHFRTouchTime
                                                    object:nil
                                                     queue:[NSOperationQueue mainQueue]
                                                usingBlock:^(NSNotification *note)
  {
    __block HFRRhythmStep *playedStep = [HFRRhythmStep new];
    playedStep.index = [self.rectangleViewsArray indexOfObject:(HFRRectangleView *)tapRec.view];
    playedStep.length = [note.userInfo valueForKey:kHFRTouchLength];
    [self.userChain.chain addObject:playedStep];
  }];
  if (self.userChain.chain.count == self.difficulty.unsignedIntegerValue) {
    [self calculateResult];
  }
}

- (void)calculateResult
{
  BOOL result = [self.userChain compareWithChain:self.rythmChain];
  [self.userChain.chain removeAllObjects];
  [self.rythmChain.chain removeAllObjects];
  self.rythmChain.stepToPlay = 0;

  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.mode = MBProgressHUDModeText;
  hud.labelText = result ? @"Gewonnen!" : @"Leider nicht gewonnen.";
  double delayInSeconds = 1.5;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.nextRoundButton.enabled = YES;
  });
}

- (void)playRythm;
{
  [self.difficulty timesWithIndex:^(int index) {
    HFRRhythmStep *newStep = [HFRRhythmStep new];
    int number = arc4random_uniform(9);
    newStep.index = [[NSNumber numberWithInt:number] unsignedIntegerValue];

    #define ARC4RANDOM_MAX 0x100000000
    double maxRange = 1.5;
    double minRange = 0.2;
    double lengthVal = ((double)arc4random() / ARC4RANDOM_MAX) * (maxRange - minRange) + minRange;
    double pauseVal = ((double)arc4random() / ARC4RANDOM_MAX) * (1.0 - 0.5) + 0.5;
    newStep.length = [NSNumber numberWithFloat:lengthVal];
    newStep.pauseAfterStep = [NSNumber numberWithFloat:pauseVal];
    newStep.stepView = [self.rectangleViewsArray objectAtIndex:[[NSNumber numberWithInt:number] unsignedIntegerValue]];
    [self.rythmChain.chain addObject:newStep];
  }];
  DLog(@"Rythm set up");
  [self.rythmChain startChain];
}

- (IBAction)newRoundButtonPressed:(id)sender;
{
  self.nextRoundButton.enabled = NO;
  [self playRythm];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor blackColor]];

  self.rythmChain = [HFRRhythmChain new];
  self.userChain = [HFRRhythmChain new];
  self.nextRoundButton.enabled = NO;

  // Standardschwierigkeitsgrad soll 3 Lichter sein
  if ([[NSUserDefaults standardUserDefaults] valueForKey:kHFRDifficulty] != nil) {
    self.difficulty = [[NSUserDefaults standardUserDefaults] valueForKey:kHFRDifficulty];
  } else
    self.difficulty = [NSNumber numberWithInt:3];

  // First row
  HFRRectangleView *rectangleUL = [[HFRRectangleView alloc] initWithFrame:CGRectMake(20.0, 20.0, 80.0, 80.0)];
  HFRRectangleView *rectangleUM = [[HFRRectangleView alloc] initWithFrame:CGRectMake(120.0, 20.0, 80.0, 80.0)];
  HFRRectangleView *rectangleUR = [[HFRRectangleView alloc] initWithFrame:CGRectMake(220.0, 20.0, 80.0, 80.0)];
  // Middle row
  HFRRectangleView *rectangleML = [[HFRRectangleView alloc] initWithFrame:CGRectMake(20.0, 120.0, 80.0, 80.0)];
  HFRRectangleView *rectangleMM = [[HFRRectangleView alloc] initWithFrame:CGRectMake(120.0, 120.0, 80.0, 80.0)];
  HFRRectangleView *rectangleMR = [[HFRRectangleView alloc] initWithFrame:CGRectMake(220.0, 120.0, 80.0, 80.0)];
  // Last row
  HFRRectangleView *rectangleLL = [[HFRRectangleView alloc] initWithFrame:CGRectMake(20.0, 220.0, 80.0, 80.0)];
  HFRRectangleView *rectangleLM = [[HFRRectangleView alloc] initWithFrame:CGRectMake(120.0, 220.0, 80.0, 80.0)];
  HFRRectangleView *rectangleLR = [[HFRRectangleView alloc] initWithFrame:CGRectMake(220.0, 220.0, 80.0, 80.0)];

  self.rectangleViewsArray = [NSArray arrayWithObjects:rectangleUL, rectangleUM, rectangleUR,
                                            rectangleML, rectangleMM, rectangleMR,
                                            rectangleLL, rectangleLM, rectangleLR, nil];
  NSArray *colors = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor redColor], [UIColor yellowColor],
                     [UIColor blueColor], [UIColor purpleColor], [UIColor brownColor],
                     [UIColor grayColor], [UIColor whiteColor], [UIColor orangeColor], nil];

  [self.rectangleViewsArray eachWithIndex:^(HFRRectangleView *recView, int index) {
    recView.startX = [NSNumber numberWithFloat:0.0];
    recView.startY = [NSNumber numberWithFloat:0.0];
    recView.index = [NSNumber numberWithInt:index];
    NSUInteger colorInt = [recView.index unsignedIntegerValue];
    [recView setBackgroundColor:[colors objectAtIndex:colorInt]];
    recView.bgColor = [colors objectAtIndex:colorInt];

    // Gesture Recognizer
    UITapGestureRecognizer *recog = [UITapGestureRecognizer new];
    recog.numberOfTapsRequired = 1;
    recog.numberOfTouchesRequired = 1;
    [recog addTarget:self action:@selector(touchDetectedAtView:)];
    [recView addGestureRecognizer:recog];
    
    [self.view addSubview:recView];
    [recView setNeedsDisplay];
  }];

  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.mode = MBProgressHUDModeText;
  hud.labelText = @"Get ready!";
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playRythm) userInfo:nil repeats:NO];
  });


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

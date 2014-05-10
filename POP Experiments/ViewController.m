//
//  ViewController.m
//  POP Experiments
//
//  Created by Brad Jasper on 5/3/14.
//  Copyright (c) 2014 Brad Jasper. All rights reserved.
//

#import "ViewController.h"

#import <POP/POP.h>

#import <Tweaks/FBTweak.h>
#import <Tweaks/FBTweakInline.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *circle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = YES;
    
    self.circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.circle.center = self.view.center;
    self.circle.layer.cornerRadius = 50;
    self.circle.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.circle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateCircleLocation:[self getCenterFromTouches:[event allTouches]]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateCircleLocation:[self getCenterFromTouches:[event allTouches]]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableSet *activeTouches = [[event allTouches] mutableCopy];
    [activeTouches minusSet:touches];
    [self updateCircleLocation:[self getCenterFromTouches:activeTouches]];
}


- (CGPoint)getCenterFromTouches:(NSSet *)touches
{
    int numTouches = [touches count];
    if (numTouches == 0) {
        return self.view.center;
    }
    
    float posX = 0.0, posY = 0.0;
    CGPoint pos;
    
    for (UITouch *touch in touches) {
        pos = [touch locationInView:self.view];
        posX += pos.x;
        posY += pos.y;
    }
    
    return CGPointMake(posX / numTouches, posY / numTouches);
}

- (void)updateCircleLocation:(CGPoint)location
{
    NSValue *toValue = [NSValue valueWithCGPoint:location];
    
    POPSpringAnimation *springAnim = [self.circle pop_animationForKey:@"position"];
    
    // If animation exists we can just update the toValue...where the magic happens
    if (springAnim != NULL) {
        springAnim.toValue = toValue;
    } else {
        
        // Otherwise let's create a new animation using customizable tweaks (shake the ipad/iphone)
        
        FBTweak *springSpeedTweak = FBTweakInline(@"Circle", @"Spring", @"Speed", 12, 0, 20);
        springSpeedTweak.stepValue = @1;
        
        FBTweak *springBouncinessTweak = FBTweakInline(@"Circle", @"Spring", @"Bounciness", 10, 0, 20);
        springBouncinessTweak.stepValue = @1;
        
        springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        springAnim.toValue = toValue;
        springAnim.springSpeed = [[springSpeedTweak currentValue] floatValue];
        springAnim.springBounciness = [[springBouncinessTweak currentValue] floatValue];
        [self.circle pop_addAnimation:springAnim forKey:@"position"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end

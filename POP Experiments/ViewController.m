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
    
    // Init with empty set of touches ...hacky fix
    [self updateCircleSize:[self getSizeFromTouches:[NSSet setWithObjects:nil]]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateCircleLocation:[self getCenterFromTouches:[event allTouches]]];
    [self updateCircleSize:[self getSizeFromTouches:[event allTouches]]];
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
    
    [self updateCircleSize:[self getSizeFromTouches:activeTouches]];
}

// Get the size of a circle by the number of touches
- (CGSize)getSizeFromTouches:(NSSet *)touches
{
    int numTouches = [touches count];
    float initialSize = FBTweakValue(@"Circle", @"Size", @"Initial", 1.0);
    float percentToGrowPerTouch = FBTweakValue(@"Circle", @"Size", @"PerTouch", 0.1, 0, 5);
    float radius = initialSize + (numTouches * percentToGrowPerTouch);
    return CGSizeMake(radius, radius);
}

// Average a bunch of touches to find the center
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
    if (!FBTweakValue(@"Circle", @"Position", @"Enable", YES)) {
        return;
    }
    
    NSValue *toValue = [NSValue valueWithCGPoint:location];
    
    POPSpringAnimation *anim = [self.circle pop_animationForKey:@"position"];
    
    // If animation exists we can just update the toValue...where the magic happens
    if (anim != NULL) {
        anim.toValue = toValue;
    } else {
        
        // Otherwise let's create a new animation using customizable tweaks (shake the ipad/iphone)
        
        FBTweak *springSpeedTweak = FBTweakInline(@"Circle", @"Position", @"Speed", 12, 0, 20);
        springSpeedTweak.stepValue = @1;
        
        FBTweak *springBouncinessTweak = FBTweakInline(@"Circle", @"Position", @"Bounciness", 10, 0, 20);
        springBouncinessTweak.stepValue = @1;
        
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        anim.toValue = toValue;
        anim.springSpeed = [[springSpeedTweak currentValue] floatValue];
        anim.springBounciness = [[springBouncinessTweak currentValue] floatValue];
        [self.circle pop_addAnimation:anim forKey:@"position"];
    }
}

- (void)updateCircleSize:(CGSize)size
{
    if (!FBTweakValue(@"Circle", @"Size", @"Enable", NO)) {
        return;
    }
    
    NSValue *toValue = [NSValue valueWithCGSize:size];
    
    NSLog(@"Updating circle size = %@", NSStringFromCGSize(size));
    
    POPSpringAnimation *anim = [self.circle pop_animationForKey:@"scale"];
    
    
    if (anim != NULL) {
        anim.toValue = toValue;
    } else {
        
        FBTweak *springSpeedTweak = FBTweakInline(@"Circle", @"Size", @"Speed", 18, 0, 20);
        springSpeedTweak.stepValue = @1;
        
        FBTweak *springBouncinessTweak = FBTweakInline(@"Circle", @"Size", @"Bounciness", 4, 0, 20);
        springBouncinessTweak.stepValue = @1;
        
        anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        anim.toValue = toValue;
        anim.springSpeed = [[springSpeedTweak currentValue] floatValue];
        anim.springBounciness = [[springBouncinessTweak currentValue] floatValue];
        [self.circle pop_addAnimation:anim forKey:@"scale"];
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

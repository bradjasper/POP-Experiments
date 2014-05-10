//
//  ViewController.m
//  POP Experiments
//
//  Created by Brad Jasper on 5/3/14.
//  Copyright (c) 2014 Brad Jasper. All rights reserved.
//

#import "ViewController.h"

#import <POP/POP.h>

#import <Tweaks/FBTweakInline.h>
#import <Tweaks/FBTweakViewController.h>
#import <Tweaks/FBTweakShakeWindow.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *circle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = YES;
    
    self.circle = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.circle.layer.cornerRadius = 50;
    self.circle.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.circle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches began = %d", [touches count]);
    
    UITouch *touch = [[touches objectEnumerator] nextObject];
    CGPoint location = [touch locationInView:self.view];
    [self updateCircleLocation:location];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches moved = %d", [touches count]);
    
    UITouch *touch = [[touches objectEnumerator] nextObject];
    CGPoint location = [touch locationInView:self.view];
    [self updateCircleLocation:location];
}


    
- (void)updateCircleLocation:(CGPoint)location
{
    NSValue *toValue = [NSValue valueWithCGPoint:location];
    
    POPSpringAnimation *springAnim = [self.circle pop_animationForKey:@"position"];
    
    if (springAnim != NULL) {
        NSLog(@"Found spring animation!");
        springAnim.toValue = toValue;
    } else {
        NSLog(@"No spring animation, creating");
        springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
        springAnim.toValue = toValue;
        springAnim.springSpeed = 20;
        springAnim.springBounciness = 10;
        [self.circle pop_addAnimation:springAnim forKey:@"position"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

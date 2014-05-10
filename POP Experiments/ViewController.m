//
//  ViewController.m
//  POP Experiments
//
//  Created by Brad Jasper on 5/3/14.
//  Copyright (c) 2014 Brad Jasper. All rights reserved.
//

#import "ViewController.h"

#import <POP/POP.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *circle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.multipleTouchEnabled = YES;
    
    self.circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.circle.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.circle.layer.cornerRadius = 50;
    self.circle.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.circle];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
        return CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    }
    
    float posX = 0.0, posY = 0.0;
    CGPoint pos;
    
    for (UITouch *touch in [touches objectEnumerator]) {
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
    
    if (springAnim != NULL) {
        springAnim.toValue = toValue;
    } else {
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

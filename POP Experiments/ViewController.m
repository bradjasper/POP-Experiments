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

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup label
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    self.label.userInteractionEnabled = YES;
    self.label.text = @"Hello POP!";
    [self.view addSubview:self.label];
    
    NSLog(@"Adding label");
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLabel)];
    [self.label addGestureRecognizer:tapGesture];
    
    
    // Setup tweaks

    UILabel *tweaksLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 100, 100)];
    tweaksLabel.userInteractionEnabled = YES;
    tweaksLabel.text = @"Tweaks";
    [self.view addSubview:tweaksLabel];
    
    UITapGestureRecognizer *tweakTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTweaks)];
    [tweaksLabel addGestureRecognizer:tweakTapGesture];
    
}

- (void)tappedTweaks {
    FBTweakViewController *tweakViewConroller = [[FBTweakViewController alloc] initWithStore:[FBTweakStore sharedInstance]];
    [self presentViewController:tweakViewConroller animated:YES completion:nil];
}

- (void)tappedLabel
{
    NSLog(@"Received gesture tap");
    
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
   

    float toValue = FBTweakValue(@"View", @"Label", @"ToValue", 700.0);
    float velocity = FBTweakValue(@"View", @"Label", @"Velocity", 5.0, 0.0, 50.0);
    float bounciness = FBTweakValue(@"View", @"Label", @"Bouniness", 4.0, 0.0, 20.0);
    float springSpeed = FBTweakValue(@"View", @"Label", @"Spring Speed", 12.0, 0.0, 20.0);

    
    NSLog(@"Tapped label velocity=%f toValue=%f bounciness=%f springSpeed=%f", velocity, toValue, bounciness, springSpeed);
    
    springAnim.toValue = @(toValue);
    springAnim.velocity = @(velocity);
    springAnim.springBounciness = bounciness;
    springAnim.springSpeed = springSpeed;
    
    springAnim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        NSLog(@"Animation is complete");
        self.label.frame = CGRectMake(50, 50, 100, 100);
    };
   
    [self.label pop_addAnimation:springAnim forKey:@"size"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

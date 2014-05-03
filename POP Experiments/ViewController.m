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

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    self.label.userInteractionEnabled = YES;
    self.label.text = @"Hello POP!";
    [self.view addSubview:self.label];
    
    NSLog(@"Adding label");
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLabel)];
    
    [self.label addGestureRecognizer:tapGesture];
}

- (void)tappedLabel
{
    NSLog(@"Received gesture tap");
    
    POPSpringAnimation *springAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    
    springAnim.toValue = @700;
    springAnim.velocity = @10;
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

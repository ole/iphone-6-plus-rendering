//
//  RootViewController.m
//  PixelGridGL
//
//  Created by Ole Begemann on 30/10/14.
//  Copyright (c) 2014 Ole Begemann. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurOverlayView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)overlaySelectionDidChange:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.overlayView.hidden = YES;
            self.blurOverlayView.hidden = YES;
            break;
        case 1:
            self.overlayView.hidden = NO;
            self.blurOverlayView.hidden = YES;
            break;
        case 2:
            self.overlayView.hidden = YES;
            self.blurOverlayView.hidden = NO;
            break;
    }
}

@end

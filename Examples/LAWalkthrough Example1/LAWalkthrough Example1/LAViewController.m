//
//  LAViewController.m
//  LAWalkthrough Example1
//
//  Created by Larry Aasen on 4/16/13.
//
//

#import "LAViewController.h"
#import "LAWalkthroughViewController.h"

@interface LAViewController ()

@end

@implementation LAViewController

- (void)createWalkthrough
{
  // Create the walkthrough view controller
  LAWalkthroughViewController *walkthrough = LAWalkthroughViewController.new;
  walkthrough.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//  walkthrough.backgroundImage = [UIImage imageNamed:@"tour-bg@2x"];
  
  // Create pages of the walkthrough
  [walkthrough addPageWithBody:@"Take a tour of this app."];
    [walkthrough addPageWithBody:@"Take a tour of this app 1."];
    [walkthrough addPageWithBody:@"Take a tour of this app 2."];
    [walkthrough addPageWithBody:@"Take a tour of this app 3."];
    [walkthrough addPageWithNibName:@"walkthroughExample1" bundle:nil];
  [walkthrough addPageWithBody:@"Thanks for taking this tour."];
  
  // Use the default next button
    walkthrough.nextButtonText = @"Next";
    walkthrough.doneButtonText = @"Done";
  
  // Add the walkthrough view to your view controller's view
  [self addChildViewController:walkthrough];
  [self.view addSubview:walkthrough.view];
}

- (void)viewDidAppear:(BOOL)animated
{
  [self createWalkthrough];
  
  [super viewDidAppear:animated];
}

@end

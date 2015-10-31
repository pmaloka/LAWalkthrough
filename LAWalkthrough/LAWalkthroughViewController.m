//  LAWalkthroughViewController.m
//  LAWalkthrough
//
//  Created by Larry Aasen on 4/11/13.
//
// Copyright (c) 2013 Larry Aasen (http://larryaasen.wordpress.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "LAWalkthroughViewController.h"

@interface LAWalkthroughViewController ()
{
}

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIButton *nextButton;

@end

@implementation LAWalkthroughViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self)
  {
    self.pageViews = NSMutableArray.new;
    
    self.pageControlBottomMargin = 10+40;
  }
  return self;
}

- (void)loadView
{
  self.view = [[UIView alloc] initWithFrame:CGRectZero];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.backgroundImageView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.pageControl = [self createPageControl];
    [self.pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(float)(0xd8)/255.0f green:(float)(0xd8)/255.0f blue:(float)(0xd8)/255.0f alpha:1];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:(float)(0x8c)/255.0f blue:1 alpha:1];
    
    [self.view addSubview:self.pageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.backgroundImage) {
        self.backgroundImageView.frame = self.view.frame;
        self.backgroundImageView.image = self.backgroundImage;
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.numberOfPages, self.scrollView.frame.size.height);
    
    self.pageControl.frame = self.pageControlFrame;
    self.pageControl.numberOfPages = self.numberOfPages;
    
    BOOL useDefaultNextButton = !(self.nextButtonImage || self.nextButtonText);
    if (useDefaultNextButton)
    {
        self.nextButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        self.nextButton.frame = CGRectMake(0, 0, self.nextButton.frame.size.width+20, self.nextButton.frame.size.height);
    }
    else
    {
        self.nextButton = UIButton.new;
        CGRect buttonFrame = self.nextButton.frame;
        if (self.nextButtonText)
        {
            [self.nextButton setTitle:self.nextButtonText forState:UIControlStateNormal];
            self.nextButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            buttonFrame.size = CGSizeMake(self.view.bounds.size.width-60, 36);
            self.nextButton.backgroundColor = self.pageControl.currentPageIndicatorTintColor;
            [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.nextButton.layer.cornerRadius = 3.0;
        }
        else if (self.nextButtonImage)
        {
            self.nextButton.imageView.image = self.nextButtonImage;
            buttonFrame.size = self.nextButtonImage.size;
        }
        self.nextButton.frame = buttonFrame;
    }
    
    CGRect buttonFrame = self.nextButton.frame;
    buttonFrame.origin = self.nextButtonOrigin;
    self.nextButton.frame = buttonFrame;
    [self.view addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(displayNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    self.skipButton = [[UIButton alloc] init];
    [self.skipButton setTitle: @"Skip" forState:UIControlStateNormal];
    self.skipButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    [self.skipButton sizeToFit];
    buttonFrame = self.skipButton.frame;
    [self.skipButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    buttonFrame.origin.x = self.view.frame.size.width-buttonFrame.size.width-10;
    buttonFrame.origin.y = 10;
    self.skipButton.frame = buttonFrame;
    [self.skipButton setTitleColor:self.pageControl.currentPageIndicatorTintColor forState:UIControlStateNormal];
    [self.view addSubview:self.skipButton];
    [super viewWillAppear:animated];
}

- (CGRect)defaultPageFrame
{
  return self.view.frame;
}

- (UIView *)addPageWithBody:(NSString *)bodyText
{
  UIView *pageView = [self addPageWithView:nil];
  
  CGRect frame = pageView.frame;
  frame.origin = CGPointZero;
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.backgroundColor = [UIColor clearColor];
  label.opaque = NO;
  label.textColor = [UIColor lightGrayColor];
  label.font = [UIFont systemFontOfSize:22];
  label.lineBreakMode = NSLineBreakByWordWrapping;
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  label.autoresizesSubviews = YES;

  label.text = bodyText;
  
  [pageView addSubview:label];

  return pageView;
}

- (UIView *)addPageWithNibName:(NSString *)name bundle:(NSBundle *)bundleOrNil
{
  UINib *nib = [UINib nibWithNibName:name bundle:bundleOrNil];
  NSArray *objects = [nib instantiateWithOwner:self options:nil];
  UIView *view = objects.lastObject;
  view.frame = self.view.frame;
  [self addPageWithView:view];
  
  return view;
}

- (UIView *)addPageWithView:(UIView *)pageView
{
  if (!pageView)
  {
    pageView = [[UIView alloc] initWithFrame:[self defaultPageFrame]];
    pageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }

  // Move the view to its correct page location
  CGRect frame = pageView.frame;
  frame.origin.x = self.numberOfPages * pageView.frame.size.width;
  pageView.frame = frame;
  
  [self.pageViews addObject:pageView];
  [self.scrollView addSubview:pageView];
  return pageView;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)displayNextPage
{
    if (++self.pageControl.currentPage < self.numberOfPages) {
        [self changePage];
    } else {
        [self dismiss];
    }
}

- (void)changePage
{
  NSInteger pageIndex = self.pageControl.currentPage;
  
  // update the scroll view to the appropriate page
  CGRect frame = self.scrollView.frame;
  frame.origin.x = frame.size.width * pageIndex;
  frame.origin.y = 0;
  [self.scrollView scrollRectToVisible:frame animated:YES];

  pageControlUsed = YES;
}

- (NSArray *)pages
{
  return [self.pageViews copy];
}

// Used only by consumers
- (NSInteger)numberOfPages
{
  return self.pageViews.count;
}

- (CGPoint)nextButtonOrigin
{
  return CGPointMake((self.pageControl.frame.size.width - self.nextButton.frame.size.width)/2, self.view.bounds.size.height - self.pageControlBottomMargin);
}

- (CGRect)pageControlFrame
{
  CGSize pagerSize = [self.pageControl sizeForNumberOfPages:self.numberOfPages];
  
  return CGRectMake(0,
                    self.scrollView.frame.size.height - self.pageControlBottomMargin - pagerSize.height,
                    self.view.frame.size.width,
                    pagerSize.height);
}

- (UIPageControl *)createPageControl
{
  return [[UIPageControl alloc] initWithFrame:CGRectZero];
}

#pragma mark UIScrollViewDelegate method

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int nextPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // Hide the Next button when this is the last page
    if (nextPage == self.pageControl.numberOfPages - 1) {
        if (self.doneButtonText == nil) {
            self.nextButton.hidden = YES;
        } else {
            [self.nextButton setTitle:self.doneButtonText forState:UIControlStateNormal];

        }
    } else {
        self.nextButton.hidden = NO;
        [self.nextButton setTitle:self.nextButtonText forState:UIControlStateNormal];
    }
    
    if (pageControlUsed) {
        return;
    }
    if (!isResize)
        self.pageControl.currentPage = nextPage;
    isResize = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  pageControlUsed = NO;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    isResize = YES;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Resize background image
    if (self.backgroundImage) {
        self.backgroundImageView.frame = self.view.frame;
    }
    
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.numberOfPages, self.scrollView.frame.size.height);
    
    self.pageControl.frame = self.pageControlFrame;
    self.pageControl.numberOfPages = self.numberOfPages;
    
    BOOL useDefaultNextButton = !(self.nextButtonImage || self.nextButtonText);
    if (useDefaultNextButton) {
        self.nextButton.frame = CGRectMake(0, 0, self.nextButton.frame.size.width + 20, self.nextButton.frame.size.height);
    } else {
        CGRect buttonFrame = self.nextButton.frame;
        if (self.nextButtonText) {
            buttonFrame.size = CGSizeMake(self.view.bounds.size.width-60, 36);
        } else if (self.nextButtonImage) {
            buttonFrame.size = self.nextButtonImage.size;
        }
        self.nextButton.frame = buttonFrame;
    }
    CGRect buttonFrame = self.nextButton.frame;
    buttonFrame.origin = self.nextButtonOrigin;
    self.nextButton.frame = buttonFrame;
    
    int pageNum = 0;
    for (UIView *pageView in self.pageViews) {
        CGRect frame = pageView.frame;
        frame.origin.x = pageNum * pageView.frame.size.width;
        pageView.frame = frame;

        pageNum++;
    }
    
    NSInteger pageIndex = self.pageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * pageIndex;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

@end

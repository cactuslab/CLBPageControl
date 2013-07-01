//
//  CLBViewController.m
//  PageControlTestApp
//
//  Created by Christian Sheehan on 28/06/13.
//  Copyright (c) 2013 Cactuslab. All rights reserved.
//

#import "CLBViewController.h"

#import "CLBPageControl.h"

@interface CLBViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet CLBPageControl *clPageControl;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSArray *images;

@end

@implementation CLBViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.delegate = self;
    self.imageViews = [[NSMutableArray alloc] init];
    self.images = @[[UIImage imageNamed:@"img0.jpg"], [UIImage imageNamed:@"img1.jpg"], [UIImage imageNamed:@"img2.jpg"]];
    [self addImageToImageView];
}

- (void)addImageToImageView
{
    NSInteger num = fmod(self.imageViews.count, 3);
    UIImage *image = self.images[num];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    CGFloat x = self.imageViews.count * self.scrollView.frame.size.width;
    CGRect imageViewFrame = self.scrollView.bounds;
    imageViewFrame.origin.x = x;
    imageView.frame = imageViewFrame;
    [self.imageViews addObject:imageView];
    [self.scrollView addSubview:imageView];
    [self.scrollView setContentSize:CGSizeMake((self.imageViews.count) * self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    self.pageControl.numberOfPages = self.imageViews.count;
    self.clPageControl.numberOfPages = self.imageViews.count;
}

- (IBAction)tappedNewImageButton:(id)sender
{
    [self addImageToImageView];
}

- (IBAction)tappedPlusFiveButton:(id)sender
{
    for (int i = 0; i < 5; i++) {
        [self addImageToImageView];
    }
}

- (IBAction)tappedClear:(id)sender
{
    for (NSInteger i = (self.imageViews.count - 1); i > 0; i--) {
        UIView *view = self.imageViews[i];
        [view removeFromSuperview];
    }
    self.imageViews = [@[self.imageViews[0]] mutableCopy];
    [self.scrollView setContentSize:self.scrollView.bounds.size];

    self.pageControl.numberOfPages = 1;
    self.clPageControl.numberOfPages = 1;
}

- (IBAction)pageControlValueChanged:(id)sender {
    int xOffset = self.pageControl.currentPage * self.scrollView.frame.size.width;
	[self.scrollView scrollRectToVisible:CGRectMake(xOffset, 0, self.scrollView.frame.size.width, 2) animated:YES];
	[self.pageControl setCurrentPage:self.pageControl.currentPage];
	[self.clPageControl setCurrentPage:self.pageControl.currentPage];
}

- (IBAction)clPageControlValueChanged:(id)sender {
    int xOffset = self.clPageControl.currentPage * self.scrollView.frame.size.width;
	[self.scrollView scrollRectToVisible:CGRectMake(xOffset, 0, self.scrollView.frame.size.width, 2) animated:YES];
	[self.clPageControl setCurrentPage:self.clPageControl.currentPage];
	[self.pageControl setCurrentPage:self.clPageControl.currentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
	[self.pageControl setCurrentPage:ceil(page)];
    [self.clPageControl setCurrentPage:ceil(page)];
}

@end

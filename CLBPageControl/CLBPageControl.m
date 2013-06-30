//
//  CLBPageControl.m
//  PageControlTestApp
//
//  Created by Christian Sheehan on 28/06/13.
//  Copyright (c) 2013 Cactuslab. All rights reserved.
//

#import "CLBPageControl.h"

@interface CLBPageControl()

@property (strong, nonatomic) NSMutableArray *dots;

@end

@implementation CLBPageControl

- (id)init
{
    if (self = [super init]) {
        [self setUpPageControl];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUpPageControl];
}

- (void)setUpPageControl
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    
    self.dots = [[NSMutableArray alloc] init];
    self.clipsToBounds = YES;
    self.dotWidth = 16;
    self.currentPage = 0;
    
    [UIView setAnimationDelegate:self];
    
    self.dotImage = [UIImage imageNamed:@"dot.png"];
    self.dotImageHighlighted = [UIImage imageNamed:@"dot-on.png"];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    [self updateDots];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    if (self.currentPage > self.numberOfPages - 1) {
        if (self.numberOfPages == 0) {
            self.currentPage = 0;
        } else {
            self.currentPage = self.numberOfPages - 1;
        }
    }
    [self updateDots];
}

- (void)addNewDots
{
    NSInteger newDotCount = self.numberOfPages - self.dots.count;
    for (NSInteger i = 0; i < newDotCount; i++) {
        [self addNewDot];
    }
}

- (void)addNewDot
{
    UIImageView *dot = [[UIImageView alloc] initWithImage:self.dotImage highlightedImage:self.dotImageHighlighted];
    dot.alpha = 0.0;
    CGRect dotFrame = dot.frame;
    dotFrame.origin.y = (self.frame.size.height - dotFrame.size.height)/2;
    dot.frame = dotFrame;
    [self.dots addObject:dot];
    [self addSubview:dot];
}

- (void)removeOldDots
{
    NSInteger newDotCount = self.numberOfPages - self.dots.count;
    NSMutableArray *copyOfDots = [self.dots mutableCopy];
    for (NSInteger i = -newDotCount; i > 0; i--) {
        UIImageView *dot = [self.dots objectAtIndex:i];
        [UIView animateWithDuration:0.3 animations:^{
            dot.alpha = 0.0;
        } completion:^(BOOL finished){
            [dot removeFromSuperview];
        }];
        [copyOfDots removeLastObject];
    }
    self.dots = copyOfDots;
}

- (void)repositionDots
{
    CGFloat totalWidth = self.numberOfPages * self.dotWidth;
    CGFloat xOffset = (self.frame.size.width - totalWidth)/2;
    int i = 0;
    for (UIImageView *dot in self.dots) {
        CGRect dotFrame = dot.frame;
        CGFloat distanceIntoDots = (i * self.dotWidth) + ((self.dotWidth - dotFrame.size.width)/2);
        dotFrame.origin.x = xOffset + distanceIntoDots;
        if (dot.alpha == 0.0) {
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                dot.alpha = 1.0;
            } completion:nil];
            dot.frame = dotFrame;
        } else {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            dot.frame = dotFrame;
            [UIView commitAnimations];
        }
        i++;
    }
}

- (void)highlightCurrentDot
{
    NSInteger i = 0;
    for (UIImageView *dot in self.dots) {
        if (i == self.currentPage) {
            [dot setHighlighted:YES];
        } else {
            [dot setHighlighted:NO];
        }
        i++;
    }
}

- (void)updateDots
{
    [self addNewDots];
    [self removeOldDots];
    
    [self repositionDots];
    [self highlightCurrentDot];
}

- (void)handleTap:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint locationInView = [sender locationInView:self];
        if (locationInView.x < self.frame.size.width/2) {
            [self goLeft];
        } else {
            [self goRight];
        }
    }
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self goLeft];
    }
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self goRight];
    }
}

- (void)goRight
{
    if (self.currentPage < self.numberOfPages -1) {
        self.currentPage++;
        [self updateDots];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)goLeft
{
    if (self.currentPage > 0) {
        self.currentPage--;
        [self updateDots];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
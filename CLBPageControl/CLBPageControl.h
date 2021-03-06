//
//  CLBPageControl.h
//  PageControlTestApp
//
//  Created by Christian Sheehan on 28/06/13.
//  Copyright (c) 2013 Cactuslab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLBPageControl : UIControl

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) CGFloat dotWidth; /* This should be the width of the dot image + left and right padding */
@property (strong, nonatomic) UIImage *dotImage;
@property (strong, nonatomic) UIImage *dotImageHighlighted;

@end

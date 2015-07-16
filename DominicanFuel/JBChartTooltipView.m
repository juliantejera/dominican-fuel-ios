//
//  JBChartTooltipView.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 3/12/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBChartTooltipView.h"

// Drawing
#import <QuartzCore/QuartzCore.h>

// Numerics
CGFloat static const kJBChartTooltipViewCornerRadius = 10.0;
CGFloat const kJBChartTooltipViewDefaultWidth = 30.0f;
CGFloat const kJBChartTooltipViewDefaultHeight = 30.0f;

@interface JBChartTooltipView ()

@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation JBChartTooltipView

#pragma mark - Alloc/Init

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kJBChartTooltipViewDefaultWidth, kJBChartTooltipViewDefaultHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        _textLabel = [[UILabel alloc] init];
//        _textLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        _textLabel.textColor = [UIColor blueColor];
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = kJBChartTooltipViewCornerRadius;
        _textLabel.layer.masksToBounds = YES;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_textLabel];
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark - Setters

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
    [self setNeedsLayout];
}

- (void)setTooltipColor:(UIColor *)tooltipColor
{
    self.backgroundColor = tooltipColor;
    [self setNeedsDisplay];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
//    _imageView.frame = self.bounds;
}

- (void) setImage:(UIImage *) image {
    self.imageView.image = image;
}

@end

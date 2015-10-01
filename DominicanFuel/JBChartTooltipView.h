//
//  JBChartTooltipView.h
//  JBChartViewDemo
//
//  Created by Terry Worona on 3/12/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JBChartTooltipView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setText:(NSString *)text;
- (void)setImage:(UIImage *) image;
@end

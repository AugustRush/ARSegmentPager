//
//  CustomHeader.m
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "CustomHeader.h"

@interface CustomHeader ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;


@end

@implementation CustomHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (UIImageView *)backgroundImageView {
    return self.imageView;
}

- (void)updateHeadPhotoWithTopInset:(CGFloat)inset {
    CGFloat ratio = (inset - 64)/200.0;
    self.bottomConstraint.constant = ratio * 30 + 10;
    self.widthConstraint.constant = 30 + ratio * 50;
}

@end

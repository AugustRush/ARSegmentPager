//
//  CustomHeader.h
//  ARSegmentPager
//
//  Created by August on 15/5/20.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageController/ARSegmentPageControllerHeaderProtocol.h"

@interface CustomHeader : UIView<ARSegmentPageControllerHeaderProtocol>

@property(weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

- (void)updateHeadPhotoWithTopInset:(CGFloat)inset;

@end

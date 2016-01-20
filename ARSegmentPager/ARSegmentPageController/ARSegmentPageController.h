//
//  ARSegmentPageController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentControllerDelegate.h"
#import "ARSegmentPageControllerHeaderProtocol.h"
#import "ARSegmentPageHeader.h"
#import <UIKit/UIKit.h>

@interface ARSegmentPageController : UIViewController

@property(nonatomic, assign) CGFloat segmentHeight; // should be greater than 0
@property(nonatomic, assign) CGFloat headerHeight; // should be greater than 0
@property(nonatomic, assign)
    CGFloat segmentMiniTopInset; // should be equal or greater than 0
@property(nonatomic, assign, readonly) CGFloat segmentTopInset;
@property(nonatomic, assign) BOOL freezenHeaderWhenReachMaxHeaderHeight;

@property(nonatomic, weak, readonly)
    UIViewController<ARSegmentControllerDelegate> *currentDisplayController;

@property(nonatomic, strong, readonly)
    UIView<ARSegmentPageControllerHeaderProtocol> *headerView;

- (instancetype)initWithControllers:
    (UIViewController<ARSegmentControllerDelegate> *)controller,
    ... NS_REQUIRES_NIL_TERMINATION;

- (void)setViewControllers:(NSArray *)viewControllers;

// override this method to custom your own header view
- (UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView;

@end

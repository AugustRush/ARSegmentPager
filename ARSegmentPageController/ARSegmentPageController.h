//
//  ARSegmentPageController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentControllerDelegate.h"
#import "ARSegmentPageHeader.h"
#import "ARSegmentPageControllerHeaderProtocol.h"

@interface ARSegmentPageController : UIViewController

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat segmentMiniTopInset;
@property (nonatomic, assign, readonly) CGFloat segmentToInset;

@property (nonatomic, weak, readonly) UIViewController<ARSegmentControllerDelegate> *currentDisplayController;

@property (nonatomic, strong, readonly) UIView<ARSegmentPageControllerHeaderProtocol> *headerView;

@property (nonatomic, assign) BOOL freezenHeaderWhenReachMaxHeaderHeight;

-(instancetype)initWithControllers:(UIViewController<ARSegmentControllerDelegate> *)controller,... NS_REQUIRES_NIL_TERMINATION;

-(void)setViewControllers:(NSArray *)viewControllers;

//override this method to custom your own header view
-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView;

@end

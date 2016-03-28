//
//  ARSegmentPageController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentPageController.h"
#import "ARSegmentView.h"

const void *_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET =
    &_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET;
const void *_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWINSET =
    &_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWINSET;

@interface ARSegmentPageController ()

@property(nonatomic, strong)
    UIView<ARSegmentPageControllerHeaderProtocol> *headerView;
@property(nonatomic, strong) ARSegmentView *segmentView;
@property(nonatomic, strong) NSMutableArray *controllers;
@property(nonatomic, assign) CGFloat segmentTopInset;
@property(nonatomic, weak)
    UIViewController<ARSegmentControllerDelegate> *currentDisplayController;
@property(nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;
@property(nonatomic, strong) NSHashTable *hasShownControllers;
@property(nonatomic, assign) BOOL ignoreOffsetChanged; //是否忽略offset的改变
@property(nonatomic, assign) CGFloat originalTopInset;

@end

@implementation ARSegmentPageController

#pragma mark - life cycle methods

- (instancetype)initWithControllers:
    (UIViewController<ARSegmentControllerDelegate> *)controller, ... {
  self = [super init];
  if (self) {
    NSAssert(controller != nil, @"the first controller must not be nil!");
    [self _setUp];
    UIViewController<ARSegmentControllerDelegate> *eachController;
    va_list argumentList;
    if (controller) {
      [self.controllers addObject:controller];
      va_start(argumentList, controller);
      while ((eachController = va_arg(argumentList, id))) {
        [self.controllers addObject:eachController];
      }
      va_end(argumentList);
    }
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self _setUp];
  }
  return self;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self _setUp];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self _baseConfigs];
  [self _baseLayout];
}

#pragma mark - public methods

- (void)setViewControllers:(NSArray *)viewControllers {
  [self.controllers removeAllObjects];
  [self.controllers addObjectsFromArray:viewControllers];
}

#pragma mark - override methods

- (UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView {
  return [[ARSegmentPageHeader alloc] init];
}

#pragma mark - private methdos

- (void)_setUp {
  self.ignoreOffsetChanged = NO;
  self.headerHeight = 400;
  self.segmentHeight = 44;
  self.segmentTopInset = 400;
  self.segmentMiniTopInset = 0;
  self.controllers = [NSMutableArray array];
  self.hasShownControllers = [NSHashTable weakObjectsHashTable];
}

- (void)_baseConfigs {
  self.automaticallyAdjustsScrollViewInsets = NO;
  if ([self.view
          respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    self.view.preservesSuperviewLayoutMargins = YES;
  }
  self.extendedLayoutIncludesOpaqueBars = NO;
  self.headerView = [self customHeaderView];
  self.headerView.clipsToBounds = YES;
  [self.view addSubview:self.headerView];

  self.segmentView = [[ARSegmentView alloc] init];
  [self.segmentView.segmentControl
             addTarget:self
                action:@selector(segmentControlDidChangedValue:)
      forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.segmentView];

  // all segment title and controllers
  [self.controllers
      enumerateObjectsUsingBlock:^(
          UIViewController<ARSegmentControllerDelegate> *controller,
          NSUInteger idx, BOOL *stop) {
        NSString *title = [controller segmentTitle];

        [self.segmentView.segmentControl insertSegmentWithTitle:title
                                                        atIndex:idx
                                                       animated:NO];
      }];

  // defaut at index 0
  self.segmentView.segmentControl.selectedSegmentIndex = 0;
  UIViewController<ARSegmentControllerDelegate> *controller =
      self.controllers[0];
  [controller willMoveToParentViewController:self];
  [self.view insertSubview:controller.view atIndex:0];
  [self addChildViewController:controller];
  [controller didMoveToParentViewController:self];

  [self _layoutControllerWithController:controller];
  [self addObserverForPageController:controller];

  self.currentDisplayController = self.controllers[0];
}

- (void)_baseLayout {
  // header
  self.headerView.translatesAutoresizingMaskIntoConstraints = NO;

  self.headerHeightConstraint =
      [NSLayoutConstraint constraintWithItem:self.headerView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:nil
                                   attribute:0
                                  multiplier:1
                                    constant:self.headerHeight];
  [self.headerView addConstraint:self.headerHeightConstraint];

  [self.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeLeft
                                                multiplier:1
                                                  constant:0]];
  [self.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:0]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.headerView
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1
                                         constant:0]];

  // segment
  self.segmentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeLeft
                                                multiplier:1
                                                  constant:0]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.segmentView
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1
                                         constant:0]];

  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.segmentView
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.headerView
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1
                                         constant:0]];

  [self.segmentView addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.segmentView
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:nil
                                               attribute:0
                                              multiplier:1
                                                constant:self.segmentHeight]];
}

- (void)_layoutControllerWithController:
    (UIViewController<ARSegmentControllerDelegate> *)pageController {
  UIView *pageView = pageController.view;
  if ([pageView
          respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
    pageView.preservesSuperviewLayoutMargins = YES;
  }
  pageView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:pageView
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeLeading
                                       multiplier:1
                                         constant:0]];
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:pageView
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeTrailing
                                       multiplier:1
                                         constant:0]];

  UIScrollView *scrollView = [self scrollViewInPageController:pageController];
  if (scrollView) {
    scrollView.alwaysBounceVertical = YES;
    _originalTopInset = self.headerHeight + self.segmentHeight;
    // fixed bootom tabbar inset
    CGFloat bottomInset = 0;
    if (self.tabBarController.tabBar.hidden == NO) {
      bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
    }

    [scrollView
        setContentInset:UIEdgeInsetsMake(_originalTopInset, 0, bottomInset, 0)];
    //     fixed first time don't show header view
    if (![self.hasShownControllers containsObject:pageController]) {
      [self.hasShownControllers addObject:pageController];
      [scrollView setContentOffset:CGPointMake(0, -self.headerHeight -
                                                      self.segmentHeight)];
    }

    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:pageView
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1
                                           constant:0]];

    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:pageView
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
  } else {
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:pageView
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.segmentView
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint
                                 constraintWithItem:pageView
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.view
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1
                                           constant:-self.segmentHeight]];
  }
}

- (UIScrollView *)scrollViewInPageController:
    (UIViewController<ARSegmentControllerDelegate> *)controller {
  if ([controller respondsToSelector:@selector(streachScrollView)]) {
    return [controller streachScrollView];
  } else if ([controller.view isKindOfClass:[UIScrollView class]]) {
    return (UIScrollView *)controller.view;
  } else {
    return nil;
  }
}

#pragma mark - add / remove obsever for page scrollView

- (void)addObserverForPageController:
    (UIViewController<ARSegmentControllerDelegate> *)controller {
  UIScrollView *scrollView = [self scrollViewInPageController:controller];
  if (scrollView != nil) {
    [scrollView
        addObserver:self
         forKeyPath:NSStringFromSelector(@selector(contentOffset))
            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
            context:&_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET];
    [scrollView
        addObserver:self
         forKeyPath:NSStringFromSelector(@selector(contentInset))
            options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
            context:&_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWINSET];
  }
}

- (void)removeObseverForPageController:
    (UIViewController<ARSegmentControllerDelegate> *)controller {
  UIScrollView *scrollView = [self scrollViewInPageController:controller];
  if (scrollView != nil) {
    @try {
      [scrollView
          removeObserver:self
              forKeyPath:NSStringFromSelector(@selector(contentOffset))];
      [scrollView removeObserver:self
                      forKeyPath:NSStringFromSelector(@selector(contentInset))];
    } @catch (NSException *exception) {
      NSLog(@"exception is %@", exception);
    } @finally {
    }
  }
}

#pragma mark - obsever delegate methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (context == _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET &&
      !_ignoreOffsetChanged) {
    CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGFloat offsetY = offset.y;
    CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGFloat oldOffsetY = oldOffset.y;
    CGFloat deltaOfOffsetY = offset.y - oldOffsetY;
    CGFloat offsetYWithSegment = offset.y + self.segmentHeight;

    if (deltaOfOffsetY > 0 &&
        offsetY >= -(self.headerHeight + self.segmentHeight)) {
      // 当滑动是向上滑动时且不是回弹
      // 跟随移动的偏移量进行变化
      // NOTE:直接相减有可能constant会变成负数，进而被系统强行移除，导致header悬停的位置错乱或者crash
      if (self.headerHeightConstraint.constant - deltaOfOffsetY <= 0) {
        self.headerHeightConstraint.constant = self.segmentMiniTopInset;
      } else {
        self.headerHeightConstraint.constant -= deltaOfOffsetY;
      }
      // 如果到达顶部固定区域，那么不继续滑动
      if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset) {
        self.headerHeightConstraint.constant = self.segmentMiniTopInset;
      }
    } else {
      // 当向下滑动时
      // 如果列表已经滚动到屏幕上方
      // 那么保持顶部栏在顶部
      if (offsetY > 0) {
        if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset) {
          self.headerHeightConstraint.constant = self.segmentMiniTopInset;
        }
      } else {
        // 如果列表顶部已经进入屏幕
        // 如果顶部栏已经到达底部
        if (self.headerHeightConstraint.constant >= self.headerHeight) {
          // 如果当前列表滚到了顶部栏的底部
          // 那么顶部栏继续跟随变大，否这保持不变
          if (-offsetYWithSegment > self.headerHeight &&
              !_freezenHeaderWhenReachMaxHeaderHeight) {
            self.headerHeightConstraint.constant = -offsetYWithSegment;
          } else {
            self.headerHeightConstraint.constant = self.headerHeight;
          }
        } else {
          // 在顶部拦未到达底部的情况下
          // 如果列表还没滚动到顶部栏底部，那么什么都不做
          // 如果已经到达顶部栏底部，那么顶部栏跟随滚动
          if (self.headerHeightConstraint.constant < -offsetYWithSegment) {
            self.headerHeightConstraint.constant -= deltaOfOffsetY;
          }
        }
      }
    }
    // 更新'segmentToInset'变量，让外部的 kvo 知道顶部栏位置的变化
    self.segmentTopInset = self.headerHeightConstraint.constant;
  } else if (context == _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWINSET) {
    UIEdgeInsets insets = [object contentInset];
    if (fabs(insets.top - _originalTopInset) < 2) {
      self.ignoreOffsetChanged = NO;
    } else {
      self.ignoreOffsetChanged = YES;
    }
  }
}

#pragma mark - event methods

- (void)segmentControlDidChangedValue:(UISegmentedControl *)sender {
  // remove obsever
  [self removeObseverForPageController:self.currentDisplayController];

  // add new controller
  NSUInteger index = [sender selectedSegmentIndex];
  UIViewController<ARSegmentControllerDelegate> *controller =
      self.controllers[index];

  [self.currentDisplayController willMoveToParentViewController:nil];
  [self.currentDisplayController.view removeFromSuperview];
  [self.currentDisplayController removeFromParentViewController];
  [self.currentDisplayController didMoveToParentViewController:nil];

  [controller willMoveToParentViewController:self];
  [self.view insertSubview:controller.view atIndex:0];
  [self addChildViewController:controller];
  [controller didMoveToParentViewController:self];

  // reset current controller
  self.currentDisplayController = controller;
  // layout new controller
  [self _layoutControllerWithController:controller];

  [self.view setNeedsLayout];
  [self.view layoutIfNeeded];

  // trigger to fixed header constraint
  UIScrollView *scrollView = [self scrollViewInPageController:controller];
  if (self.headerHeightConstraint.constant != self.headerHeight) {
    if (scrollView.contentOffset.y >=
            -(self.segmentHeight + self.headerHeight) &&
        scrollView.contentOffset.y <= -self.segmentHeight) {
      [scrollView
          setContentOffset:CGPointMake(
                               0, -self.segmentHeight -
                                      self.headerHeightConstraint.constant)];
    }
  }
  // add obsever
  [self addObserverForPageController:self.currentDisplayController];
  [scrollView setContentOffset:scrollView.contentOffset];
}

#pragma mark - manage memory methods

- (void)dealloc {
  [self removeObseverForPageController:self.currentDisplayController];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end

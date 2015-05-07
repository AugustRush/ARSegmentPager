//
//  ARSegmentControllerDelegate.h
//  ARSegmentPager
//
//  Created by August on 15/3/29.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARSegmentControllerDelegate <NSObject>

-(NSString *)segmentTitle;

@optional
-(UIScrollView *)streachScrollView;

@end

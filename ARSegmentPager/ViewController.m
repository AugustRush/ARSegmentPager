//
//  ViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ViewController.h"
#import "ARSegmentPageController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"
#import "UIImage+ImageEffects.h"

#import "CustomHeaderViewController.h"

@interface ViewController ()<ARSegmentControllerDelegate>
- (IBAction)presentPageController:(id)sender;
- (IBAction)customHeader:(id)sender;

@property (nonatomic, strong) ARSegmentPageController *pager;

@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) UIImage *blurImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultImage = [UIImage imageNamed:@"listdownload.jpg"];
    self.blurImage = [[UIImage imageNamed:@"listdownload.jpg"] applyDarkEffect];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat topInset = [change[NSKeyValueChangeNewKey] floatValue];

    UIImageView *imageView = [self.pager.headerView backgroundImageView];
    if (topInset <= self.pager.segmentMiniTopInset) {
            self.pager.title = @"ARSegmentPager";
        imageView.image = self.blurImage;
    }else{
        self.pager.title = nil;
        imageView.image = self.defaultImage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)segmentTitle
{
    return @"common";
}

- (IBAction)presentPageController:(id)sender {
    
    if (self.pager != nil) {
        [self.pager removeObserver:self forKeyPath:@"segmentTopInset"];
        self.pager = nil;
    }
    TableViewController *table = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    CollectionViewController *collectionView = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    
    TableViewController *table1 = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] init];
    [pager setViewControllers:@[table,collectionView,table1]];
    pager.segmentMiniTopInset = 64;
    if (@available(iOS 11.0, *)) {
        pager.segmentMiniTopInset = 84;
    }
    pager.headerHeight = 200;
    pager.freezenHeaderWhenReachMaxHeaderHeight = YES;
    self.pager = pager;
    
    [self.pager addObserver:self forKeyPath:@"segmentTopInset" options:NSKeyValueObservingOptionNew context:NULL];


    [self.navigationController pushViewController:self.pager animated:YES];
}

- (IBAction)customHeader:(id)sender {
    CustomHeaderViewController *customHeader = [[CustomHeaderViewController alloc] init];
    
    [self.navigationController pushViewController:customHeader animated:YES];
}

@end

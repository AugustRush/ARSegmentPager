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
    
    TableViewController *table = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    CollectionViewController *collectionView = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    
    TableViewController *table1 = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
//    ARSegmentPageController *pager = [[ARSegmentPageController alloc] initWithControllers:collectionView,table,table1,nil];
    
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] init];
    [pager setViewControllers:@[table,collectionView,table1]];
    pager.freezenHeaderWhenReachMaxHeaderHeight = YES;
    pager.segmentMiniTopInset = 64;
    self.pager = pager;
    
    [self.pager addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:NULL];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat topInset = [change[NSKeyValueChangeNewKey] floatValue];
//    NSLog(@"top inset is %f",topInset);

    if (topInset <= self.pager.segmentMiniTopInset) {
            self.pager.title = @"ARSegmentPager";
        self.pager.headerView.imageView.image = self.blurImage;
    }else{
            self.pager.title = nil;
        self.pager.headerView.imageView.image = self.defaultImage;
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
    

    [self.navigationController pushViewController:self.pager animated:YES];
}

- (IBAction)customHeader:(id)sender {
    CustomHeaderViewController *customHeader = [[CustomHeaderViewController alloc] init];
    
    [self.navigationController pushViewController:customHeader animated:YES];
}

@end

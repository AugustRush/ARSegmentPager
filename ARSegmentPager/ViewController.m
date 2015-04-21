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

@interface ViewController ()<ARSegmentControllerDelegate>
- (IBAction)presentPageController:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view, typically from a nib.
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
    
    TableViewController *table = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    CollectionViewController *collectionView = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    
    ViewController *common = [[ViewController alloc] init];
    common.view.backgroundColor = [UIColor redColor];
    
    ARSegmentPageController *pageer = [[ARSegmentPageController alloc] initWithControllers:collectionView,table,common,nil];
    
    [self.navigationController pushViewController:pageer animated:YES];
}
@end

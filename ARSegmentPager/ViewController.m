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

@property (nonatomic, strong) ARSegmentPageController *pager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TableViewController *table = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    CollectionViewController *collectionView = [[CollectionViewController alloc] initWithNibName:@"CollectionViewController" bundle:nil];
    
    TableViewController *table1 = [[TableViewController alloc] initWithNibName:@"TableViewController" bundle:nil];
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] initWithControllers:collectionView,table,table1,nil];

    self.pager = pager;
    
    [self.pager addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:NULL];
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat topInset = [change[NSKeyValueChangeNewKey] floatValue];
    NSLog(@"top inset is %f",topInset);
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
@end

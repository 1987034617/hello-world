//
//  BaseController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.bgImageView];
    [self.view insertSubview:self.bgImageView atIndex:0];
}
- (void)equipmentiOS11With:(UITableView *)tableView
{
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    if (@available(iOS 11.0,*)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)equipmentiOS11WithCollectionView:(UICollectionView *)collectionView{
    if (@available(iOS 11.0,*)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action
{
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 50, 64)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backclick) forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}
-(void)backclick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
        _bgImageView.frame = self.view.bounds;
    }
    return _bgImageView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

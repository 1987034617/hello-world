//
//  TabBarMainController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "TabBarMainController.h"
#import "HomeController.h"
#import "SettingController.h"
#import "ScenceController.h"
#import "NavigationController.h"

@interface TabBarMainController ()

@end

@implementation TabBarMainController
+(void)load
{
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[NSForegroundColorAttributeName] = [UIColor colorWithRed:111/255.0 green:113/255.0 blue:121/255.0 alpha:1.0];
    dict1[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:dict1 forState:UIControlStateNormal];
    [item setTitlePositionAdjustment:UIOffsetMake(0, -10)];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setChildViewController];
}

- (void)setChildViewController{
    HomeController *home = [[HomeController alloc]init];
    NavigationController *nav1 = [[NavigationController alloc]initWithRootViewController:home];
    nav1.tabBarItem.title = @"首页";
    [self addChildViewController:nav1];
    
    ScenceController *scence = [[ScenceController alloc]init];
    NavigationController *nav2 = [[NavigationController alloc]initWithRootViewController:scence];
    nav2.tabBarItem.title = @"场景";
    [self addChildViewController:nav2];
    
    SettingController *setting = [[SettingController alloc]init];
    NavigationController *nav3 = [[NavigationController alloc]initWithRootViewController:setting];
    nav3.tabBarItem.title = @"设置";
    [self addChildViewController:nav3];
    
}


@end

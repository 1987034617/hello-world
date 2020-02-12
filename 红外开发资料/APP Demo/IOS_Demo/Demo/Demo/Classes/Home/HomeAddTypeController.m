//
//  HomeAddTypeController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeAddTypeController.h"
#import "HomeDetailController.h"
#import "HomeChooseBrandController.h"

@interface HomeAddTypeController ()
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@end

@implementation HomeAddTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加方式";
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
}


- (void)button1Click:(UIButton *)btn{
    HomeDetailController *detail = [[HomeDetailController alloc]initWithNibName:@"HomeDetailController" bundle:nil];
    detail.hidesBottomBarWhenPushed = YES;
    detail.dict = self.dict;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)button2Click:(UIButton *)btn{
    HomeChooseBrandController *brand = [[HomeChooseBrandController alloc]init];
    brand.hidesBottomBarWhenPushed = YES;
    brand.dict = self.dict;
    [self.navigationController pushViewController:brand animated:YES];
}
- (void)button3Click:(UIButton *)btn{
    
}
- (UIButton *)button1{
    if (!_button1) {
        _button1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.button2.frame), CGRectGetMinY(self.button2.frame) - 130, CGRectGetWidth(self.button2.frame), 60)];
        _button1.backgroundColor = [UIColor whiteColor];
        _button1.layer.cornerRadius = 5;
        _button1.layer.masksToBounds = YES;
        [_button1 setTitle:@"一键智能匹配" forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)button2{
    if (!_button2) {
        _button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width * 0.5 - 75, self.view.height * 0.5 - 30, 150, 60)];
        _button2.backgroundColor = [UIColor whiteColor];
        _button2.layer.cornerRadius = 5;
        _button2.layer.masksToBounds = YES;
        [_button2 setTitle:@"品牌查找" forState:UIControlStateNormal];
        [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button2;
}

- (UIButton *)button3{
    if (!_button3) {
        _button3 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.button2.frame), CGRectGetMaxY(self.button2.frame) + 70, CGRectGetWidth(self.button2.frame), 60)];
        _button3.backgroundColor = [UIColor whiteColor];
        _button3.layer.cornerRadius = 5;
        _button3.layer.masksToBounds = YES;
        [_button3 setTitle:@"型号查找" forState:UIControlStateNormal];
        [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button3 addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button3;
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

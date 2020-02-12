//
//  HomeMatchingController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//
//匹配结果
#import "HomeMatchingController.h"
#import "HomeMatchingCell.h"

@interface HomeMatchingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation HomeMatchingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备详情";
    [self.view addSubview:self.label];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.btn];
    [self loadData];
}

- (void)loadData{
    JYWeak;
    [Networking networkingGET:self.url parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict.allKeys containsObject:@"result"]) {
            NSString *str = dict[@"result"];
//            str = [str stringByReplacingOccurrencesOfString:@"||" withString:@" "];
//            [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString * newString = [str substringWithRange:NSMakeRange(0, [str length] - 2)];
            NSLog(@"%@",newString);
            NSArray *arr = [newString componentsSeparatedByString:@"||"];
            [weakSelf.dataArr addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)btnClick:(UIButton *)btn{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 2;
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeMatchingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeMatchingCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeMatchingCell" owner:nil options:nil]firstObject];
    }
    NSString *str = self.dataArr[indexPath.row];
    NSArray *arr = [str componentsSeparatedByString:@"="];
    cell.label.text = arr[1];
//    NSDictionary *dict = ;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor colorWithRed:111/255.0 green:113/255.0 blue:121/255.0 alpha:1.0];
        _label.text = @"匹配结果";
        _label.frame = CGRectMake(20, 110, self.view.width - 40, 18);
        
    }
    return _label;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.label.frame), CGRectGetMaxY(self.label.frame) + 20, CGRectGetWidth(self.label.frame), self.view.height - CGRectGetMaxY(self.label.frame) - 20 - 70 - 30) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitle:@"开始匹配" forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
        _btn.backgroundColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn.frame = CGRectMake(CGRectGetMinX(self.label.frame), CGRectGetMaxY(self.tableView.frame) + 30, CGRectGetWidth(self.label.frame), 50);
    }
    return _btn;
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

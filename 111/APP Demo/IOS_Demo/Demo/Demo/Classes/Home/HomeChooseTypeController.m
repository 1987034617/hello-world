//
//  HomeChooseTypeController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeChooseTypeController.h"
#import "HomeBrandModel.h"
#import "HomeTVDetailController.h"
#import "HomeAirConditioningController.h"

@interface HomeChooseTypeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation HomeChooseTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择型号";
    [self.view addSubview:self.tableView];
    [self equipmentiOS11With:self.tableView];
//    NSArray *arr = @[@"3M",@"3M-0001",@"3M-0002",@"3M-0003",@"3M-0004",@"3M-0005",@"3M-0006",@"3M-0007",@"3M-0008"];
//    [self.dataArr addObjectsFromArray:arr];
    [self loadData];
}
- (void)loadData{
    JYWeak;
    [Networking networkingGET:[NSString stringWithFormat:@"http://www.huilink.com.cn/dk2018/getmodellist.asp?device_id=%@&brand_id=%@&mac=afc1d387b4ab661d",self.dict[@"id"],self.brandDict[@"id"]] parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject;
        if (arr.count>0) {
            for (NSDictionary *dict in arr) {
                HomeBrandModel *model = [HomeBrandModel mj_objectWithKeyValues:dict];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
    }
    HomeBrandModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = model.bn;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeBrandModel *model = self.dataArr[indexPath.row];
    if ([self.dict[@"id"] isEqualToString:@"1"]) {
        HomeAirConditioningController *air = [[HomeAirConditioningController alloc]init];
        air.dict = self.dict;
        air.typeDict = [model mj_JSONObject];
        air.hidesBottomBarWhenPushed = YES;
        air.isHome = NO;
        air.typeArr = self.dataArr;
        air.currentIndex = indexPath.row;
        [self.navigationController pushViewController:air animated:YES];
    }else{
        HomeTVDetailController *tv = [[HomeTVDetailController alloc]init];
        tv.hidesBottomBarWhenPushed = YES;
        tv.dict = self.dict;
        tv.typeDict = [model mj_JSONObject];
        tv.isHome = NO;
        tv.typeArr = self.dataArr;
        tv.currentIndex = indexPath.row;
        [self.navigationController pushViewController:tv animated:YES];
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, JYSafeAreaTopHeight, self.view.width, self.view.height - JYSafeAreaTopHeight - JYSafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
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

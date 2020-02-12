//
//  HomeChooseBrandController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeChooseBrandController.h"
#import "HomeChooseTypeController.h"
#import "HomeBrandModel.h"

@interface HomeChooseBrandController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HomeChooseBrandController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择品牌";
    [self.view addSubview:self.tableView];
    [self equipmentiOS11With:self.tableView];
//    NSArray *arr = @[@"格力",@"美的",@"海尔",@"奥克斯",@"志高",@"TCL",@"海信",@"科龙",@"长虹"];
//    [self.dataArr addObjectsFromArray:arr];
    [self loadData];
}

- (void)loadData{
    JYWeak;
    [Networking networkingGET:[NSString stringWithFormat:@"http://www.huilink.com.cn/dk2018/getbrandlist.asp?mac=afc1d387b4ab661d&device_id=%@",self.dict[@"id"]] parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *arr = responseObject;
        if (arr.count > 0) {
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
    HomeChooseTypeController *type = [[HomeChooseTypeController alloc]init];
    type.hidesBottomBarWhenPushed = YES;
    type.dict = self.dict;
    type.brandDict = [model mj_JSONObject];
    [self.navigationController pushViewController:type animated:YES];
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

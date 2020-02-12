//
//  HomeCategoryController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeCategoryController.h"
#import "HomeCollectionViewCell.h"
#import "HomeModel.h"
#import "HomeChooseTypeController.h"
#import "HomeAddTypeController.h"
#import "HomeTVDetailController.h"
#import "HomeAirConditioningController.h"

@interface HomeCategoryController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation HomeCategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备分类";
    [self.view addSubview:self.collectionView];
    
//    HomeModel *addModel = [[HomeModel alloc]init];
//    addModel.name = @"icon";
//    addModel.device_name = @"空调";
//    [self.data addObject:addModel];
//    
//    HomeModel *addModel2 = [[HomeModel alloc]init];
//    addModel2.name = @"icon";
//    addModel2.device_name = @"电视";
//    [self.data addObject:addModel2];
//    
//    HomeModel *addModel3 = [[HomeModel alloc]init];
//    addModel3.name = @"icon";
//    addModel3.device_name = @"机顶盒";
//    [self.data addObject:addModel3];
//    
//    HomeModel *addModel4 = [[HomeModel alloc]init];
//    addModel4.name = @"icon";
//    addModel4.device_name = @"DVD";
//    [self.data addObject:addModel4];
//    
//    HomeModel *addModel5 = [[HomeModel alloc]init];
//    addModel5.name = @"icon";
//    addModel5.device_name = @"电风扇";
//    [self.data addObject:addModel5];
//    
//    HomeModel *addModel6 = [[HomeModel alloc]init];
//    addModel6.name = @"icon";
//    addModel6.device_name = @"空气净化器";
//    [self.data addObject:addModel6];
    [self loadData];
}
- (void)loadData{
    JYWeak;
    [Networking networkingPOST:@"http://www.huilink.com.cn/dk2018/getdevicelist.asp" parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *arr = responseObject;
        if (arr.count>0) {
            NSMutableArray *modelArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dict in arr) {
                HomeModel *model = [HomeModel mj_objectWithKeyValues:dict];
                model.name = @"icon";
                [modelArr addObject:model];
                [weakSelf.data addObject:model];
            }
            [weakSelf.collectionView reloadData];
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.data.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *model = self.data[indexPath.item];
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:model.name];
    cell.titleLabel.text = model.device_name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wh = (collectionView.bounds.size.width - 40) / 3.0;
    return CGSizeMake(wh, wh);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *model = self.data[indexPath.item];
//    if (indexPath.row == 0) {
//        HomeAirConditioningController *air = [[HomeAirConditioningController alloc]init];
//        air.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:air animated:YES];
//    }else if (indexPath.row == 1){
//        HomeTVDetailController *tv = [[HomeTVDetailController alloc]init];
//        tv.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:tv animated:YES];
//    }else{
//        NSDictionary *dict = [model mj_JSONObject];
        HomeAddTypeController *type = [[HomeAddTypeController alloc]init];
        type.hidesBottomBarWhenPushed = YES;
        type.dict = [model mj_JSONObject];
        [self.navigationController pushViewController:type animated:YES];
//    }
    
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, JYSafeAreaTopHeight, self.view.bounds.size.width, self.view.bounds.size.height - JYSafeAreaTopHeight) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    }
    return _collectionView;
}
- (NSMutableArray *)data{
    if (!_data) {
        _data = [NSMutableArray arrayWithCapacity:0];
    }
    return _data;
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

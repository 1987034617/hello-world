//
//  HomeController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeController.h"
#import "HomeCollectionViewCell.h"
#import "HomeModel.h"
#import "HomeCategoryController.h"
#import "HomeTVDetailController.h"
#import "HomeAirConditioningController.h"


@interface HomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *data;
@end

@implementation HomeController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.data removeAllObjects];
    NSArray* dirArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* str=dirArr[0];
    NSString *xiaoXiPath =[str stringByAppendingPathComponent:@"arr.plist"];
    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:xiaoXiPath];
    if (dataArray.count>0) {
        for (NSDictionary *dict in dataArray) {
            HomeModel *model = [HomeModel mj_objectWithKeyValues:dict];
            [self.data addObject:model];
        }
    }
    HomeModel *addModel = [[HomeModel alloc]init];
    addModel.name = @"circle";
    addModel.device_name = @"";
    [self.data addObject:addModel];
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的设备";
    [self.view addSubview:self.collectionView];
    [self equipmentiOS11WithCollectionView:self.collectionView];
    
    
    
    
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
    if (indexPath.item == (self.data.count - 1)) {
        HomeCategoryController *category = [[HomeCategoryController alloc]init];
        category.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:category animated:YES];
    }else{
      HomeModel *model = self.data[indexPath.item];
        NSDictionary *dict = @{@"id":model.device_id};
        NSDictionary *typeDict = @{@"id":model.ID};
        if ([model.device_id isEqualToString:@"1"]) {
            HomeAirConditioningController *air = [[HomeAirConditioningController alloc]init];
            air.hidesBottomBarWhenPushed = YES;
            air.isHome = YES;
            air.dict = dict;
            air.typeDict = typeDict;
            [self.navigationController pushViewController:air animated:YES];
            
        }else{
            HomeTVDetailController *tv = [[HomeTVDetailController alloc]init];
            tv.hidesBottomBarWhenPushed = YES;
            tv.isHome = YES;
            tv.dict = dict;
            tv.typeDict = typeDict;
            [self.navigationController pushViewController:tv animated:YES];
        }
    }
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, JYSafeAreaTopHeight, self.view.bounds.size.width, self.view.bounds.size.height - JYSafeAreaTopHeight - JYSafeAreaBarBottomHeight) collectionViewLayout:flow];
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

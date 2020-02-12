//
//  HomeAirConditioningController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeAirConditioningController.h"
#import "HomeTVCell.h"
#import "HomeTVDetailFooterView.h"
#import "HomeAirConditioningHeadView.h"
#import "HomeAirCondiontingValueModel.h"
#import "HomeKeyModel.h"

@interface HomeAirConditioningController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HomeTVDetailFooterViewDelegate>

@property (nonatomic, strong) HomeAirConditioningHeadView *headView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) HomeTVDetailFooterView *footerView;
@end

@implementation HomeAirConditioningController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.headView];
    [self.view addSubview:self.collectionView];
    if (self.isHome==NO) {
        [self.view addSubview:self.footerView];
        self.collectionView.frame = CGRectMake(CGRectGetMinX(self.headView.frame), CGRectGetMaxY(self.headView.frame)+60, CGRectGetWidth(self.headView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.headView.frame) - 60 - JYSafeAreaBottomHeight - 70);
        self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+10, self.view.width, 50);
        [self.footerView.numButton setTitle:[NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.typeArr.count] forState:UIControlStateNormal];
        
    }else{
        CGRectMake(CGRectGetMinX(self.headView.frame), CGRectGetMaxY(self.headView.frame)+60, CGRectGetWidth(self.headView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.headView.frame) - 60 - JYSafeAreaBottomHeight);
    }
    
    [self loadData];
//    [self.data addObjectsFromArray:@[@"电源",@"信号源",@"菜单",@"返回",@"首页",@"静音",@"音量-",@"音量+",@"频道-",@"频道+",@"上",@"下",@"左",@"右"]];
}

- (void)loadData{
    JYWeak;
    [Networking networkingGET:@"http://www.huilink.com.cn/dk2018/keyevent.asp?mac=afc1d387b4ab661d&keyid=0" parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        if (dict) {
            HomeAirCondiontingValueModel *value = [HomeAirCondiontingValueModel mj_objectWithKeyValues:dict];
            if ([value.conoff isEqualToString:@"开"]) {
                weakSelf.headView.modelLabel.text = [NSString stringWithFormat:@"模式：%@",value.cmode];
                weakSelf.headView.fengsuLabel.text = [NSString stringWithFormat:@"风速：%@",value.cwind];
                weakSelf.headView.fengxiangLabel.text = [NSString stringWithFormat:@"风向：%@",value.cwinddir];
                weakSelf.headView.valueLabel.text = [NSString stringWithFormat:@"%@",value.ctemp];
                weakSelf.headView.label.text = @"℃";
            }else{
                weakSelf.headView.modelLabel.text = @"";
                weakSelf.headView.fengsuLabel.text = @"";
                weakSelf.headView.fengxiangLabel.text = @"";
                weakSelf.headView.valueLabel.text = @"";
                weakSelf.headView.label.text = @"";
            }
            
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [Networking networkingGET:[NSString stringWithFormat:@"http://www.huilink.com.cn/dk2018/getkeylist.asp?mac=afc1d387b4ab661d&kfid=%@",self.typeDict[@"id"]] parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        if (dict) {
            HomeKeyModel *keyModel = [HomeKeyModel mj_objectWithKeyValues:dict];
            if (keyModel.keylist.count>0) {
                weakSelf.data = keyModel.keylist;
                [weakSelf.collectionView reloadData];
            }
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
    HomeTVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeTVCell" forIndexPath:indexPath];
    cell.label.text = self.data[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wh = (collectionView.bounds.size.width - 25) / 4.0;
    return CGSizeMake(wh, 50);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JYWeak;
    [Networking networkingGET:[NSString stringWithFormat:@"http://www.huilink.com.cn/dk2018/keyevent.asp?mac=afc1d387b4ab661d&keyid=%ld",indexPath.row] parameters:nil completedBlock:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dict = responseObject;
        if (dict) {
            HomeAirCondiontingValueModel *value = [HomeAirCondiontingValueModel mj_objectWithKeyValues:dict];
            if ([value.conoff isEqualToString:@"开"]) {
                weakSelf.headView.modelLabel.text = [NSString stringWithFormat:@"模式：%@",value.cmode];
                weakSelf.headView.fengsuLabel.text = [NSString stringWithFormat:@"风速：%@",value.cwind];
                weakSelf.headView.fengxiangLabel.text = [NSString stringWithFormat:@"风向：%@",value.cwinddir];
                weakSelf.headView.valueLabel.text = [NSString stringWithFormat:@"%@",value.ctemp];
                weakSelf.headView.label.text = @"℃";
            }else{
                weakSelf.headView.modelLabel.text = @"";
                weakSelf.headView.fengsuLabel.text = @"";
                weakSelf.headView.fengxiangLabel.text = @"";
                weakSelf.headView.valueLabel.text = @"";
                weakSelf.headView.label.text = @"";
            }
//            [SVProgressHUD showWithStatus:value.irdata];
            [SVProgressHUD showInfoWithStatus:value.irdata];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)homeTVDetilFooterViewPreviousEvent{
    if (self.currentIndex == 0) {
        [SVProgressHUD showInfoWithStatus:@"这已经是第一个了"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        self.currentIndex-=1;
        [self loadData];
    }
    [self.footerView.numButton setTitle:[NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.typeArr.count] forState:UIControlStateNormal];
}
- (void)homeTVDetilFooterViewNextEvent{
    if (self.currentIndex == self.typeArr.count - 1) {
        [SVProgressHUD showInfoWithStatus:@"这已经是最后一个了"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }else{
        self.currentIndex+=1;
        [self loadData];
    }
    [self.footerView.numButton setTitle:[NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.typeArr.count] forState:UIControlStateNormal];
}
- (void)homeTVDetilFooterViewSureEvent{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入设备名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];

    //增加确定按钮；

    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //获取第1个输入框；



        UITextField *userNameTextField = alertController.textFields.firstObject;

        NSLog(@"设备名称 = %@",userNameTextField.text);
        NSArray* dirArr=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* str=dirArr[0];
        NSString *xiaoXiPath =[str stringByAppendingPathComponent:@"arr.plist"];
        NSArray *temp = [[NSArray arrayWithContentsOfFile:xiaoXiPath] mutableCopy];
        NSMutableArray *dataArray = [NSMutableArray array];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSLog(@"路径：%@",xiaoXiPath);
        dict[@"device_id"] = self.dict[@"id"];
        dict[@"id"] = self.typeDict[@"id"];
        dict[@"device_name"] = userNameTextField.text;
        dict[@"name"] = @"icon";
        [dataArray addObject:dict];
        [dataArray addObjectsFromArray:temp];
        [dataArray writeToFile:xiaoXiPath atomically:YES];


    }]];

    //定义第一个输入框；

    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

        textField.placeholder = @"请输入添加设备的名称";

//        textField.secureTextEntry = YES;

    }];



    [self presentViewController:alertController animated:true completion:nil];
}
//- (NSMutableArray *)data{
//    if (!_data) {
//        _data = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _data;
//}
- (HomeAirConditioningHeadView *)headView{
    if (!_headView) {
        _headView = [[[NSBundle mainBundle]loadNibNamed:@"HomeAirConditioningHeadView" owner:nil options:nil]firstObject];
        _headView.frame = CGRectMake(20, JYSafeAreaTopHeight + 60, self.view.width - 40, 150);
    }
    return _headView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing = 5;
        flow.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.headView.frame), CGRectGetMaxY(self.headView.frame)+60, CGRectGetWidth(self.headView.frame), self.view.bounds.size.height - CGRectGetMaxY(self.headView.frame) - 60 - JYSafeAreaTopHeight- JYSafeAreaBottomHeight - 70) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HomeTVCell class] forCellWithReuseIdentifier:@"HomeTVCell"];
    }
    return _collectionView;
}
- (HomeTVDetailFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle]loadNibNamed:@"HomeTVDetailFooterView" owner:nil options:nil]firstObject];
        _footerView.frame = CGRectMake(0, CGRectGetMaxY(self.collectionView.frame)+10, self.view.width, 50);
        _footerView.delegate = self;
    }
    return _footerView;
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

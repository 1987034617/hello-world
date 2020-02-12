//
//  HomeTVDetailController.h
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeTVDetailController : BaseController
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSDictionary *typeDict;
@property (nonatomic, assign) BOOL isHome;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *typeArr;
@end

NS_ASSUME_NONNULL_END

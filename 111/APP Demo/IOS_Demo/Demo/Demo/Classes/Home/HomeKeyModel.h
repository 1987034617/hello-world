//
//  HomeKeyModel.h
//  Demo
//
//  Created by 李静莹 on 2018/12/26.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeKeyModel : NSObject
/***<#name#>*/
@property (nonatomic, strong) NSString *kfid;
/***<#name#>*/
@property (nonatomic, strong) NSString *brand;
/***<#name#>*/
@property (nonatomic, strong) NSArray *keylist;
/***<#name#>*/
@property (nonatomic, strong) NSArray *keyvalue;
@end

NS_ASSUME_NONNULL_END

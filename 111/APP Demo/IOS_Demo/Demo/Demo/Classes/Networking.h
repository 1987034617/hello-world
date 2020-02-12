//
//  Networking.h
//  Philanthropy
//
//  Created by 李静莹 on 2018/8/15.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^CompletedBlock)(NSURLSessionDataTask *task,id responseObject);
typedef void (^FailureBlock)(NSURLSessionDataTask *task, NSError *error);
@interface Networking : NSObject
/**
 post_json 有错误回调
 */
+(NSURLSessionDataTask *)networkingPOST:(NSString *)urlStr parameters:(id)parameters completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock;
/**
 get_json 有错误回调
 */
+(NSURLSessionDataTask *)networkingGET:(NSString *)urlStr parameters:(id)parameters completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock;;
/**
 上传图片_二进制流(单张有错误返回)
 */
+(NSURLSessionDataTask *)NetWorkingUpLoad:(NSString *)urlStr uploadData:(UIImage *)uploadData parameters:(id)parameters uploadName:(NSString *)uploadName completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock;
/**
 上传图片_二进制流(多张有错误返回)
 */
+(NSURLSessionDataTask *)NetWorkingUpLoad:(NSString *)urlStr images:(NSArray *)images parameters:(id)parameters uploadName:(NSString *)uploadName completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock;
@end

//
//  Networking.m
//  Philanthropy
//
//  Created by 李静莹 on 2018/8/15.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "Networking.h"
#import "AFNetworking.h"
@implementation Networking
/**
 post_json 有错误回调
 */
+(NSURLSessionDataTask *)networkingMethod:(NSString *)method url:(NSString *)urlStr parameters:(NSDictionary *)parameters completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock
{
    NSString * parametersStr = nil;
    NSString * url = nil;
    NSMutableURLRequest *request = nil;
    if (parameters)
    {
        NSMutableArray *mutablePairs = [NSMutableArray array];
        for (NSString *key in parameters.allKeys)
        {
            id value = [parameters objectForKey:key];
            [mutablePairs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        parametersStr = [mutablePairs componentsJoinedByString:@"&"];
    }
    
    if ([method isEqualToString:@"GET"])
    {
        if (parametersStr)
        {
            url = [NSString stringWithFormat:@"%@?%@",urlStr,parametersStr];
        }
        else
        {
            url = urlStr;
        }
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    }
    else
    {
        url = urlStr;
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
        request.HTTPBody = [parametersStr dataUsingEncoding:NSUTF8StringEncoding];
        
    }
    request.timeoutInterval = 60;
    [request setHTTPMethod:method];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                      
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                                                    NSLog(@"最初的数值%@====%@",[data mj_JSONString],error);
                                                                          if (data)
                                                                          {
                                                                              NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                                              if (responseObject)
                                                                              {
                                                                                 
                                                                                  if (completedBlock)
                                                                                  {
                                                                                      completedBlock(task,responseObject);
                                                                                  }
                                                                              }
                                                                              else
                                                                              {
                                                                                  
                                                                                  if (failureBlock)
                                                                                  {
                                                                                      NSError *error = [NSError errorWithDomain:@"没有错误，但没有任何数据" code:1990909 userInfo:nil];
                                                                                      failureBlock(task,error);
                                                                                  }
                                                                              }
                                                                              
                                                                          }
                                                                          else
                                                                          {
                                                                              if (failureBlock)
                                                                              {
                                                                                  failureBlock(task,error);
                                                                              }
                                                                        
                                                                          }
                                                                      });
                                                                      
                                                                  }];
    [task resume];
    return task;
}
/**
 post_json 有错误回调
 */
+(NSURLSessionDataTask *)networkingPOST:(NSString *)urlStr parameters:(id)parameters completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock
{
    NSDictionary * dict = [self getParametersWithDict:parameters];
//    NSLog(@"%@",dict);
    NSURLSessionDataTask * task = [self networkingMethod:@"POST" url:urlStr parameters:dict completedBlock:completedBlock failureBlock:failureBlock];
    return task;
}
/**
 get_json 有错误回调
 */
+(NSURLSessionDataTask *)networkingGET:(NSString *)urlStr parameters:(id)parameters completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock
{
    NSDictionary * dict = [self getParametersWithDict:parameters];
    NSURLSessionDataTask * task = [self networkingMethod:@"GET" url:urlStr parameters:dict completedBlock:completedBlock failureBlock:failureBlock];
    return task;
}

//上传单张图片（有错误返回）
+(NSURLSessionDataTask *)NetWorkingUpLoad:(NSString *)urlStr uploadData:(UIImage *)uploadData parameters:(id)parameters uploadName:(NSString *)uploadName completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock
{
     NSDictionary * body = parameters;
//    NSLog(@"%@",body);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         
                                                         
                                                         @"text/html",
                                                         
                                                         
                                                         
                                                         @"image/jpeg",
                                                         
                                                         
                                                         
                                                         @"image/png",
                                                         
                                                         
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         
                                                         
                                                         @"text/json", nil];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:body headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadData, 0.5) name:uploadName fileName:[NSString stringWithFormat:@"%@.png",uploadName] mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if (completedBlock) {
            completedBlock(task,dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(task,error);
        }
    }];
    //方法弃用
//    NSURLSessionDataTask *task = [manager POST:urlStr parameters:body constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadData, 0.5) name:uploadName fileName:[NSString stringWithFormat:@"%@.png",uploadName] mimeType:@"image/png"];
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if (completedBlock) {
//            completedBlock(dic);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (failureBlock) {
//            failureBlock(error);
//        }
//    }];
    return task;
}

+(NSURLSessionDataTask *)NetWorkingUpLoad:(NSString *)urlStr images:(NSArray *)images parameters:(id)parameters uploadName:(NSString *)uploadName completedBlock:(CompletedBlock)completedBlock failureBlock:(FailureBlock)failureBlock
{
    NSDictionary * body = parameters;
     NSLog(@"%@",body);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         
                                                         
                                                         
                                                         @"text/html",
                                                         
                                                         
                                                         
                                                         @"image/jpeg",
                                                         
                                                         
                                                         
                                                         @"image/png",
                                                         
                                                         
                                                         
                                                         @"application/octet-stream",
                                                         
                                                         
                                                         
                                                         @"text/json", nil];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:body constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        for (int i=0; i < images.count; i++) {
            NSData *image = UIImageJPEGRepresentation(images[i], 0.5);
            NSString *imageName = [NSString stringWithFormat:@"%@%i", uploadName, i+1];
//            NSLog(@"%@=====图片二进制%@",imageName,image);
            [formData appendPartWithFileData:image name:imageName fileName:[NSString stringWithFormat:@"%@%d.png",imageName,i] mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"上传多张图片最初返回的数据%@",dic);
        if (completedBlock) {
            completedBlock(task,dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        if (failureBlock) {
            failureBlock(task,error);
        }
    }];
    return task;
}



+(NSDictionary *)getParametersWithDict:(NSDictionary *)dict
{
    NSMutableDictionary * parameters = nil;
    if (dict)
    {
        parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    }
    else
    {
        parameters = [NSMutableDictionary dictionary];
    }
    return parameters;
}

@end

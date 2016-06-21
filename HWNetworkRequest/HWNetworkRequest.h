//
//  HWNetworkRequest.h
//  HWNetworkRequest
//
//  Created by HuangWay on 15/11/24.
//  Copyright © 2015年 HuangWay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class HWFileConfig;
/**
 *  请求成功的回调
 *
 *  @param responseObject 成功后返回的数据
 */
typedef void(^requestSuccessBlock)(AFHTTPRequestOperation *operation,id responseObject);
/**
 *  请求失败的回调
 *
 *  @param error 失败
 */
typedef void(^requestFalidBlock)(NSError *error,NSString *errorDescription);
/**
 *  响应成功的回调
 *
 *  @param responseObj 返回的数据
 *  @param error       错误
 */
typedef void(^responseBlock)(id responseObj,NSError *error);
/**
 *  监听进度的回调
 *
 *  @param bytesWritten                本次写入的字节
 *  @param totalBytesWritten           当前已经写入的字节
 *  @param totalBytesExpectedToWritten 总共需要写入的字节
 */
typedef void(^progressBlock)(int64_t bytesWritten,int64_t totalBytesWritten,int64_t totalBytesExpectedToWritten);

@interface HWNetworkRequest : NSObject
/**
 *  get请求
 */
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFalidBlock)failed;
/**
 *  post请求
 */
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFalidBlock)failed;
/**
 *  delete请求
 */
+ (void)DELETE:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFalidBlock)failed;
/**
 *  监听下载进度
 */
+ (void)downloadRequest:(NSString *)url successProgress:(progressBlock)progress complete:(responseBlock)completion;
/**
 *  监听文件上传进度
 */
+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(HWFileConfig *)fileConfig successProgress:(progressBlock)progress complete:(responseBlock)completion;
@end



/**
 *  文件模型
 */
@interface HWFileConfig:NSObject
/**
 *  文件数据
 */
@property(nonatomic,strong) NSData *fileData;
/**
 *  文件名
 */
@property(nonatomic,copy) NSString *fileName;
/**
 *  文件类型
 */
@property(nonatomic,copy) NSString *mimeType;
/**
 *  服务器接收的参数名
 */
@property(nonatomic,copy) NSString *paramName;

+ (instancetype)hwFileConfigWithhFileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramName:(NSString *)paramName;

- (instancetype)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramName:(NSString *)paramName;
@end


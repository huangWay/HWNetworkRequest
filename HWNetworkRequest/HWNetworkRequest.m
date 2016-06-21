//
//  HWNetworkRequest.m
//  HWNetworkRequest
//
//  Created by HuangWay on 15/11/24.
//  Copyright © 2015年 HuangWay. All rights reserved.
//

#import "HWNetworkRequest.h"


@interface HWNetworkRequest()
@end

@implementation HWNetworkRequest

+ (AFHTTPRequestOperationManager *)standardManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/javascript",@"application/json",@"text/json",@"image/png", nil]];
    return manager;
}
//get请求
+ (void)GET:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFalidBlock)failed {
    if (![self networkStatus]) {
        !success?:success(nil,nil);
        !failed?:failed(nil,nil);
        return;
    }
    AFHTTPRequestOperationManager *manager = [self standardManager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"lai kankan : %@,%@",operation.request,operation.responseData);
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (failed) {
            failed(error,result);
        }
    }];
}
//post请求
+ (void)POST:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFalidBlock)failed {
    if (![self networkStatus]) {
        !success?:success(nil,nil);
        !failed?:failed(nil,nil);
        return;
    }
    AFHTTPRequestOperationManager *manager = [self standardManager];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (failed) {
            failed(error,result);
        }
    }];
}
//delete请求
+ (void)DELETE:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)success failure:(requestFalidBlock)failed {
    if (![self networkStatus]) {
        !success?:success(nil,nil);
        !failed?:failed(nil,nil);
        return;
    }
    AFHTTPRequestOperationManager *manager = [self standardManager];
    [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *result =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (failed) {
            failed(error,result);
        }
    }];
}
//监听下载进度
+ (void)downloadRequest:(NSString *)url successProgress:(progressBlock)progress complete:(responseBlock)completion {
    if (![self networkStatus]) {
        !progress?:progress(0,0,0);
        !completion?:completion(nil,nil);
        return;
    }
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:sessionConfig];
    NSProgress *taskProgress = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:&taskProgress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentUrl = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (completion) {
            completion(response,error);
        }
    }];
    [sessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if (progress) {
            progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    [downloadTask resume];
}
//监听文件上传进度
+ (void)updateRequest:(NSString *)url params:(NSDictionary *)params fileConfig:(HWFileConfig *)fileConfig successProgress:(progressBlock)progress complete:(responseBlock)completion {
    if (![self networkStatus]) {
        !progress?:progress(0,0,0);
        !completion?:completion(nil,nil);
        return;
    }
    NSURLRequest *urlRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileConfig.fileData name:fileConfig.paramName fileName:fileConfig.fileName mimeType:fileConfig.mimeType];
    } error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlRequest];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progress) {
            progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    [operation start];
}

/**
 *  检查网络是否可用
 */
+ (BOOL)networkStatus {
    __block BOOL netAvailable = YES;
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //只有这个情况是不能用
        if (status == AFNetworkReachabilityStatusNotReachable) {
            netAvailable = NO;
        }
    }];
    [reachabilityManager startMonitoring];
    return netAvailable;
}
@end

@implementation HWFileConfig
+ (instancetype)hwFileConfigWithhFileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramName:(NSString *)paramName {
    return [[self alloc]initWithFileData:fileData fileName:fileName mimeType:mimeType paramName:paramName];
}

- (instancetype)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType paramName:(NSString *)paramName {
    if (self = [super init]) {
        _fileData = fileData;
        _fileName = fileName;
        _mimeType = mimeType;
        _paramName = paramName;
    }
    return self;
}
@end

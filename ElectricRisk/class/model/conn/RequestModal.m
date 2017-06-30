//
//  RequestModal
//
//  Created by temp on 16/4/9.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "RequestModal.h"
#import "MMDesManager.h"

@implementation RequestModal

static NSString *userid;

+(NSString *)curTimeStamp
{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"%lld",(long long)(time*1000000)];
}

+(void)setUserId:(NSString*)userId
{
    userid = userId;
}

+(void)requestServer:(HTTP_METHED) methed Url:(NSString *)path parameter:(NSDictionary *)param  header:(NSDictionary *)headerDic content:(NSString*) content
             success:(void(^)(id responseData)) successBlock failed:(void(^)(id responseData)) failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:SERVER_REQUEST_TIME_OUT];
    
    if([headerDic count])
    {
        NSArray *allKeys = [headerDic allKeys];
        
        for (NSString *key in allKeys)
        {
            [manager.requestSerializer setValue:[headerDic objectForKey:key] forHTTPHeaderField:key];
        }
    }
    // Update Http Header.
//    [manager.requestSerializer  setValue:[NSString stringWithFormat:@"SPEEDCDN=%@",[self curTimeStamp]] forHTTPHeaderField:@"Cookie"];
    
    NSMutableDictionary *paramDic = nil;
    if (param == nil)
    {
        paramDic = [[NSMutableDictionary alloc] init];
    }else{
        paramDic = [[NSMutableDictionary alloc] initWithDictionary:param];
    }
    if (userid != nil && userid.length > 0) [paramDic setObject:userid forKey:@"userid"];
    
    // DES.
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:&err];
    NSString * paramString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    param = @{@"data":[MMDesManager getEncryptWithString:paramString keyString:CodingKey ivString:CodingKey]};
    DLog(@"%@?data=%@",path,[MMDesManager getEncryptWithString:paramString keyString:CodingKey ivString:CodingKey])
    
    // Do POST.
    if(methed == HTTP_METHED_POST)
    {
        [manager POST:path parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            [self responseSuccessHandler:task responseObject:responseObject parameter:param content:content path:path returnBlock:successBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self responseFailureHandler:task andError:error content:content path:path param:param returnBlock:failedBlock];
        }];
    // Do GET.
    }else{
        
        [manager GET:path parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
        {
            [self responseSuccessHandler:task responseObject:responseObject parameter:param content:content path:path returnBlock:successBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self responseFailureHandler:task andError:error content:content path:path param:param returnBlock:failedBlock];
        }];
    }
}

+(void)uploadPhoto:(HTTP_METHED) methed Url:(NSString *)path parameter:(NSData *)imageData success:(void(^)(id responseData)) successBlock failed:(void(^)(id responseData)) failedBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"foo": @"bar"};
    NSURLSessionDataTask *op = [manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:imageData name:@"upfile" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSString  *rsString = [MMDesManager getDecryptWithString:[[NSString alloc] initWithData:(NSData*)(responseObject) encoding:NSUTF8StringEncoding] keyString:CodingKey ivString:CodingKey];
        if(responseObject != nil) successBlock([NSJSONSerialization JSONObjectWithData:[rsString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(nil);
        NSLog(@"Error: %@ *****", error);
    }];
    [op resume];
}

+(void)responseSuccessHandler:(NSURLSessionTask*) operation responseObject:(id) _responseObject parameter:(NSDictionary *)param content:(NSString*) _contentStr path:(NSString*) _path returnBlock:(void(^)(id responseData)) _returnBlock
{
    NSString  *rsString = [MMDesManager getDecryptWithString:[[NSString alloc] initWithData:(NSData*)(_responseObject) encoding:NSUTF8StringEncoding] keyString:CodingKey ivString:CodingKey];
    if(_returnBlock != nil) _returnBlock([NSJSONSerialization JSONObjectWithData:[rsString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
}

+(void)responseFailureHandler:(NSURLSessionTask*) operation andError:(NSError*) error content:(NSString*) _contentStr path:(NSString*) _path param:(NSDictionary*)parameters returnBlock:(void(^)(id responseData)) _returnBlock
{
    if (operation.response != nil)
    {
        DLog(@"访问服务器失败，请稍后重试");
    }else{
        DLog(@"网络不给力，请稍后重试!");
    }
    if(_returnBlock != nil) _returnBlock(nil);
}

@end

//
//  RequestModal
//
//  Created by temp on 16/4/9.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "RequestModal.h"

@implementation RequestModal

+(NSString *)curTimeStamp
{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat:@"%lld",(long long)(time*1000000)];
}

+(void)requestServer:(HTTP_METHED) methed Url:(NSString *)path parameter:(NSDictionary *)param  header:(NSDictionary *)headerDic content:(NSString*) content
             success:(void(^)(id responseData)) successBlock failed:(void(^)(id responseData)) failedBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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
    
    // Do POST.
    if(methed == HTTP_METHED_POST)
    {
        [manager POST:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            [self responseSuccessHandler:operation responseObject:responseObject parameter:param content:content path:path returnBlock:successBlock];
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            [self responseFailureHandler:operation andError:error content:content path:path param:param returnBlock:failedBlock];
        }];
    // Do GET.
    }else{
        
        [manager GET:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self responseSuccessHandler:operation responseObject:responseObject parameter:param content:content path:path returnBlock:successBlock];
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            [self responseFailureHandler:operation andError:error content:content path:path param:param returnBlock:failedBlock];
        }];
    }
}

+(void)responseSuccessHandler:(AFHTTPRequestOperation*) operation responseObject:(id) _responseObject parameter:(NSDictionary *)param content:(NSString*) _contentStr path:(NSString*) _path returnBlock:(void(^)(id responseData)) _returnBlock
{
    if(_returnBlock != nil) _returnBlock(_responseObject);
}

+(void)responseFailureHandler:(AFHTTPRequestOperation*) operation andError:(NSError*) error content:(NSString*) _contentStr path:(NSString*) _path param:(NSDictionary*)parameters returnBlock:(void(^)(id responseData)) _returnBlock
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

//
//  RequestModal
//
//  Created by temp on 16/4/9.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import "RequestModal.h"
#import "GTMBase64.h"

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
    
    // DES.
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&err];
    NSString * paramString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    param = @{@"data":[NSString stringWithFormat:@"{%@}", [self encrypt: paramString]]};
    
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

+ (NSString*)encrypt:(NSString*)plainText {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [CodingKey UTF8String];
//    const void *vinitVec = (const void *) [CodingOffset UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       nil, //vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

@end

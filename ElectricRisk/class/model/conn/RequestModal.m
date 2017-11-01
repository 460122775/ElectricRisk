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
    
    /**************** https协议 *********开始*******/
    [manager setSecurityPolicy:[RequestModal customSecurityPolicy]];
    __weak typeof(self)weakSelf = self;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential =nil;
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if([manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if(credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;
                } else {
                    disposition =NSURLSessionAuthChallengePerformDefaultHandling;
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust = NULL;
            NSString *p12 = [[NSBundle mainBundle] pathForResource:@"client"ofType:@"p12"];
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12])
            {
                NSLog(@"client.p12:not exist");
            } else {
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                
                if ([[weakSelf class] extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data])
                {
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[] = {certificate};
                    CFArrayRef certArray =CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential =[NSURLCredential credentialWithIdentity:identity certificates:nil persistence:NSURLCredentialPersistenceNone];
                    disposition =NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
    /**************** https协议 *********结束*******/
    
    
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
    if ([SystemConfig instance].currentUserToken != nil && [SystemConfig instance].currentUserToken.length > 0)
    {
        [paramDic setObject:[SystemConfig instance].currentUserToken forKey:@"token"];
    }
    
    // DES.
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:0 error:&err];
    NSString * paramString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DLog(@"Json后：data=%@",paramString)
    paramString = [MMDesManager AES128Encrypt:paramString];
    DLog(@"加密后：data=%@",paramString)
    paramString = [RequestModal encodeToPercentEscapeString:paramString];
    DLog(@"转码后：%@?data=%@",path,paramString)
    param = @{@"data":paramString};

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
        NSString  *rsString = [MMDesManager AES128Decrypt:[[NSString alloc] initWithData:(NSData*)(responseObject) encoding:NSUTF8StringEncoding]];
        if(responseObject != nil) successBlock([NSJSONSerialization JSONObjectWithData:[rsString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failedBlock(nil);
        NSLog(@"Error: %@ *****", error);
    }];
    [op resume];
}

+(void)responseSuccessHandler:(NSURLSessionTask*) operation responseObject:(id) _responseObject parameter:(NSDictionary *)param content:(NSString*) _contentStr path:(NSString*) _path returnBlock:(void(^)(id responseData)) _returnBlock
{
    NSString *content = [[NSString alloc] initWithData:(NSData*)(_responseObject) encoding:NSUTF8StringEncoding];
    content = [RequestModal decodeFromPercentEscapeString:content];
    NSString  *rsString = [MMDesManager AES128Decrypt:content];
    if(_returnBlock != nil && rsString != nil) _returnBlock([NSJSONSerialization JSONObjectWithData:[rsString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]);
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

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    if (input == nil || input.length == 0) return @"";
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    if (input == nil || input.length == 0) return @"";
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    NSString *aString = [[NSString alloc] initWithData:certData encoding:NSUTF8StringEncoding];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = @[certData];
    return securityPolicy;
}

+(BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSDictionary*optionsDictionary = [NSDictionary dictionaryWithObject:@"123456"
                                                                 forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDictionary,&items);
    
    if(securityError == 0)
    {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity =NULL;
        tempIdentity= CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void*tempTrust =NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

@end

//
//  RequestModal
//
//  Created by temp on 16/4/9.
//  Copyright © 2016年 Mason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define SERVER_REQUEST_TIME_OUT (30)

typedef enum
{
    HTTP_METHED_POST,
    HTTP_METHED_GET
} HTTP_METHED;

@interface RequestModal : NSObject

//@property(nonatomic,strong) NSString * code;
//@property(nonatomic,strong) NSString *errorMessage;
//@property(nonatomic,assign) int errorCount;
//@property(nonatomic,strong) NSString  *requestUrl;
//@property(nonatomic,strong) NSString  *content;

+(void)requestServer:(HTTP_METHED) methed Url:(NSString *)path parameter:(NSDictionary *)param  header:(NSDictionary *)headerDic content:(NSString*) content
             success:(void(^)(id responseData)) successBlock failed:(void(^)(id responseData)) failedBlock;



@end

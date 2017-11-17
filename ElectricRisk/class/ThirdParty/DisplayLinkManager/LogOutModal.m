//
//  LogOutModal.m
//  ElectricRisk
//
//  Created by 魏翔 on 2017/11/17.
//  Copyright © 2017年 com.yasin.electric. All rights reserved.
//

#import "LogOutModal.h"
#import "SystemConfig.h"

@implementation LogOutModal

+(void)logOut
{
    //设置登录参数
    if ([SystemConfig instance].currentUserToken != nil && [SystemConfig instance].currentUserToken.length > 0)
    {
        NSDictionary *paramDic = @{@"token": [SystemConfig instance].currentUserToken};
        //设置请求
        [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_LOGIN_OUT) parameter:paramDic header:nil content:nil success:^(id responseData) {
            NSDictionary *result = responseData;
            int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
            // Pwd right.
            if (state == State_Success)
            {
                NSLog(@"退出成功");
            }else{
                NSLog(@"退出失败");
            }
        } failed:^(id responseData) {
            [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }];
    }
    [self clearUserData];
}

+(void)clearUserData
{
    [SystemConfig instance].currentUserId = nil;
    [SystemConfig instance].currentUserPwd = nil;
    [SystemConfig instance].currentUserName = nil;
    [SystemConfig instance].currentUserToken = nil;//新添加
    [SystemConfig instance].currentUserRole = -1;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserRole"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserPwd"];
}

@end

//
//  CommonDefine.h
//  ElectricRisk
//
//  Created by Yachen Dai on 8/28/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define URL_SERVER @"http://127.0.0.1:8080/ElectricRisk"
#define SERVER_URL_WITH(PATH) [URL_SERVER stringByAppendingString:PATH]

//密钥
#define CodingKey @"DLJIJIAN"
//偏移量
#define CodingOffset @"01234567"

/**  URL Define **/
#define PATH_LOGIN @"/api/login/login.do"           //登录
#define PATH_RISK_LIST @"/api/project/getList.do"   //获取今日风险列表
#define PATH_RISK_DETAIL @"/api/project/getOneInfo.do"  //获取风险详情
#define PATH_RISK_DAYINFO @"/api/project/getOneDay.do"  //获取风险天执行情况
#define PATH_RISK_CHECK @"/api/risk/myrisks.do"         //获取风险审批
#define PATH_RISK_VERIFYLIST @"/api/risk/risklistdata.do"//获取风险验收列表
#define PATH_RISK_REPORTDETAIL @"/api/risk/riskap.do"   //获取报审详情
#define PATH_NOTICE_LIST @"/api/notice/getNews.do"      //获取公告列表
#define PATH_NOTICE_ADD @"/api/notice/addNotice.do"     //发布公告
#define PATH_NOTICE_MYLIST @"/api/notice/getList.do"    //获取我的公告
#define PATH_WARN_LSIT @"/api/notice/getwarn.do"        //获取风险提醒列表
#define PATH_PWD_UPDATE @"/api/user/upUpd.do"           //修改密码

#define singleton_interface(className) \
+ (className *)instance;


#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)instance \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif /* CommonDefine_h */

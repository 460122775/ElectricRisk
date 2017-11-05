//
//  CommonDefine.h
//  ElectricRisk
//
//  Created by Yachen Dai on 8/28/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define OFFLINE NO // YES or NO, YES for test.
#define CodingKey @"Cuit#@1234567890"   //密钥
#define CodingOffset @"@23456Ak9012345!"//偏移量

#define CodingKey2 @"Cuit#@ABCDefghjk"   //密钥
#define CodingOffset2 @"@ABCDEA#90abcde!"//偏移量

//#define URL_SERVER @"http://192.168.2.204:8080/jj"
//#define URL_SOCKET @"192.168.2.204"

#define URL_SERVER @"https://sctxy.kmdns.net:1112/jj"
#define URL_SOCKET @"https://sctxy.kmdns.net"

#define PORT_SOCKET 3322

#define SERVER_URL_WITH(PATH) [URL_SERVER stringByAppendingString:PATH]

/**  URL Define **/
#define PATH_LOGIN @"/api/login/login.do"               //登录
#define PATH_RISK_LIST @"/api/project/getList.do"       //获取今日风险列表
#define PATH_RISK_STATISTICS @"/api/risk/countrisk.do"  //获取风险统计
#define PATH_RISK_DETAIL @"/api/project/getOneInfo.do"  //获取风险详情
#define PATH_RISK_DAYINFO @"/api/project/getOneDay.do"  //获取风险天执行情况
#define PATH_RISK_ADD @"/api/risk/riskfilladd.do"       //风险实施填报
#define PATH_RISK_UPDATESTATE @"/api/project/updateState.do"  //控制施工停止、启动
#define PATH_RISK_WRONG @"/api/project/getriskDeal.do"  //获取违章列表
#define PATH_RISK_UPLOADIMG @"/api/risk/imageUP.do"     //上传图片
//#define PATH_RISK_UPLOADIMG @"/project/imageUP.do"     //上传图片
#define PATH_RISK_CHECKLIST @"/api/risk/myrisks.do"     //获取风险审批
#define PATH_RISK_VERIFYLIST @"/api/risk/risklistdata.do"//获取风险验收列表
#define PATH_RISK_REPORTDETAIL @"/api/risk/riskap.do"   //获取报审详情
#define PATH_RISK_REPORTOPERATE @"/api/risk/riskacess.do"//报审操作
#define PATH_NOTICE_LIST @"/api/notice/getNews.do"      //获取公告列表
#define PATH_NOTICE_COMMENT @"/api/project/reply.do"    //回复公告
#define PATH_NOTICE_COMMENT_LIST @"/api/project/replyList.do"//获取公告回复
#define PATH_NOTICE_READ @"/api/notice/viewmsg.do"      //消息状态已读
#define PATH_NOTICE_ADD @"/api/notice/addNotice.do"     //发布公告
#define PATH_NOTICE_MYLIST @"/api/notice/getList.do"    //获取我的公告
#define PATH_WARN_LSIT @"/api/notice/getwarn.do"        //获取风险提醒列表
#define PATH_WARN_PUBLISH @"/api/risk/approvalPub.do"   //发布公告
#define PATH_WARN_MODIFY @"/api/risk/updaterisk.do "    //风险修改
#define PATH_PWD_UPDATE @"/api/user/upUpd.do"           //修改密码
#define PATH_APP_UPDATE @"/api/login/version.do"        //更新APP

/**  Color Define **/
#define Color_THEME [UIColor colorWithRed:5/255.0 green:128/255.0 blue:107/255.0 alpha:1]
#define Color_oneGrade [UIColor colorWithRed:92/255.0 green:172/255.0 blue:238/255.0 alpha:1]
#define Color_twoGrade [UIColor colorWithRed:255/255.0 green:185/255.0 blue:15/255.0 alpha:1]
#define Color_threeGrade [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1]
#define Color_fourGrade [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1]
#define Color_fiveGrade [UIColor colorWithRed:255/255.0 green:48/255.0 blue:48/255.0 alpha:1]
#define Color_press [UIColor colorWithRed:5/255.0 green:128/255.0 blue:107/255.0 alpha:1]
#define Color_gray [UIColor colorWithRed:85/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define Color_gray1 [UIColor colorWithRed:33/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define Color_white [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define Color_black [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define Color_red [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define Color_me [UIColor colorWithRed:30/255.0 green:158/255.0 blue:133/255.0 alpha:1]
#define Color_border [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05]

/** Size Define **/
#define ScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

/** Notification Name Define **/
#define ReceiveNotificationFromSocket @"ReceiveNotificationFromSocket"
#define LoginTimeOutNotification      @"LoginTimeOutNotification"
#define InputPwdNotification          @"InputPwdNotification"

/** time cache*/
#define CACHETIME   @"CACHETIME"
//#define LoginTimeOutTime 108000 //30分钟 按照屏幕刷新帧率来计算 1s = 60帧
#define LoginTimeOutTime 18000 //5分钟测试

/** Define operation **/
#define State_Success 1
#define State_Fault 0

#define ROLE_1 1 // b/e/g       省公司管理员
#define ROLE_2 2 // b/g         省公司
#define ROLE_3 3 //	b/g         建管单位
#define ROLE_4 4 //	a/b/d/g/h	业主
#define ROLE_5 5 //	a/c/g/h     监理
#define ROLE_6 6 //	a/g/h       施工
#define ROLE_7 7 //	--          普通用户
#define ROLE_8 8 //	a/b/j/f/g/i	建管单位安全专责
#define ROLE_A 99 //	全部

/** Define result for check & verify **/
#define Rish_PUBLISHSTATE_PUBLISH 3
#define Rish_PUBLISHSTATE_REVOKE 4

/** Check State **/
#define Check_State_None 0
#define Check_State_Wait 1
#define Check_State_No 2
#define Check_State_Yes 3
#define Check_State_Publish4 4
#define Check_State_Publish5 5
#define Check_State_Publish7 7
#define Check_State_Publish8 8

/** Active State **/
#define Active_State_Stop 0
#define Active_State_Normal 1

/** Notice State **/
#define Notice_State_Not 0
#define Notice_State_Read 1
#define Notice_State_Reply 2

/** Define type for check & verify **/
#define TYPE_CHECK 0
#define TYPE_VERIFY 1

/** Define result for check & verify **/
#define CHECKSTATE_DISAGREE 1
#define CHECKSTATE_AGREE 2

/** Define singleton **/
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

/** Define DLog **/
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#endif /* CommonDefine_h */

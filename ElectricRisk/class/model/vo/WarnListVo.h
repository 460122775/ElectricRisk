//
//  WarnListVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarnListVo : NSObject

@property(nonatomic, strong) NSString* content;
@property(nonatomic, assign) int creat_time;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) int state;
@property(nonatomic, assign) int noticeMyListId;
@property(nonatomic, strong) NSString* title;

@property(nonatomic, strong) NSString* address;
@property(nonatomic, strong) NSString* plan_end_time;
@property(nonatomic, strong) NSString* real_start_tim;
@property(nonatomic, strong) NSString* real_end_time;
@property(nonatomic, strong) NSString* plan_start_time;
@property(nonatomic, assign) int project_id;

//{
//    "content": "内容",
//    "creat_time": 1237892000,
//    "name": "姓名",
//    "state": 1,
//    "id": 1,
//    "title": "标题",
//    "address": "项目的地质",
//    "plan_end_time": "计划结束时间",
//    "real_start_tim": "实际开始时间",
//    "real_end_time": "实际结束时间",
//    "plan_start_time": "计划开始时间",
//    "project_id": 11//项目id
//}

@end

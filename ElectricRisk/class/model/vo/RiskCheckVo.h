//
//  RiskCheckVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskCheckVo : NSObject

@property(nonatomic, strong) NSString* project_name;
@property(nonatomic, strong) NSString* user_nickname;
@property(nonatomic, strong) NSString* approval_state;
@property(nonatomic, assign) int approval_time;
@property(nonatomic, assign) int riskCheckId;

//{
//    "project_name": "报审标题",
//    "approval_time": 1237892000,
//    "user_nickname": "姓名",
//    "approval_state": 1,//报审状态
//    "id": 1
//}
//case 1: "待审核";
//case 2: "已驳回";
//case 3: "已审核";
//case 4: "已发布";


@end

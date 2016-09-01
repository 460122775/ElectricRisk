//
//  RiskDetailVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskDetailVo : NSObject

@property(nonatomic, assign) int state;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* address;
@property(nonatomic, assign) int real_end_time;
@property(nonatomic, assign) int plan_end_time;

//{
//    "state": 1,
//    "data": {
//        "name": "name",//风险名称
//        "address": "address",//风险地址
//        "real_end_time": 234567812000,//计划开始时间
//        "plan_end_time": 1237892000//计划结束时间
//    }
//}


@end

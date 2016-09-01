//
//  RiskReportDetailVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskReportDetailVo : NSObject

@property(nonatomic, assign) int sp_state;
@property(nonatomic, assign) int bslc;

@property(nonatomic, assign) int jl_yj;
@property(nonatomic, strong) NSString* jl_content;
@property(nonatomic, strong) NSString* jl_name;
@property(nonatomic, assign) int jl_time;
@property(nonatomic, assign) int yz_yj;
@property(nonatomic, strong) NSString* yz_content;
@property(nonatomic, strong) NSString* yz_name;
@property(nonatomic, assign) int yz_time;

@property(nonatomic, assign) int create_time;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* project_name;
@property(nonatomic, strong) NSString* code;
@property(nonatomic, strong) NSString* name;

//{
//    "sp_state": 0,//报审状态 ，是否显示审批操作，1显示0不显示
//    "bslc": 0,//报审流程  1监理 2业主 3 结束
//    "spxx": {
//        "jl_yj": 0,//监理意见  2同意 1不同意 0该流程不存在
//        "jl_content": "监理内容",
//        "jl_name": "意见姓名",
//        "jl_time": 1237892000,
//        "yz_yj":0,//业主意见
//        "yz_content": "业主内容",
//        "yz_name": "业主姓名",
//        "yz_time": 1237892000
//    },
//    "bsxx": {
//        "create_time": 124567210000,
//        "content": "报审内容",
//        "project_name": "项目名称",
//        "code": "项目编号",
//        "name": "报审人姓名"
//    }
//}

@end

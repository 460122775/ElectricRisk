//
//  RiskDayInfoVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskDayInfoVo : NSObject


@property(nonatomic, strong) NSString* lllegal_1;
@property(nonatomic, strong) NSString* yzOnWork;
@property(nonatomic, strong) NSString* jlOnWork;
@property(nonatomic, strong) NSString* sgOnWork;
@property(nonatomic, assign) int progressValue;
@property(nonatomic, strong) NSString* progress;
@property(nonatomic, strong) NSString* working;

//{
//    "riskfill": {
//        "lllegal_1": "name",//违章情况
//        "yzOnWork": "address",//人员到岗信息
//        "jlOnWork": "address",//人员到岗信息
//        "sgOnWork": "address",//人员到岗信息
//        "progressValue": 50,//进度
//        "progress": "",//进度内容
//        "working": ""//现场情况
//    }
//}


@end

//
//  RiskListVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskListVo : NSObject

@property(nonatomic, assign) int grade;         //风险等级
@property(nonatomic, strong) NSString* title;   //风险标题
@property(nonatomic, strong) NSString* address; //风险地址
@property(nonatomic, strong) NSString* content; //风险内容
@property(nonatomic, assign) int schedule;      //风险进度
@property(nonatomic, assign) int time;  //时间，这个是时间戳，需要转换，所有的时间都为时间戳
@property(nonatomic, assign) int riskListId;    //风险id ============> "id"

//{
//    "grade": 1,//风险等级
//    "content": {
//        "title": "title",//风险标题
//        "address": "address",//风险地址
//        "content": "content",//风险内容
//        "schedule": 1,//风险进度
//        "time": 13543035405000,//时间，这个是时间戳，需要转换，所有的时间都为时间戳
//        "id": 1//风险id
//    }
//}

@end

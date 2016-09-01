//
//  RiskVerifyListVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RiskVerifyListVo : NSObject

@property(nonatomic, strong) NSString* content;
@property(nonatomic, assign) int create_time;
@property(nonatomic, strong) NSString* user_nickname;
@property(nonatomic, assign) int approval_state;
@property(nonatomic, assign) int verifyListId;
@property(nonatomic, strong) NSString* name;

//{
//    "content": "报审标题",
//    "create_time": 1237892000,
//    "user_nickname": "姓名",
//    "approval_state": 1,//报审状态,同上
//    "id": 1,
//    "name":"项目名称"
//}


@end

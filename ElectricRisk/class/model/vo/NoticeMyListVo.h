//
//  NoticeMyListVo.h
//  ElectricRisk
//
//  Created by Yachen Dai on 9/1/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeMyListVo : NSObject

@property(nonatomic, strong) NSString* content;
@property(nonatomic, assign) int creat_time;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, assign) int state;
@property(nonatomic, assign) int noticeMyListId;
@property(nonatomic, strong) NSString* title;

//{
//    "content": "报审标题",
//    "creat_time": 1237892000,
//    "name": "姓名",
//    "state": 1,//状态 0未读 1已读 2已回复
//    "id": 1,
//    "title": "项目名称"
//}

@end

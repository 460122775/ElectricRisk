//
//  SystemConfig.h
//  ElectricRisk
//
//  Created by Yachen Dai on 8/28/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfig : NSObject

singleton_interface(SystemConfig)

@property(nonatomic, strong) NSString* currentUserName;
@property(nonatomic, strong) NSString* currentUserPwd;
@property(nonatomic, assign) int currentUserRole;
@property(nonatomic, strong) NSString* currentUserId;

@end

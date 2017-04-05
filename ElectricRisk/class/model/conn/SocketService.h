//
//  SocketService.h
//  ElectricRisk
//
//  Created by yasin zhang on 2017/4/5.
//  Copyright © 2017年 com.yasin.electric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h" // for TCP

typedef void (^ IteratorSocketBlock)(id receiveData);

@interface SocketService : NSObject<GCDAsyncSocketDelegate>{
    GCDAsyncSocket  *socket;
}

@property (nonatomic, copy) IteratorSocketBlock receiveBlock;
@property (nonatomic, strong) NSDictionary *dataDic;

singleton_interface(SocketService)

@end

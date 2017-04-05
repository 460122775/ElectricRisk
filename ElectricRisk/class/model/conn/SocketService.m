//
//  SocketService.m
//  ElectricRisk
//
//  Created by yasin zhang on 2017/4/5.
//  Copyright © 2017年 com.yasin.electric. All rights reserved.
//

#import "SocketService.h"
#import "AppDelegate.h"

@implementation SocketService

singleton_implementation(SocketService)

- (instancetype)init
{
    self = [super init];
    if (self) {
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSError *err;
        [socket connectToHost:URL_SOCKET onPort:PORT_SOCKET error:&err];
        if (err != nil)
        {
            NSLog(@"%@",err);
        }
    }
    return self;
}

// 如果对象关闭了 这里也会调用
- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err
{
    //断线重连
    [socket connectToHost:URL_SOCKET onPort:PORT_SOCKET error:&err];
    DLog(@"=========== SOCKET CLOSE.")
}

//该方法会立刻返回,当成功连接上，delegate 的 socket:didConnectToHost:port: 方法会被调用.
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Cool, I'm connected! That was easy.");
    [socket readDataWithTimeout:-1 tag:1];
}

//当数据发送成功的话也会回调GCDAsyncSocketDelegate里面的方法：这个的话就可以选择性重发数据
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"---发送数据的 tag---%ld",tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    DLog(@"===========READ DATA.")
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&error];
    self.dataDic = [jsonDic objectForKey:@"xmlMsg"];
    NSLog(@"json: %@", jsonDic);
//    self.receiveBlock(self.dataDic);
    [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveNotificationFromSocket object:nil];
}

@end

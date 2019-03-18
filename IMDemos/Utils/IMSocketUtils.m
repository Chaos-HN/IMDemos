//
//  IMSocketUtils.m
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "IMSocketUtils.h"
#import "IMChatModel.h"

@import SocketIO;

@interface IMSocketUtils ()

@property (nonatomic, strong) SocketIOClient *sockets;
@property (nonatomic, strong) SocketManager *socketManager;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation IMSocketUtils

+ (instancetype)sharedManager {
    static IMSocketUtils *socketUtils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socketUtils = [[IMSocketUtils alloc] init];
    });
    return socketUtils;
}

- (void)getIMServer
{
    self.dataArr = [NSMutableArray array];

    NSString *queryImServer = @"/im/queryImServer.do";
    HttpUtils *httpUtil = [[HttpUtils alloc] init];
    [httpUtil request:post withUrlAPI:[self getURLWithToken:queryImServer] andParams:@{} resultBlock:^(ResultStatus status, id  _Nonnull result) {
        if (status == RS_SUCCEED) {
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSString *rspCode = [resultDic getString:@"rspCode"];
            
            if ([rspCode isEqualToString:@"0"]) {
                NSLog(@"获取IMServer成功");
                NSString *host = [NSString stringWithFormat:@"%@",resultDic[@"data"][@"host"]];
                NSString *imServerStr;
                if ([host containsString:@"https"]) {
                    imServerStr = host;
                } else {
                    imServerStr = [NSString stringWithFormat:@"http://%@",host];
                }
                [self connectToServer:imServerStr];
            }
        }
    }];
}

// socket链接
- (void)connectToServer:(NSString *)imServerStr
{
    NSURL *url = [NSURL URLWithString:imServerStr];
    NSDictionary *configs = @{@"log": @YES, @"compress": @NO, @"reconnectAttempts":@(-1), @"reconnectWait" : @4};
    self.socketManager = [[SocketManager alloc] initWithSocketURL:url config:configs];
    self.sockets = self.socketManager.defaultSocket;
    
    // 连接超时时间设置为15秒
    [self.sockets connectWithTimeoutAfter:15 withHandler:^{
         NSLog(@"链接超时");
    }];
    
    [self.sockets on:@"connect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"链接成功===:%@",data);
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *dictss = @{@"datas":data};
        [center postNotificationName:@"logCenter" object:@"链接成功" userInfo:dictss];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tokenStr = [defaults objectForKey:@"tokenStr"];
        NSDictionary *dict = @{@"token":tokenStr};
        NSString *jsonStr = [StringUtils convertToJsonData:dict];
        [self.sockets emit:@"register" with:@[jsonStr]];
    }];
    [self socketsWorks];
    [self.sockets connect];
}

- (void)socketsWorks
{
    // 状态改变
    [self.sockets on:@"statusChange" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"状态改变===:%@",data);
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *dict = @{@"datas":data};
        [center postNotificationName:@"logCenter" object:@"状态改变" userInfo:dict];
    }];
    
    // 注册
    [self.sockets on:@"register_ack" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSDictionary *dict = @{@"datas":data};
        NSString *titleStr = @"注册";
        NSString *code = [data[0] getString:@"code"];
        if ([code integerValue]==0) {
            titleStr = @"注册成功";
        } else {
            titleStr = @"注册失败";
        }
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"logCenter" object:titleStr userInfo:dict];
    }];
    
    // 链接失败
    [self.sockets on:@"error" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSDictionary *dict = @{@"datas":data};
        NSString *titleStr = @"链接失败";
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"logCenter" object:titleStr userInfo:dict];
    }];
    
    // 重新连接
    [self.sockets on:@"reconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"重新连接===:%@",data);
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *dict = @{@"datas":data};
        [center postNotificationName:@"logCenter" object:@"重新连接" userInfo:dict];
    }];
    
    // 断开连接
    [self.sockets on:@"disconnect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"断开连接===:%@",data);
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *dict = @{@"datas":data};
        [center postNotificationName:@"logCenter" object:@"断开连接" userInfo:dict];
    }];
    
    // 对方发送
    [self.sockets on:@"communicate" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSString *code = [data[0] getString:@"code"];
        NSDictionary *dict = @{@"datas":data};
        NSString *titleStr = @"对方发送";
        if ([code integerValue]==0) {
            titleStr = @"对方发送的";
            [self communicate:data[0]];
        } else {
            titleStr = @"对方发送失败";
        }
        NSLog(@"对方发送===:%@",data);
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"logCenter" object:titleStr userInfo:dict];
    }];
    
    // 发送方
    [self.sockets on:@"communicate_ack" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSString *code = [data[0] getString:@"code"];
        NSDictionary *dict = @{@"datas":data};
        NSString *titleStr = @"发送";
        if ([code integerValue]==0) {
            titleStr = @"发送成功";
        } else {
            titleStr = @"发送失败";
        }
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:@"logCenter" object:titleStr userInfo:dict];
    }];
    
    // 发送方是否已读
    [self.sockets on:@"readedMsg" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        NSLog(@"是否已读===:%@",data);
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSDictionary *dict = @{@"datas":data};
        [center postNotificationName:@"logCenter" object:@"已读" userInfo:dict];
    }];
}

// 发送消息
- (void)sendMessages:(IMChatModel *)chatModel andBlock:(SendBlock)sendBlock
{
    self.sendBlock = sendBlock;
    NSDictionary *params = @{@"msg":chatModel.msg,@"clientMsgId":chatModel.clientMsgId,@"receiverId":chatModel.receiverId,@"senderName":chatModel.senderName,@"messageContentTypeCd":chatModel.messageContentTypeCd};
    NSString *jsonStr = [StringUtils convertToJsonData:params];
    [self.sockets emit:@"communicate" with:@[jsonStr]];
    if (self.sendBlock) {
        self.sendBlock(params);
    }
}

// socket断开链接
- (void)cutOffSocket
{
    [self.sockets disconnect];
}

// socket重新链接
- (void)reconnectToServer
{
    if (self.sockets) {
        [self.sockets disconnect];
    }
    [self.sockets connect];
}

- (NSString *)getURLWithToken:(NSString *)api
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenStr = [defaults objectForKey:@"tokenStr"];
    NSString *companyIds = [defaults objectForKey:@"companyIdStr"];
    
    if (![StringUtils isNUllOrEmpty:tokenStr]) {
        api = [api stringByAppendingString:@"?"];
        api = [api stringByAppendingString:@"token="];
        api = [api stringByAppendingString:tokenStr];
    }
    if ([companyIds integerValue] > 0) {
        api = [api stringByAppendingString:@"&COMPANYID="];
        api = [api stringByAppendingString:companyIds];
    }else{
        api = [api stringByAppendingString:@"&COMPANYID=0"];
    }
    return api;
}

- (void)communicate:(NSDictionary *)data
{
    NSString *msg = data[@"msg"];
    //推送
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rceMsg" object:msg userInfo:nil];
}

@end

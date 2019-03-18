//
//  HttpUtils.h
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define TimeoutInterval 20

typedef enum {
    post,
    get,
} RequestType;

typedef enum {
    RS_SUCCEED = 0,                //结果正常
    RS_FAILED,                     //操作失败
    RS_ERR_UNKNOW,                 //未知错误
    RS_ERR_ANALYSIS,               //解析错误
    RS_ERR_NETWORK_NOT_CONNECTED,  //网络未连接
    RS_ERR_NETWORK,                //网络错误
    RS_ERR_SERVER,                 //服务器错误
    RS_USER_ACCESS_TOKEN           //账户令牌错误
} ResultStatus;

typedef void (^RequestResultBlock)(ResultStatus status, id result);

@interface HttpUtils : NSObject


- (void)request:(RequestType)type withUrlAPI:(NSString *)urlAPI andParams:(NSDictionary *)params resultBlock:(RequestResultBlock)block;

@end

NS_ASSUME_NONNULL_END

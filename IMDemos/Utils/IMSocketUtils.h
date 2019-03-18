//
//  IMSocketUtils.h
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SendBlock)(NSDictionary *sendDict);

@class IMChatModel;

@interface IMSocketUtils : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, copy) SendBlock sendBlock;

// 获取IM地址
- (void)getIMServer;

// socket链接Server
- (void)connectToServer:(NSString *)imServerStr;

// 发送消息
- (void)sendMessages:(IMChatModel *)chatModel andBlock:(SendBlock)sendBlock;

// socket断开链接
- (void)cutOffSocket;

// socket重新链接
- (void)reconnectToServer;

@end

NS_ASSUME_NONNULL_END

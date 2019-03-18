//
//  IMChatModel.h
//  IMDemos
//
//  Created by oumeng on 2019/3/7.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMChatModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, copy) NSString *clientMsgId;

@property (nonatomic, copy) NSString *receiverId;

@property (nonatomic, copy) NSString *senderName;

@property (nonatomic, copy) NSString *messageContentTypeCd;

@property (nonatomic, copy) NSString *senderPortraitImg;

@property (nonatomic, copy) NSString *senderPortraitImgUrl;

@end

NS_ASSUME_NONNULL_END

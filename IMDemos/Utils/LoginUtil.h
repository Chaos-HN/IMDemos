//
//  LoginUtil.h
//  IMDemos
//
//  Created by oumeng on 2019/3/7.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LoginBlock)(void);

@interface LoginUtil : NSObject


+ (instancetype)sharedManager;

@property (nonatomic, copy) LoginBlock loginBlock;

- (void)loginAgainWithUser:(NSDictionary *)userDict loginBlock:(LoginBlock)loginBlock;

- (void)loginOutBlock:(LoginBlock)loginBlock;

@end

NS_ASSUME_NONNULL_END

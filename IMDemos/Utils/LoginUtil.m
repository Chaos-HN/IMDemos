//
//  LoginUtil.m
//  IMDemos
//
//  Created by oumeng on 2019/3/7.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "LoginUtil.h"

static NSString *kUserNameKey = @"userName";
static NSString *kPasswordKey = @"passWord";
static NSString *kRspCodeKey = @"rspCode";
static NSString *kRspMsgKey = @"rspMsg";
static NSString *kDataKey = @"data";
static NSString *kResultKey = @"result";
static NSString *loginAPI =  @"/main/login.do";
static NSString *logoutAPI = @"/main/logout.do";

@implementation LoginUtil

+ (instancetype)sharedManager {
    static LoginUtil *loginUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginUtil = [[LoginUtil alloc] init];
    });
    return loginUtil;
}

- (void)loginAgainWithUser:(NSDictionary *)userDict loginBlock:(LoginBlock)loginBlock
{
    self.loginBlock = loginBlock;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *nameStr = [userDict getString:@"name"];
    NSString *pwdStr = [userDict getString:@"pwd"];
    [params setObject:nameStr forKey:kUserNameKey];
    [params setObject:pwdStr forKey:kPasswordKey];
    [params setObject:@"0" forKey:@"auto"];
    [params setObject:@"IOS" forKey:@"terminaltype"];
    [params setObject:[nameStr stringByAppendingString:@"simulator"] forKey:@"clientId"];
    HttpUtils *httpUtil = [[HttpUtils alloc] init];
    [httpUtil request:post withUrlAPI:loginAPI andParams:params resultBlock:^(ResultStatus status, id  _Nonnull result) {
        if (status == RS_SUCCEED) {
            NSString *json = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            NSLog(@"登录接口 == %@",json);
            
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *dataDict = [resultDic getDictioary:@"data"];
            NSDictionary *creDict = [dataDict getDictioary:@"credential"];
            NSDictionary *uDict = [dataDict getDictioary:@"userInfo"];
            NSString *rspCode = [resultDic getString:kRspCodeKey];
            if ([rspCode isEqualToString:@"0"]) {
                [self setTokenStr:creDict userInfo:uDict andParams:userDict];
                if (self.loginBlock) {
                    self.loginBlock();
                }
            } else {
                NSLog(@"登录失败了");
            }
        } else {
            NSLog(@"登录失败了");
        }
    }];
}

- (void)loginOutBlock:(LoginBlock)loginBlock
{
    self.loginBlock = loginBlock;
    
    HttpUtils *httpUtil = [[HttpUtils alloc] init];
    [httpUtil request:post withUrlAPI:logoutAPI andParams:@{} resultBlock:^(ResultStatus status, id  _Nonnull result) {
        if (status == RS_SUCCEED) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSInteger rspCode = [resultDic[kRspCodeKey] integerValue];
            
            if (rspCode == 0) {
                if (self.loginBlock) {
                    self.loginBlock();
                }
            } else {
                NSLog(@"退出登录失败");
            }
        } else {
            NSLog(@"退出登录失败");
        }
    }];
}

- (void)setTokenStr:(NSDictionary *)cdict userInfo:(NSDictionary *)udict andParams:(NSDictionary *)params
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[cdict getString:@"token"] forKey:@"tokenStr"];
    [defaults setObject:[udict getString:@"companyId"] forKey:@"companyIdStr"];
    [defaults setObject:[udict getString:@"realName"] forKey:@"userName"];
    [defaults setObject:[udict getString:@"profileId"] forKey:@"profileId"];
    [defaults setObject:[params getString:@"name"] forKey:@"accout"];
    [defaults setObject:[params getString:@"pwd"] forKey:@"pwd"];
    [defaults setObject:@"1" forKey:@"isLogin"];
    [defaults synchronize];
}

@end

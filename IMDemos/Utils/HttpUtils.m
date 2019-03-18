//
//  HttpUtils.m
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "HttpUtils.h"

@interface HttpUtils()

@property(nonatomic, strong) AFHTTPSessionManager *httpsSessionManager;

@end

@implementation HttpUtils

- (void)request:(RequestType)type withUrlAPI:(NSString *)urlAPI andParams:(NSDictionary *)params resultBlock:(RequestResultBlock)block{
    
    if (!params) {
        params = @{};
    }
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenStr = [defaults objectForKey:@"tokenStr"];
    
    if (![StringUtils isNUllOrEmpty:tokenStr]) {
        [newParams setObject:tokenStr forKey:@"token"];
    }

    if (post == type){
        [self dealPostRequest:[self getURL:urlAPI] andParams:newParams resultBlock:(RequestResultBlock)block];
    }
}

- (void)dealPostRequest:(NSString*)url andParams:(NSDictionary*)params resultBlock:(RequestResultBlock)block{
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *companyIDValue = @"";
    for (NSString *key in params) {
        if ([[key uppercaseString] isEqualToString:@"COMPANYID"]) {
            companyIDValue = [params objectForKey:key];
            break;
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *companyIds = [defaults objectForKey:@"companyIdStr"];
    if ([StringUtils isNUllOrEmpty:companyIDValue]) {
        if ([companyIds integerValue] > 0) {
             [newParams setObject:companyIds forKey:@"COMPANYID"];
        } else {
            [newParams setObject:@"0" forKey:@"COMPANYID"];
        }
    } else {
        NSArray *urlStrArr = [url componentsSeparatedByString:@"&"];
        
        NSString *companyIDStr = @"";
        url = @"";
        for (NSString *str in urlStrArr) {
            
            if (![str isEqualToString:urlStrArr.firstObject]) {
                url = [url stringByAppendingString:@"&"];
            }
            
            if ([str rangeOfString:@"COMPANYID"].length > 0) {
                
                NSArray *strArr2 = [str componentsSeparatedByString:@"="];
                
                companyIDStr = [strArr2.firstObject stringByAppendingString:@"="];
                companyIDStr = [companyIDStr stringByAppendingString:companyIds];
                
                url = [url stringByAppendingString:companyIDStr];
            }else{
                
                url = [url stringByAppendingString:str];
            }
        }
        [newParams setObject:companyIds forKey:@"COMPANYID"];
    }
    NSLog(@"网络请求%@ \n %@",url,newParams);
    
    AFHTTPSessionManager *httpsSessionManager = [AFHTTPSessionManager manager];
    
    httpsSessionManager.attemptsToRecreateUploadTasksForBackgroundSessions = YES;
    
    // 2.设置非校验证书模式
    httpsSessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    httpsSessionManager.securityPolicy.allowInvalidCertificates = YES;
    [httpsSessionManager.securityPolicy setValidatesDomainName:NO];
    
    
    //请求设置
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setStringEncoding:NSUTF8StringEncoding];
    requestSerializer.timeoutInterval = TimeoutInterval;
    [requestSerializer setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    httpsSessionManager.requestSerializer= requestSerializer;
    
    //响应设置
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/json;charset=UTF-8",@"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    httpsSessionManager.responseSerializer = responseSerializer;
    
    self.httpsSessionManager = httpsSessionManager;
    
    [httpsSessionManager POST:url parameters:newParams progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![url containsString:@"login.do"] && ![url containsString:@"uploadclientId.do"]) {
            @try {
                block(RS_SUCCEED,responseObject);
            } @catch (NSException *exception) {
                NSLog(@"这里出错了====%@",exception);
            }
            [self cancelRequest];
        } else {
            block(RS_SUCCEED,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        block(RS_ERR_NETWORK,[NSString stringWithFormat:@"网络错误%@",error.description]);
        [self cancelRequest];
    }];
    
}

//取消网络请求
-(void)cancelRequest{
    [self.httpsSessionManager.session invalidateAndCancel];
    self.httpsSessionManager = nil;
}

- (NSString *)getURL:(NSString *)api
{
    NSString *url = [HOSTAPI stringByAppendingString:indexAPI];
    url = [url stringByAppendingString:api];
    return url;
}

@end

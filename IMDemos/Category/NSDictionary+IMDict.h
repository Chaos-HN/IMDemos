//
//  NSDictionary+IMDict.h
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (IMDict)

- (int)getInt:(NSString *)key;
- (NSString *)getString:(NSString *)key;
- (NSNumber *)getNum:(NSString *)key;
- (NSString *)getString:(NSString *)key byDefaultVaule:(NSString *)value;

- (NSArray *)getArray:(NSString *)key;
- (NSMutableArray *)getMuArray:(NSString *)key;

- (NSDictionary *)getDictioary:(NSString *)key;
- (UIView *)getView:(NSString *)key;

- (double)getDouble:(NSString *)key;

- (BOOL)getBoolen:(NSString *)key;

- (NSMutableDictionary *)getMuDictioary:(NSString *)key;

- (void)addDictionary:(NSMutableDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

//
//  StringUtils.h
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringUtils : NSObject

// 判空
+ (BOOL)isNUllOrEmpty:(NSString*)str;

+ (NSString *)convertToJsonData:(id)obj;

//自适应高度
+(CGFloat)adaptionHeightWithLabel:(UILabel*)label AndWidth:(CGFloat)width;

//自适应宽度
+(CGFloat)adaptionWidthWithLabel:(UILabel*)label AndHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END

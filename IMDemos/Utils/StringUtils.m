//
//  StringUtils.m
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

#pragma mark - 字符串判空
+ (BOOL)isNUllOrEmpty:(NSString*)str
{
    if (str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || str.trimWhitespace.length <= 0) {
        return YES;
    } else if ([str isEqualToString:@"<NSNull>"] || [str isEqualToString:@"<null>"] || [str isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)convertToJsonData:(id)obj
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSString *mutStr = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return mutStr;
    
}

//自适应高度
+(CGFloat)adaptionHeightWithLabel:(UILabel*)label AndWidth:(CGFloat)width{
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label.text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.height;
}

//自适应宽度
+(CGFloat)adaptionWidthWithLabel:(UILabel*)label AndHeight:(CGFloat)height
{
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label.text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size.width;
}

@end

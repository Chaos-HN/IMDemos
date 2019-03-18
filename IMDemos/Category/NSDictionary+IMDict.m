//
//  NSDictionary+IMDict.m
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "NSDictionary+IMDict.h"

@implementation NSDictionary (IMDict)

- (NSString *)getString:(NSString*)key
{
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@",obj];
    }
}

- (NSString *)getString:(NSString*)key byDefaultVaule:(NSString *)value
{
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return value;
    } else {
        return [NSString stringWithFormat:@"%@",obj];
    }
}

- (UIView *)getView:(NSString *)key
{
    NSObject *obj = self[key];
    if(obj == nil || [obj isKindOfClass:[NSNull class]]){
        return nil;
    } else {
        return (UIView *)obj;
    }
}

- (int)getInt:(NSString *)key{
    
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return -1;
    } else if([@"<null>" isEqualToString:[self getString:@"key"]]) {
        return -1;
    }
    return [(NSNumber *)obj intValue];
}

- (NSNumber *)getNum:(NSString *)key{
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return 0;
    } else if ([@"<null>" isEqualToString:[self getString:@"key"]]) {
        return 0;
    }
    return (NSNumber *)obj;
}

- (double)getDouble:(NSString *)key{
    
    NSObject *obj = self[key];
    if(obj==nil || [obj isKindOfClass:[NSNull class]]){
        return 0;
    } else if([@"<null>" isEqualToString:[self getString:@"key"]]) {
        return 0;
    }
    return [(NSNumber*)obj doubleValue];
}

- (NSArray *)getArray:(NSString *)key{
    
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        if ([obj isKindOfClass:[NSArray class]]) {
            return (NSArray *)obj;
        } else if([obj isKindOfClass:[NSMutableArray class]]) {
            NSArray *arr = [NSArray arrayWithArray:(NSMutableArray *)obj];
            return arr;
        }else{
            return nil;
        }
    }
}

- (NSMutableArray *)getMuArray:(NSString*)key{
    
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        if ([obj isKindOfClass:[NSArray class]]) {
            return [NSMutableArray arrayWithArray:(NSArray *)obj];
        } else if([obj isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *arr = (NSMutableArray *)obj;
            return arr;
        } else {
            return nil;
        }
    }
}

- (NSDictionary *)getDictioary:(NSString *) key{
    
    NSObject *obj = self[key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return (NSDictionary *)obj;
    }
}

- (NSMutableDictionary *)getMuDictioary:(NSString *)key{
    
    NSObject *obj = self[key];
    NSMutableDictionary *dicts = nil;
    if (obj == nil || [obj isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        if ([obj isKindOfClass:[NSMutableDictionary class]]) {
            dicts= (NSMutableDictionary *)obj;
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            dicts = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)obj];
        }
    }
    return dicts;
}

- (void)addDictionary:(NSMutableDictionary *)dic{
    if (dic) {
        for (NSString* strKey in dic.allKeys) {
            [self setValue:[dic getString:strKey] forKey:strKey];
        }
    }
}

- (BOOL)getBoolen:(NSString *)key
{
    BOOL obj = [[self objectForKey:key] boolValue];
    return obj;
}

@end

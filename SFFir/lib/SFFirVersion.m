//
//  SFFirVersion.m
//  SFFir
//
//  Created by 陈少华 on 15/7/22.
//  Copyright (c) 2015年 sofach. All rights reserved.
//
#import <objc/runtime.h>

#import "SFFirVersion.h"

@implementation SFFirVersion

- (id)initWithDictionary:(id)dic
{
    self = [super init];
    if (self) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
        }
        else
        {
            NSLog(@"error: object init failed, not dictionary");
        }
    }
    return self;
}

- (NSDictionary *)dictionary
{
    return nil;
}

- (Class)classOfPropertyNamed:(NSString*)propertyName
{
    // Get Class of property to be populated.
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    if (!property) {
        return nil;
    }
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0)
    {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}


- (void)setValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSDictionary class]]) {
        Class propertyClass = [self classOfPropertyNamed:key];
        if (propertyClass) {
            [self setValue:[[propertyClass alloc] initWithDictionary:value] forKey:key];
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"warn: key(%@.%@) is not found", NSStringFromClass([self class]), key);
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end

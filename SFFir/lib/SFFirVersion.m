//
//  SFFirVersion.m
//  SFFir
//
//  Created by 陈少华 on 15/7/22.
//  Copyright (c) 2015年 sofach. All rights reserved.
//

#import "SFFirVersion.h"

@implementation SFFirVersion

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end

//
//  SFFirVersion.h
//  SFFir
//
//  Created by 陈少华 on 15/7/22.
//  Copyright (c) 2015年 sofach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFFirVersion : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *changelog;
@property (strong, nonatomic) NSString *versionShort;
@property (strong, nonatomic) NSString *build;
@property (strong, nonatomic) NSString *installUrl;
@property (strong, nonatomic) NSString *install_url;
@property (strong, nonatomic) NSString *update_url;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
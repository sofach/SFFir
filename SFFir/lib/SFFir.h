//
//  SFFir.h
//  SFFir
//
//  Created by 陈少华 on 15/10/22.
//  Copyright © 2015年 sofach. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "SFFirVersion.h"

@class AFHTTPRequestOperation;

/**
 *  这是一个集成fir.im的工具，方便自动更新，之后会加入其他fir的功能
 */
@interface SFFir : NSObject

/**
 *  单例
 *
 *  @return 单例
 */
+ (instancetype)sharedInstence;

/**
 *  自动更新，使用默认的更新方式：当检测到有新版本，弹出alert，告诉版本信息，可以选择更新
 *
 *  @param appid 应用id，可在fir.im的"应用管理"->"基本信息"查看
 *  @param token 用于识别用户身份, api_token 可以在fir.im[用户信息]中生成和刷新
 */
- (void)autoUpdateWithAppId:(NSString *)appid apiToken:(NSString *)token;

/**
 *  自动更新，使用默认的更新方式，可以自己定义alert的样式
 *
 *  @param appid       应用id，可在fir.im的"应用管理"->"基本信息"查看
 *  @param token       用于识别用户身份, api_token 可以在fir.im[用户信息]中生成和刷新
 *  @param alertConfig 用于设置alert的信息
 */
- (void)autoUpdateWithAppId:(NSString *)appid apiToken:(NSString *)token alertConfig:(void(^)(UIAlertView *alert, SFFirVersion *version))alertConfig;

/**
 *  请求最新的版本信息
 *
 *  @param appid   应用id，可在fir.im的"应用管理"->"基本信息"查看
 *  @param token   用于识别用户身份, api_token 可以在fir.im[用户信息]中生成和刷新
 *  @param sucess  成功处理block
 *  @param failure 失败处理block
 *
 *  @return 该请求，可以用来取消
 */
- (AFHTTPRequestOperation *)getLatestVersionWithAppId:(NSString *)appid apiToken:(NSString *)token sucess:(void(^)(SFFirVersion *version))sucess failure:(void(^)(NSError *error))failure;

@end

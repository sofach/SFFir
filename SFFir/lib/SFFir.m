//
//  SFFir.m
//  SFFir
//
//  Created by 陈少华 on 15/10/22.
//  Copyright © 2015年 sofach. All rights reserved.
//
#import <AFNetworking.h>

#import "SFFir.h"

#define FIRBaseUrl @"http://api.fir.im/apps"

@interface SFFir () <UIAlertViewDelegate>

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *apiToken;
@property (strong, nonatomic) NSString *curentVersion;
@property (strong, nonatomic) NSString *updateUrl;
@property (assign, nonatomic) BOOL alerted;

@end

@implementation SFFir

+ (instancetype)sharedInstence
{
    static id sharedInstence = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstence = [[self alloc] init];
    });
    return sharedInstence;
}

- (id)init
{
    self = [super init];
    if (self) {
        _operationManager = [AFHTTPRequestOperationManager manager];
        _curentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    }
    return self;
}

- (AFHTTPRequestOperation *)getLatestVersionWithAppId:(NSString *)appid apiToken:(NSString *)token sucess:(void(^)(SFFirVersion *version))sucess failure:(void(^)(NSError *error))failure
{
    _apiToken = token;
    _appId = appid;
    return [_operationManager GET:[NSString stringWithFormat:@"%@/latest/%@", FIRBaseUrl, appid] parameters:@{@"api_token": token?token:@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucess) {
            SFFirVersion *version = [[SFFirVersion alloc] initWithDictionary:responseObject];
            sucess(version);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)autoUpdateWithAppId:(NSString *)appid apiToken:(NSString *)token alertConfig:(void(^)(UIAlertView *alert, SFFirVersion *version))alertConfig
{
    if (_alerted) {
        return;
    }
    [self getLatestVersionWithAppId:appid apiToken:token sucess:^(SFFirVersion *version) {
        if (version) {
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
            if ([version.version compare:localVersion] == NSOrderedDescending) {
                _alerted = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"新版本（%@）", version.version?version.version:@""] message:[NSString stringWithFormat:@"%@", version.changelog?version.changelog:@"暂无更新日志"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                _updateUrl = version.installUrl;
                if (alertConfig) {
                    alertConfig(alert, version);
                }
            http://download.fir.im/apps/:id/install
                [alert show];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"error: fir get latest version failed:%@", error);
    }];
}

- (void)autoUpdateWithAppId:(NSString *)appid apiToken:(NSString *)token
{
    if (_alerted) {
        return;
    }
    [self autoUpdateWithAppId:appid apiToken:token alertConfig:nil];
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //http://download.fir.im/apps/:id/install
    if (buttonIndex == 1) {
        [_operationManager GET:[NSString stringWithFormat:@"http://api.fir.im/apps/%@/download_token", _appId] parameters:@{@"api_token": _apiToken?_apiToken:@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [_operationManager POST:[NSString stringWithFormat:@"http://download.fir.im/apps/%@/install", _appId] parameters:responseObject success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *plist_id = [responseObject objectForKey:@"url"];
                if (plist_id) {
                    NSString *itemsUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://fir.im/plists/%@", plist_id];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itemsUrl]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error: fir get plist_id failed:%@", error);
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: fir get download_token failed:%@", error);
        }];
    }
}

@end

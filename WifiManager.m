//
//  WifiManager.m
//  ConfigWifiTool
//
//  Created by 吴志和 on 16/10/30.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "WifiManager.h"

@implementation WiFiModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ssid forKey:NSStringFromSelector(@selector(ssid))];
    [aCoder encodeObject:self.pwd forKey:NSStringFromSelector(@selector(pwd))];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.ssid = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(ssid))];
        self.pwd = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(pwd))];
    }
    return self;
}

@end

@interface WifiManager()

@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, WiFiModel *> *wifis;

@end

@implementation WifiManager

static WifiManager *manager = nil;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (instancetype)manager
{
    return manager ? : [[self alloc] init];
}

+ (void)load
{
    WifiManager *manager = [WifiManager manager];
    manager.wifis = [NSKeyedUnarchiver unarchiveObjectWithFile:[manager wifiDataPath]];
    if (!manager.wifis) {
        manager.wifis = @{}.mutableCopy;
    }
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [manager saveWifiData];
    }];
}

- (void)addWifi:(NSString *)ssid pwd:(NSString *)pwd
{
    if (ssid.length == 0 || pwd.length == 0) {
        return;
    }
    WiFiModel *model = [[WiFiModel alloc] init];
    model.ssid = ssid;
    model.pwd = pwd;
    self.wifis[ssid] = model;
}

- (void)saveWifiData
{
    [NSKeyedArchiver archiveRootObject:self.wifis toFile:[self wifiDataPath]];
}

- (NSString *)wifiDataPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"wifiDataPath"];
}

@end

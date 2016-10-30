//
//  WifiManager.h
//  ConfigWifiTool
//
//  Created by 吴志和 on 16/10/30.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WiFiModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, copy) NSString *pwd;

@end

@interface WifiManager : NSObject

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, WiFiModel *> *wifis;

+ (instancetype)manager;
- (void)addWifi:(NSString *)ssid pwd:(NSString *)pwd;

@end

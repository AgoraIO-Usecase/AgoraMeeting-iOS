//
//  TestVC.m
//  VideoConference
//
//  Created by ZYP on 2021/8/27.
//  Copyright © 2021 agora. All rights reserved.
//

#import "TestVC.h"
#import <AgoraMeetingSDK/AgoraMeetingSDK-Swift.h>
#import <AgoraMeetingContext/AgoraMeetingContext-Swift.h>
#import "TokenBuilder.h"
#import "KeyCenter.h"

@interface TestVC ()<ExitRoomDelegate, NetworkQualityDelegate>
@property (nonatomic, strong) MeetingSDK *sdk;
@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *token = [TokenBuilder buildToken:KeyCenter.agoraAppid
              appCertificate:KeyCenter.appCertificate
                    userUuid:@"E2C5EC8F-FEE0-4DED-AB0A-954EAEA28F8F"];
    __weak TestVC *weakSelf = self;
    MeetingConfig *config = [[MeetingConfig alloc] initWithAppId:KeyCenter.agoraAppid
                                                        logLevel:LogLevelAll];

    _sdk = [[MeetingSDK alloc] initWithConfig:config];
    
    _sdk.exitRoomDelegate = self;
    _sdk.networkQualityDelegate = self;
    LaunchConfig *launchConfig = [[LaunchConfig alloc] initWithUserId:@"E2C5EC8F-FEE0-4DED-AB0A-954EAEA28F8F"
                                                             userName:@"666"
                                                               roomId:@"6412121cbb2dc2cb9e460cfee7046be2"
                                                             roomName:@"10086"
                                                         roomPassword:@""
                                                             duration:45 * 60
                                                            maxPeople:1000
                                                           openCamera:true
                                                              openMic:true
                                                                token:token
                                                 userInoutLimitNumber:10
                                                  localUserProperties:@{}];
    
    [_sdk launchWithLaunchConfig:launchConfig
                        success:^(AgoraMeetingUI *nvc) {
        UINavigationController *b = (UINavigationController *)nvc;
        [weakSelf presentViewController:b
                               animated:true
                             completion:nil];
    } fail:^(MeetingError * error) {

    }];
    
    NSString *name = MeetingSDK.getRtcVersionName;
}

- (void)onExitWithCache:(RoomCache * _Nonnull)cache {
    NSString *d = cache.roomInfo.roomName;
    
}


- (void)networkQuailtyDidUpdateWithQuality:(enum NetworkQuality)quality {
    NetworkQuality *d = quality;
}


@end

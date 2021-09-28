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
                    userUuid:@"341231231"];
    __weak TestVC *weakSelf = self;
    MeetingConfig *config = [[MeetingConfig alloc] initWithAppId:KeyCenter.agoraAppid
                                                        logLevel:LogLevelAll];

    _sdk = [[MeetingSDK alloc] initWithConfig:config];
    
    _sdk.exitRoomDelegate = self;
    _sdk.networkQualityDelegate = self;
    LaunchConfig *launchConfig = [[LaunchConfig alloc] initWithUserId:@"341231231"
                                                             userName:@"1213413"
                                                               roomId:@"124124134"
                                                             roomName:@"12312341"
                                                         roomPassword:@""
                                                             duration:45 * 60
                                                            maxPeople:1000
                                                           openCamera:true
                                                              openMic:true
                                                                token:token
                                                 userInoutLimitNumber:10
                                                  localUserProperties:@{}
                                                        flexRoomProps:@{}];
    
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

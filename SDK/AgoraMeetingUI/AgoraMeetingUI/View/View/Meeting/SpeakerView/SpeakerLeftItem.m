//
//  SpeakerLeftItem.m
//  VideoConference
//
//  Created by ZYP on 2020/12/30.
//  Copyright © 2020 agora. All rights reserved.
//

#import "SpeakerLeftItem.h"
#import "UIColor+AppColor.h"
#import "NibInitProtocol.h"
#import "SpeakerModel.h"
#import "NSBundle+Extension.h"
#import "UIImage+Extension.h"

@interface SpeakerLeftItem()<NibInitProtocol>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hostViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioViewLeadingConstraint;

@end

@implementation SpeakerLeftItem

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 22/2;
}

+ (instancetype)instanceFromNib {
    NSString *className = NSStringFromClass(SpeakerLeftItem.class);
    return [[NSBundle meetingUIBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

- (void)setModel:(SpeakerModel *)model {
    
    BOOL hasShare = model.type == SpeakerModelTypeScreen || model.type == SpeakerModelTypeBoard;
    if (model.isHost && hasShare) {
        [_hostView setHidden:false];
        [_shareView setHidden:false];
        _shareLeadingConstraint.constant = 22;
        _audioViewLeadingConstraint.constant = 44;
    }
    
    if (model.isHost && !hasShare) {
        [_hostView setHidden:false];
        [_shareView setHidden:true];
        _audioViewLeadingConstraint.constant = 22;
    }
    
    if (!model.isHost && hasShare) {
        _shareLeadingConstraint.constant = 0;
        [_hostView setHidden:true];
        [_shareView setHidden:false];
        _audioViewLeadingConstraint.constant = 22;
    }
    
    if (!model.isHost && !hasShare) {
        [_hostView setHidden:true];
        [_shareView setHidden:true];
        _audioViewLeadingConstraint.constant = 0;
    }
    
    _shareView.image = [UIImage meetingUIImageName:@"state-share"];
    _audioView.image = model.hasAudio ? [UIImage meetingUIImageName:@"state-unmute"] : [UIImage meetingUIImageName:@"state-mute"];
    _titleLabel.text = model.name;
    [self layoutIfNeeded];
}

@end

//
//  UIImage+Extension.m
//  AgoraMeetingUI
//
//  Created by ZYP on 2021/6/7.
//

#import "UIImage+Extension.h"
#import "NSBundle+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)meetingUIImageName:(NSString *)name {
    return [UIImage imageNamed:name
                      inBundle:NSBundle.meetingUIBundle
 compatibleWithTraitCollection:nil];
}

@end

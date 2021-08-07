//
//  NSBundle+Extension.m
//  AgoraMeetingCore
//
//  Created by ZYP on 2021/6/7.
//

#import "NSBundle+Extension.h"

@implementation MeetingUIEmptyClass

@end

@implementation NSBundle (Extension)

+ (NSBundle *)meetingUIBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[MeetingUIEmptyClass class]];
    NSString *path = [bundle pathForResource:@"AgoraMeetingUI" ofType:@"bundle"];
    return [NSBundle bundleWithPath:path];
}

@end

//
//  NSDate+GetDescription.m
//  TigerEvent
//
//  Created by Siyang Liu on 2018/10/13.
//  Copyright © 2018 SiyangLiu. All rights reserved.
//

#import "NSDate+GetDescription.h"

@implementation NSDate (GetDescription)

- (NSString *)getDescription {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:-6];
    return [formatter stringFromDate:self];
}

@end

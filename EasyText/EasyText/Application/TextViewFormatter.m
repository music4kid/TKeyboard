//
//  TextViewFormatter.m
//  EasyText
//
//  Created by gao feng on 2016/10/22.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "TextViewFormatter.h"

//todo: use protobuf

#define kSeparatorChar @"¤"

@implementation TextPayload
@end

@implementation TextViewFormatter

+ (NSString*)encodeTextPayload:(TextPayload*)payload {
    NSString* str = [NSString stringWithFormat:@"%d%@%d%@%@%@%@", (int)payload.range.location, kSeparatorChar,
                     (int)payload.range.length, kSeparatorChar,
                     payload.text, kSeparatorChar,
                     payload.affectedText];
    return str;
}

+ (TextPayload*)decodeTextPayloadString:(NSString*)str {
    TextPayload* payload = [TextPayload new];
    NSArray* arr = [str componentsSeparatedByString:kSeparatorChar];
    if (arr.count < 4) {
        return nil;
    }
    int loc = [arr[0] intValue];
    int len = [arr[1] intValue];
    
    NSString* text = arr[2];
    payload.range = NSMakeRange(loc, len);
    payload.text = text;
    
    NSString* affectedText = arr[3];
    if (affectedText.length > 0) {
        payload.affectedText = affectedText;
    }
    return payload;
}



@end
